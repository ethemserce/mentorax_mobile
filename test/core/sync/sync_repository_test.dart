import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mentorax/core/database/app_database.dart';
import 'package:mentorax/core/sync/sync_models.dart';
import 'package:mentorax/core/sync/sync_repository.dart';
import 'package:mentorax/core/sync/sync_service.dart';
import 'package:mentorax/features/dashboard/data/dashboard_local_data_source.dart';
import 'package:mentorax/features/dashboard/data/models/next_session_model.dart';

void main() {
  late AppDatabase database;
  late DashboardLocalDataSource dashboardLocal;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    dashboardLocal = DashboardLocalDataSource(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('pushes pending operations and marks local session synced', () async {
    final session = _session();
    await dashboardLocal.cacheNextSession(session);
    await dashboardLocal.markSessionStartedLocally(
      session.sessionId,
      startedAtUtc: DateTime.utc(2026, 5, 1, 9),
    );

    final service = _FakeSyncService(
      response: (operations) =>
          _response(operations, statusFor: (_) => 'applied'),
    );
    final repository = SyncRepository(database: database, service: service);

    final result = await repository.pushPendingOperations();

    final outboxOperation = await database
        .select(database.syncOutbox)
        .getSingle();
    final localSession = await database
        .select(database.localStudySessions)
        .getSingle();

    expect(service.operations, hasLength(1));
    expect(service.operations.single.id, 'start-session-${session.sessionId}');
    expect(result.attemptedCount, 1);
    expect(result.syncedCount, 1);
    expect(result.retryCount, 0);
    expect(outboxOperation.status, 'synced');
    expect(outboxOperation.lastError, isNull);
    expect(outboxOperation.nextAttemptAtUtc, isNull);
    expect(localSession.syncStatus, 'synced');
  });

  test('keeps pending operations retryable when push fails', () async {
    final session = _session();
    await dashboardLocal.cacheNextSession(session);
    await dashboardLocal.markSessionStartedLocally(
      session.sessionId,
      startedAtUtc: DateTime.utc(2026, 5, 1, 9),
    );

    final repository = SyncRepository(
      database: database,
      service: _ThrowingSyncService(),
    );

    final result = await repository.pushPendingOperations();

    final outboxOperation = await database
        .select(database.syncOutbox)
        .getSingle();
    final localSession = await database
        .select(database.localStudySessions)
        .getSingle();

    expect(result.attemptedCount, 1);
    expect(result.syncedCount, 0);
    expect(result.retryCount, 1);
    expect(outboxOperation.status, 'pending');
    expect(outboxOperation.retryCount, 1);
    expect(outboxOperation.lastError, contains('network unavailable'));
    expect(outboxOperation.nextAttemptAtUtc, isNotNull);
    expect(localSession.syncStatus, 'pending');
  });

  test(
    'does not mark a session synced while another operation is pending',
    () async {
      final session = _session();
      await dashboardLocal.cacheNextSession(session);
      await dashboardLocal.markSessionStartedLocally(
        session.sessionId,
        startedAtUtc: DateTime.utc(2026, 5, 1, 9),
      );
      await dashboardLocal.markSessionCompletedLocally(
        sessionId: session.sessionId,
        qualityScore: 5,
        difficultyScore: 2,
        actualDurationMinutes: 25,
        reviewNotes: null,
        completedAtUtc: DateTime.utc(2026, 5, 1, 9, 25),
      );

      final service = _FakeSyncService(
        response: (operations) => _response(
          operations,
          statusFor: (operation) =>
              operation.operationType == 'StudySessionStarted'
              ? 'applied'
              : 'failed',
          errorFor: (operation) =>
              operation.operationType == 'StudySessionCompleted'
              ? 'backend rejected completion'
              : null,
        ),
      );
      final repository = SyncRepository(database: database, service: service);

      final result = await repository.pushPendingOperations();

      final outboxOperations = await database.select(database.syncOutbox).get();
      final startedOperation = outboxOperations.singleWhere(
        (operation) => operation.operationType == 'StudySessionStarted',
      );
      final completedOperation = outboxOperations.singleWhere(
        (operation) => operation.operationType == 'StudySessionCompleted',
      );
      final localSession = await database
          .select(database.localStudySessions)
          .getSingle();

      expect(result.attemptedCount, 2);
      expect(result.syncedCount, 1);
      expect(result.retryCount, 1);
      expect(startedOperation.status, 'synced');
      expect(completedOperation.status, 'pending');
      expect(completedOperation.retryCount, 1);
      expect(completedOperation.lastError, 'backend rejected completion');
      expect(localSession.syncStatus, 'pending');
    },
  );
}

NextSessionModel _session() {
  return NextSessionModel(
    sessionId: 'session-1',
    studyPlanId: 'plan-1',
    materialId: 'material-1',
    materialTitle: 'Offline Material',
    scheduledAtUtc: DateTime.utc(2026, 5, 1, 8, 55),
    startedAtUtc: null,
    estimatedMinutes: 25,
    isDue: true,
  );
}

SyncPushResponse _response(
  List<SyncOutboxData> operations, {
  required String Function(SyncOutboxData operation) statusFor,
  String? Function(SyncOutboxData operation)? errorFor,
}) {
  return SyncPushResponse(
    serverTimeUtc: DateTime.utc(2026, 5, 1, 10),
    results: operations
        .map(
          (operation) => SyncPushOperationResult(
            operationId: operation.id,
            status: statusFor(operation),
            error: errorFor?.call(operation),
          ),
        )
        .toList(),
  );
}

class _FakeSyncService extends SyncService {
  final SyncPushResponse Function(List<SyncOutboxData> operations) response;
  List<SyncOutboxData> operations = const [];

  _FakeSyncService({required this.response});

  @override
  Future<SyncPushResponse> pushOperations(
    List<SyncOutboxData> operations,
  ) async {
    this.operations = operations;
    return response(operations);
  }
}

class _ThrowingSyncService extends SyncService {
  @override
  Future<SyncPushResponse> pushOperations(
    List<SyncOutboxData> operations,
  ) async {
    throw Exception('network unavailable');
  }
}
