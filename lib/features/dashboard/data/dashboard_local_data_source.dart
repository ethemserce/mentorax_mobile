import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:mentorax/core/database/app_database.dart';

import 'models/mobile_dashboard_model.dart';
import 'models/next_session_model.dart';

class DashboardLocalDataSource {
  final AppDatabase _database;

  DashboardLocalDataSource(this._database);

  Future<void> cacheNextSession(NextSessionModel session) async {
    final existing = await (_database.select(
      _database.localStudySessions,
    )..where((row) => row.id.equals(session.sessionId))).getSingleOrNull();

    if (existing?.syncStatus == 'pending') return;

    await _database
        .into(_database.localStudySessions)
        .insert(
          LocalStudySessionsCompanion.insert(
            id: session.sessionId,
            studyPlanId: session.studyPlanId,
            studyPlanItemId: Value(existing?.studyPlanItemId),
            learningMaterialId: session.materialId,
            materialTitle: Value(session.materialTitle),
            userId: Value(existing?.userId),
            studyProgressId: Value(existing?.studyProgressId),
            scheduledAtUtc: session.scheduledAtUtc,
            startedAtUtc: Value(session.startedAtUtc),
            isCompleted: const Value(false),
            sequenceNumber: Value(existing?.sequenceNumber ?? 0),
            plannedDurationMinutes: Value(session.estimatedMinutes),
            status: Value(
              session.startedAtUtc == null ? 'Pending' : 'InProgress',
            ),
            syncStatus: const Value('synced'),
            updatedAtUtc: Value(DateTime.now().toUtc()),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<NextSessionModel?> markSessionStartedLocally(
    String sessionId, {
    DateTime? startedAtUtc,
  }) async {
    final existing = await (_database.select(
      _database.localStudySessions,
    )..where((row) => row.id.equals(sessionId))).getSingleOrNull();

    if (existing == null) return null;

    final startedAt = startedAtUtc ?? DateTime.now().toUtc();

    await (_database.update(
      _database.localStudySessions,
    )..where((row) => row.id.equals(sessionId))).write(
      LocalStudySessionsCompanion(
        startedAtUtc: Value(startedAt),
        status: const Value('InProgress'),
        syncStatus: const Value('pending'),
        updatedAtUtc: Value(DateTime.now().toUtc()),
      ),
    );

    await _database
        .into(_database.syncOutbox)
        .insert(
          SyncOutboxCompanion.insert(
            id: 'start-session-$sessionId',
            operationType: 'StudySessionStarted',
            entityType: 'StudySession',
            entityId: sessionId,
            payload: jsonEncode({
              'sessionId': sessionId,
              'startedAtUtc': startedAt.toIso8601String(),
            }),
            createdAtUtc: startedAt,
            updatedAtUtc: Value(DateTime.now().toUtc()),
          ),
          mode: InsertMode.insertOrReplace,
        );

    final updated = await (_database.select(
      _database.localStudySessions,
    )..where((row) => row.id.equals(sessionId))).getSingle();

    return _toNextSessionModel(updated);
  }

  Future<void> markSessionStartSynced(String sessionId) async {
    await (_database.update(
      _database.localStudySessions,
    )..where((row) => row.id.equals(sessionId))).write(
      LocalStudySessionsCompanion(
        syncStatus: const Value('synced'),
        updatedAtUtc: Value(DateTime.now().toUtc()),
      ),
    );

    await (_database.update(
      _database.syncOutbox,
    )..where((row) => row.id.equals('start-session-$sessionId'))).write(
      SyncOutboxCompanion(
        status: const Value('synced'),
        updatedAtUtc: Value(DateTime.now().toUtc()),
      ),
    );
  }

  Future<bool> markSessionCompletedLocally({
    required String sessionId,
    required int qualityScore,
    required int difficultyScore,
    required int actualDurationMinutes,
    required String? reviewNotes,
    DateTime? completedAtUtc,
  }) async {
    final existing = await (_database.select(
      _database.localStudySessions,
    )..where((row) => row.id.equals(sessionId))).getSingleOrNull();

    if (existing == null) return false;

    final completedAt = completedAtUtc ?? DateTime.now().toUtc();

    await (_database.update(
      _database.localStudySessions,
    )..where((row) => row.id.equals(sessionId))).write(
      LocalStudySessionsCompanion(
        completedAtUtc: Value(completedAt),
        isCompleted: const Value(true),
        qualityScore: Value(qualityScore),
        difficultyScore: Value(difficultyScore),
        actualDurationMinutes: Value(actualDurationMinutes),
        reviewNotes: Value(reviewNotes),
        status: const Value('Completed'),
        syncStatus: const Value('pending'),
        updatedAtUtc: Value(DateTime.now().toUtc()),
      ),
    );

    await _database
        .into(_database.syncOutbox)
        .insert(
          SyncOutboxCompanion.insert(
            id: 'complete-session-$sessionId',
            operationType: 'StudySessionCompleted',
            entityType: 'StudySession',
            entityId: sessionId,
            payload: jsonEncode({
              'sessionId': sessionId,
              'qualityScore': qualityScore,
              'difficultyScore': difficultyScore,
              'actualDurationMinutes': actualDurationMinutes,
              'reviewNotes': reviewNotes,
              'completedAtUtc': completedAt.toIso8601String(),
            }),
            createdAtUtc: completedAt,
            updatedAtUtc: Value(DateTime.now().toUtc()),
          ),
          mode: InsertMode.insertOrReplace,
        );

    return true;
  }

  Future<void> markSessionCompleteSynced(String sessionId) async {
    await (_database.update(
      _database.localStudySessions,
    )..where((row) => row.id.equals(sessionId))).write(
      LocalStudySessionsCompanion(
        syncStatus: const Value('synced'),
        updatedAtUtc: Value(DateTime.now().toUtc()),
      ),
    );

    await (_database.update(
      _database.syncOutbox,
    )..where((row) => row.id.equals('complete-session-$sessionId'))).write(
      SyncOutboxCompanion(
        status: const Value('synced'),
        updatedAtUtc: Value(DateTime.now().toUtc()),
      ),
    );
  }

  Future<NextSessionModel?> getNextSession() async {
    final row = await _nextPendingSessionRow();
    if (row == null) return null;

    return _toNextSessionModel(row);
  }

  Future<MobileDashboardModel?> getDashboard() async {
    final sessions = await (_database.select(
      _database.localStudySessions,
    )..where((row) => row.isDeleted.equals(false))).get();

    if (sessions.isEmpty) return null;

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final tomorrowStart = todayStart.add(const Duration(days: 1));

    final todaySessions = sessions.where((session) {
      final localScheduledAt = session.scheduledAtUtc.toLocal();
      return !localScheduledAt.isBefore(todayStart) &&
          localScheduledAt.isBefore(tomorrowStart);
    }).toList();

    final nextSession = await getNextSession();

    return MobileDashboardModel(
      dueCount: todaySessions
          .where(
            (session) =>
                !session.isCompleted &&
                !session.scheduledAtUtc.isAfter(DateTime.now().toUtc()),
          )
          .length,
      todayPlannedMinutes: todaySessions.fold<int>(
        0,
        (total, session) => total + session.plannedDurationMinutes,
      ),
      todayCompletedMinutes: todaySessions.fold<int>(
        0,
        (total, session) => total + (session.actualDurationMinutes ?? 0),
      ),
      nextSession: nextSession,
      weakMaterials: const [],
    );
  }

  Future<LocalStudySession?> _nextPendingSessionRow() {
    return (_database.select(_database.localStudySessions)
          ..where(
            (row) =>
                row.isCompleted.equals(false) & row.isDeleted.equals(false),
          )
          ..orderBy([(row) => OrderingTerm.asc(row.scheduledAtUtc)])
          ..limit(1))
        .getSingleOrNull();
  }
}

NextSessionModel _toNextSessionModel(LocalStudySession session) {
  final now = DateTime.now().toUtc();

  return NextSessionModel(
    sessionId: session.id,
    studyPlanId: session.studyPlanId,
    materialId: session.learningMaterialId,
    materialTitle: session.materialTitle ?? 'Study session',
    scheduledAtUtc: session.scheduledAtUtc,
    startedAtUtc: session.startedAtUtc,
    estimatedMinutes: session.plannedDurationMinutes,
    isDue: !session.scheduledAtUtc.isAfter(now),
  );
}
