import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mentorax/core/database/app_database.dart';
import 'package:mentorax/features/dashboard/data/dashboard_local_data_source.dart';
import 'package:mentorax/features/dashboard/data/dashboard_repository.dart';
import 'package:mentorax/features/dashboard/data/dashboard_service.dart';
import 'package:mentorax/features/dashboard/data/models/next_session_model.dart';

void main() {
  late AppDatabase database;
  late DashboardLocalDataSource local;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    local = DashboardLocalDataSource(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('starts cached sessions locally when remote start fails', () async {
    final session = _session();
    final repository = DashboardRepository(
      service: _FailingDashboardService(),
      local: local,
    );

    await local.cacheNextSession(session);

    final started = await repository.startSession(session.sessionId);
    final localSession = await database
        .select(database.localStudySessions)
        .getSingle();
    final outboxOperation = await database
        .select(database.syncOutbox)
        .getSingle();

    expect(started.sessionId, session.sessionId);
    expect(started.startedAtUtc, isNotNull);
    expect(localSession.startedAtUtc, isNotNull);
    expect(localSession.syncStatus, 'pending');
    expect(localSession.status, 'InProgress');
    expect(outboxOperation.operationType, 'StudySessionStarted');
    expect(outboxOperation.status, 'pending');
  });

  test(
    'marks local session start as synced when remote start succeeds',
    () async {
      final session = _session();
      final repository = DashboardRepository(
        service: _SuccessfulDashboardService(),
        local: local,
      );

      await local.cacheNextSession(session);

      final started = await repository.startSession(session.sessionId);
      final localSession = await database
          .select(database.localStudySessions)
          .getSingle();
      final outboxOperation = await database
          .select(database.syncOutbox)
          .getSingle();

      expect(started.startedAtUtc, isNotNull);
      expect(localSession.syncStatus, 'synced');
      expect(outboxOperation.status, 'synced');
    },
  );

  test(
    'completes cached sessions locally when remote complete fails',
    () async {
      final session = _session();
      final repository = DashboardRepository(
        service: _FailingDashboardService(),
        local: local,
      );

      await local.cacheNextSession(session);

      await repository.completeSession(
        sessionId: session.sessionId,
        qualityScore: 4,
        difficultyScore: 3,
        actualDurationMinutes: 22,
        reviewNotes: 'Offline completion',
      );

      final localSession = await database
          .select(database.localStudySessions)
          .getSingle();
      final outboxOperation = await database
          .select(database.syncOutbox)
          .getSingle();
      final nextSession = await local.getNextSession();

      expect(localSession.isCompleted, isTrue);
      expect(localSession.completedAtUtc, isNotNull);
      expect(localSession.qualityScore, 4);
      expect(localSession.difficultyScore, 3);
      expect(localSession.actualDurationMinutes, 22);
      expect(localSession.reviewNotes, 'Offline completion');
      expect(localSession.syncStatus, 'pending');
      expect(outboxOperation.operationType, 'StudySessionCompleted');
      expect(outboxOperation.status, 'pending');
      expect(nextSession, isNull);
    },
  );

  test(
    'marks local session completion as synced when remote complete succeeds',
    () async {
      final session = _session();
      final repository = DashboardRepository(
        service: _SuccessfulDashboardService(),
        local: local,
      );

      await local.cacheNextSession(session);

      await repository.completeSession(
        sessionId: session.sessionId,
        qualityScore: 5,
        difficultyScore: 2,
        actualDurationMinutes: 25,
        reviewNotes: null,
      );

      final localSession = await database
          .select(database.localStudySessions)
          .getSingle();
      final outboxOperation = await database
          .select(database.syncOutbox)
          .getSingle();

      expect(localSession.isCompleted, isTrue);
      expect(localSession.syncStatus, 'synced');
      expect(outboxOperation.status, 'synced');
    },
  );
}

NextSessionModel _session() {
  return NextSessionModel(
    sessionId: 'session-1',
    studyPlanId: 'plan-1',
    materialId: 'material-1',
    materialTitle: 'Offline Material',
    scheduledAtUtc: DateTime.now().toUtc().subtract(const Duration(minutes: 5)),
    startedAtUtc: null,
    estimatedMinutes: 25,
    isDue: true,
  );
}

class _FailingDashboardService extends DashboardService {
  @override
  Future<NextSessionModel> startSession(String sessionId) {
    throw Exception('network unavailable');
  }

  @override
  Future<void> completeSession({
    required String sessionId,
    required int qualityScore,
    required int difficultyScore,
    required int actualDurationMinutes,
    required String? reviewNotes,
  }) {
    throw Exception('network unavailable');
  }
}

class _SuccessfulDashboardService extends DashboardService {
  @override
  Future<NextSessionModel> startSession(String sessionId) async {
    final startedAt = DateTime.now().toUtc();

    return NextSessionModel(
      sessionId: sessionId,
      studyPlanId: 'plan-1',
      materialId: 'material-1',
      materialTitle: 'Offline Material',
      scheduledAtUtc: startedAt.subtract(const Duration(minutes: 5)),
      startedAtUtc: startedAt,
      estimatedMinutes: 25,
      isDue: true,
    );
  }

  @override
  Future<void> completeSession({
    required String sessionId,
    required int qualityScore,
    required int difficultyScore,
    required int actualDurationMinutes,
    required String? reviewNotes,
  }) async {}
}
