import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mentorax/core/database/app_database.dart';
import 'package:mentorax/features/progress/data/models/mobile_progress_summary_model.dart';
import 'package:mentorax/features/progress/data/progress_local_data_source.dart';
import 'package:mentorax/features/progress/data/progress_repository.dart';
import 'package:mentorax/features/progress/data/progress_service.dart';

void main() {
  late AppDatabase database;
  late ProgressLocalDataSource local;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    local = ProgressLocalDataSource(
      database,
      now: () => DateTime(2026, 5, 2, 12),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('builds progress summary from local completed sessions', () async {
    await _seedProgressData(database);

    final summary = await local.getSummary();

    expect(summary.totalMaterials, 3);
    expect(summary.activePlans, 2);
    expect(summary.strongCount, 1);
    expect(summary.mediumCount, 1);
    expect(summary.weakCount, 1);
    expect(summary.todayCompletedSessions, 2);
    expect(summary.currentStreakDays, 2);
  });

  test('repository falls back to local summary when remote fails', () async {
    await _seedProgressData(database);

    final repository = ProgressRepository(
      service: _FailingProgressService(),
      local: local,
    );

    final summary = await repository.getSummary();

    expect(summary.todayCompletedSessions, 2);
    expect(summary.currentStreakDays, 2);
    expect(summary.strongCount, 1);
  });

  test('returns an empty local summary when no offline data exists', () async {
    final summary = await local.getSummary();

    expect(summary.totalMaterials, 0);
    expect(summary.activePlans, 0);
    expect(summary.todayCompletedSessions, 0);
    expect(summary.currentStreakDays, 0);
  });
}

Future<void> _seedProgressData(AppDatabase database) async {
  await database.batch((batch) {
    batch.insertAll(database.localMaterials, [
      _material(id: 'material-strong'),
      _material(id: 'material-medium'),
      _material(id: 'material-weak'),
      _material(id: 'material-deleted', isDeleted: true),
    ]);

    batch.insertAll(database.localStudyPlans, [
      _plan(id: 'plan-strong', materialId: 'material-strong'),
      _plan(id: 'plan-medium', materialId: 'material-medium'),
      _plan(id: 'plan-paused', materialId: 'material-weak', status: 'Paused'),
      _plan(id: 'plan-deleted', materialId: 'material-weak', isDeleted: true),
    ]);

    batch.insertAll(database.localStudySessions, [
      _completedSession(
        id: 'session-strong-today',
        planId: 'plan-strong',
        materialId: 'material-strong',
        completedAtUtc: DateTime.utc(2026, 5, 2, 8),
        qualityScore: 5,
      ),
      _completedSession(
        id: 'session-strong-yesterday',
        planId: 'plan-strong',
        materialId: 'material-strong',
        completedAtUtc: DateTime.utc(2026, 5, 1, 8),
        qualityScore: 4,
      ),
      _completedSession(
        id: 'session-medium-today',
        planId: 'plan-medium',
        materialId: 'material-medium',
        completedAtUtc: DateTime.utc(2026, 5, 2, 9),
        qualityScore: 3,
      ),
      _completedSession(
        id: 'session-weak-yesterday',
        planId: 'plan-paused',
        materialId: 'material-weak',
        completedAtUtc: DateTime.utc(2026, 5, 1, 9),
        qualityScore: 2,
      ),
      LocalStudySessionsCompanion.insert(
        id: 'session-pending',
        studyPlanId: 'plan-medium',
        learningMaterialId: 'material-medium',
        scheduledAtUtc: DateTime.utc(2026, 5, 2, 11),
        isCompleted: const Value(false),
      ),
    ]);
  });
}

LocalMaterialsCompanion _material({
  required String id,
  bool isDeleted = false,
}) {
  return LocalMaterialsCompanion.insert(
    id: id,
    userId: 'user-1',
    title: id,
    materialType: 'Text',
    content: '$id content',
    estimatedDurationMinutes: 20,
    isDeleted: Value(isDeleted),
  );
}

LocalStudyPlansCompanion _plan({
  required String id,
  required String materialId,
  String status = 'Active',
  bool isDeleted = false,
}) {
  return LocalStudyPlansCompanion.insert(
    id: id,
    userId: 'user-1',
    learningMaterialId: materialId,
    title: id,
    startDate: '2026-05-01',
    dailyTargetMinutes: 20,
    status: status,
    isDeleted: Value(isDeleted),
  );
}

LocalStudySessionsCompanion _completedSession({
  required String id,
  required String planId,
  required String materialId,
  required DateTime completedAtUtc,
  required int qualityScore,
}) {
  return LocalStudySessionsCompanion.insert(
    id: id,
    studyPlanId: planId,
    learningMaterialId: materialId,
    scheduledAtUtc: completedAtUtc.subtract(const Duration(minutes: 20)),
    completedAtUtc: Value(completedAtUtc),
    isCompleted: const Value(true),
    actualDurationMinutes: const Value(20),
    qualityScore: Value(qualityScore),
    status: const Value('Completed'),
  );
}

class _FailingProgressService extends ProgressService {
  @override
  Future<MobileProgressSummaryModel> getSummary() {
    throw Exception('network unavailable');
  }
}
