import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mentorax/core/database/app_database.dart';
import 'package:mentorax/core/sync/sync_models.dart';
import 'package:mentorax/core/sync/sync_repository.dart';
import 'package:mentorax/core/sync/sync_service.dart';
import 'package:mentorax/core/sync/sync_state_storage.dart';
import 'package:mentorax/features/dashboard/data/dashboard_local_data_source.dart';
import 'package:mentorax/features/dashboard/data/models/next_session_model.dart';
import 'package:mentorax/features/materials/data/material_local_data_source.dart';
import 'package:mentorax/features/study_plans/data/study_plan_local_data_source.dart';
import 'package:mentorax/features/study_sessions/data/study_session_local_data_source.dart';

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

  test('marks terminal conflicts without scheduling retries', () async {
    final session = _session();
    await dashboardLocal.cacheNextSession(session);
    await dashboardLocal.markSessionStartedLocally(
      session.sessionId,
      startedAtUtc: DateTime.utc(2026, 5, 1, 9),
    );

    final service = _FakeSyncService(
      response: (operations) => _response(
        operations,
        statusFor: (_) => 'conflict',
        errorFor: (_) => 'study_plan_not_active: Plan is not active.',
      ),
    );
    final repository = SyncRepository(database: database, service: service);

    final result = await repository.pushPendingOperations();

    final outboxOperation = await database
        .select(database.syncOutbox)
        .getSingle();
    final localSession = await database
        .select(database.localStudySessions)
        .getSingle();

    expect(result.attemptedCount, 1);
    expect(result.syncedCount, 0);
    expect(result.retryCount, 0);
    expect(result.conflictCount, 1);
    expect(outboxOperation.status, 'conflict');
    expect(outboxOperation.retryCount, 0);
    expect(outboxOperation.lastError, contains('study_plan_not_active'));
    expect(outboxOperation.nextAttemptAtUtc, isNull);
    expect(localSession.syncStatus, 'conflict');
  });

  test(
    'pushes study plan lifecycle operations and marks plan synced',
    () async {
      await database
          .into(database.localStudyPlans)
          .insert(
            LocalStudyPlansCompanion.insert(
              id: 'plan-1',
              userId: 'user-1',
              learningMaterialId: 'material-1',
              title: 'Offline Plan',
              startDate: '2026-05-01',
              dailyTargetMinutes: 25,
              status: 'Paused',
              syncStatus: const Value('pending'),
              updatedAtUtc: Value(DateTime.utc(2026, 5, 1, 9)),
            ),
          );
      await database
          .into(database.syncOutbox)
          .insert(
            SyncOutboxCompanion.insert(
              id: 'pause-plan-plan-1',
              operationType: 'StudyPlanPaused',
              entityType: 'StudyPlan',
              entityId: 'plan-1',
              payload: '{"planId":"plan-1"}',
              createdAtUtc: DateTime.utc(2026, 5, 1, 9),
            ),
          );

      final service = _FakeSyncService(
        response: (operations) =>
            _response(operations, statusFor: (_) => 'applied'),
      );
      final repository = SyncRepository(database: database, service: service);

      final result = await repository.pushPendingOperations();

      final localPlan = await database
          .select(database.localStudyPlans)
          .getSingle();
      final outboxOperation = await database
          .select(database.syncOutbox)
          .getSingle();

      expect(service.operations.single.operationType, 'StudyPlanPaused');
      expect(result.syncedCount, 1);
      expect(localPlan.syncStatus, 'synced');
      expect(outboxOperation.status, 'synced');
    },
  );

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

  test('synchronizes bootstrap data into the local study cache', () async {
    final service = _FakeSyncService(
      response: (operations) =>
          _response(operations, statusFor: (_) => 'applied'),
      bootstrapResponse: _bootstrap(),
    );
    final repository = SyncRepository(
      database: database,
      service: service,
      studyPlanLocal: StudyPlanLocalDataSource(database),
      dashboardLocal: dashboardLocal,
      materialLocal: MaterialLocalDataSource(database),
    );

    final result = await repository.synchronize();

    final materials = await database.select(database.localMaterials).get();
    final chunks = await database.select(database.localMaterialChunks).get();
    final plans = await database.select(database.localStudyPlans).get();
    final items = await database.select(database.localStudyPlanItems).get();
    final sessions = await database.select(database.localStudySessions).get();

    expect(result.attemptedCount, 0);
    expect(service.bootstrapCalled, isTrue);
    expect(materials, hasLength(1));
    expect(materials.single.title, 'Bootstrap Material');
    expect(chunks, hasLength(1));
    expect(chunks.single.title, 'Bootstrap Chunk');
    expect(plans, hasLength(1));
    expect(plans.single.title, 'Server Plan');
    expect(items, hasLength(1));
    expect(items.single.title, 'Server Item');
    expect(sessions, hasLength(1));
    expect(sessions.single.id, 'session-1');
    expect(sessions.single.studyPlanItemId, 'item-1');
    expect(sessions.single.syncStatus, 'synced');
  });

  test('skips bootstrap when push has retryable failures', () async {
    final session = _session();
    await dashboardLocal.cacheNextSession(session);
    await dashboardLocal.markSessionStartedLocally(
      session.sessionId,
      startedAtUtc: DateTime.utc(2026, 5, 1, 9),
    );

    final service = _FakeSyncService(
      response: (operations) => _response(
        operations,
        statusFor: (_) => 'failed',
        errorFor: (_) => 'backend rejected operation',
      ),
      bootstrapResponse: _bootstrap(),
    );
    final repository = SyncRepository(
      database: database,
      service: service,
      studyPlanLocal: StudyPlanLocalDataSource(database),
      dashboardLocal: dashboardLocal,
    );

    final result = await repository.synchronize();

    final plans = await database.select(database.localStudyPlans).get();
    final outboxOperation = await database
        .select(database.syncOutbox)
        .getSingle();

    expect(result.retryCount, 1);
    expect(service.bootstrapCalled, isFalse);
    expect(plans, isEmpty);
    expect(outboxOperation.status, 'pending');
    expect(outboxOperation.lastError, 'backend rejected operation');
  });

  test('terminal conflicts do not block delta pull reconciliation', () async {
    final session = _session();
    await dashboardLocal.cacheNextSession(session);
    await dashboardLocal.markSessionStartedLocally(
      session.sessionId,
      startedAtUtc: DateTime.utc(2026, 5, 1, 9),
    );

    final stateStorage = _FakeSyncStateStorage(
      lastSyncAt: DateTime.utc(2026, 5, 1, 9),
    );
    final service = _FakeSyncService(
      response: (operations) => _response(
        operations,
        statusFor: (_) => 'conflict',
        errorFor: (_) => 'study_plan_not_active: Plan is not active.',
      ),
      changesResponse: _changes(planTitle: 'Server Reconciled Plan'),
    );
    final repository = SyncRepository(
      database: database,
      service: service,
      stateStorage: stateStorage,
      studyPlanLocal: StudyPlanLocalDataSource(database),
      dashboardLocal: dashboardLocal,
    );

    final result = await repository.synchronize();

    final outboxOperation = await database
        .select(database.syncOutbox)
        .getSingle();
    final plans = await database.select(database.localStudyPlans).get();
    final localSession = await database
        .select(database.localStudySessions)
        .getSingle();

    expect(result.conflictCount, 1);
    expect(result.retryCount, 0);
    expect(service.changesCalled, isTrue);
    expect(outboxOperation.status, 'conflict');
    expect(plans.single.title, 'Server Reconciled Plan');
    expect(localSession.syncStatus, 'synced');
    expect(stateStorage.lastSyncAt, DateTime.utc(2026, 5, 1, 11));
  });

  test('applies delta changes when last sync state exists', () async {
    final stateStorage = _FakeSyncStateStorage(
      lastSyncAt: DateTime.utc(2026, 5, 1, 9),
    );
    final service = _FakeSyncService(
      response: (operations) =>
          _response(operations, statusFor: (_) => 'applied'),
      changesResponse: _changes(planTitle: 'Delta Plan'),
    );
    final repository = SyncRepository(
      database: database,
      service: service,
      stateStorage: stateStorage,
      studyPlanLocal: StudyPlanLocalDataSource(database),
      dashboardLocal: dashboardLocal,
    );

    await repository.synchronize();

    final plans = await database.select(database.localStudyPlans).get();

    expect(service.changesCalled, isTrue);
    expect(service.changesSince, DateTime.utc(2026, 5, 1, 9));
    expect(service.bootstrapCalled, isFalse);
    expect(plans, hasLength(1));
    expect(plans.single.title, 'Delta Plan');
    expect(stateStorage.lastSyncAt, DateTime.utc(2026, 5, 1, 11));
  });

  test('applies expanded delta changes into local caches', () async {
    final stateStorage = _FakeSyncStateStorage(
      lastSyncAt: DateTime.utc(2026, 5, 1, 9),
    );
    final service = _FakeSyncService(
      response: (operations) =>
          _response(operations, statusFor: (_) => 'applied'),
      changesResponse: _expandedChanges(),
    );
    final repository = SyncRepository(
      database: database,
      service: service,
      stateStorage: stateStorage,
      studyPlanLocal: StudyPlanLocalDataSource(database),
      dashboardLocal: dashboardLocal,
      materialLocal: MaterialLocalDataSource(database),
      studySessionLocal: StudySessionLocalDataSource(database),
    );

    await repository.synchronize();

    final materials = await database.select(database.localMaterials).get();
    final chunks = await database.select(database.localMaterialChunks).get();
    final sessions = await database.select(database.localStudySessions).get();

    expect(service.changesCalled, isTrue);
    expect(materials, hasLength(1));
    expect(materials.single.title, 'Delta Material');
    expect(chunks, hasLength(1));
    expect(chunks.single.title, 'Delta Chunk');
    expect(chunks.single.difficultyLevel, 3);
    expect(chunks.single.summary, 'Chunk summary');
    expect(sessions, hasLength(1));
    expect(sessions.single.id, 'session-1');
    expect(sessions.single.status, 'InProgress');
    expect(sessions.single.startedAtUtc?.toUtc(), DateTime.utc(2026, 5, 1, 9));
    expect(sessions.single.syncStatus, 'synced');
    expect(stateStorage.lastSyncAt, DateTime.utc(2026, 5, 1, 11));
  });

  test('applies delete delta changes into local caches', () async {
    await database
        .into(database.localMaterialChunks)
        .insert(
          LocalMaterialChunksCompanion.insert(
            id: 'chunk-delete',
            learningMaterialId: 'material-1',
            orderNo: 1,
            title: const Value('Deleted Chunk'),
            content: 'Deleted chunk content',
            difficultyLevel: 2,
            estimatedStudyMinutes: 15,
            characterCount: 21,
          ),
        );
    final stateStorage = _FakeSyncStateStorage(
      lastSyncAt: DateTime.utc(2026, 5, 1, 9),
    );
    final service = _FakeSyncService(
      response: (operations) =>
          _response(operations, statusFor: (_) => 'applied'),
      changesResponse: _deleteChanges(),
    );
    final materialLocal = MaterialLocalDataSource(database);
    final repository = SyncRepository(
      database: database,
      service: service,
      stateStorage: stateStorage,
      materialLocal: materialLocal,
    );

    await repository.synchronize();

    final visibleChunks = await materialLocal.getChunks('material-1');
    final deletedChunk = await database
        .select(database.localMaterialChunks)
        .getSingle();

    expect(service.changesCalled, isTrue);
    expect(visibleChunks, isEmpty);
    expect(deletedChunk.isDeleted, isTrue);
    expect(stateStorage.lastSyncAt, DateTime.utc(2026, 5, 1, 11));
  });

  test('falls back to bootstrap when delta pull fails', () async {
    final stateStorage = _FakeSyncStateStorage(
      lastSyncAt: DateTime.utc(2026, 5, 1, 9),
    );
    final service = _FakeSyncService(
      response: (operations) =>
          _response(operations, statusFor: (_) => 'applied'),
      bootstrapResponse: _bootstrap(planTitle: 'Bootstrap Fallback Plan'),
      throwOnChanges: true,
    );
    final repository = SyncRepository(
      database: database,
      service: service,
      stateStorage: stateStorage,
      studyPlanLocal: StudyPlanLocalDataSource(database),
      dashboardLocal: dashboardLocal,
    );

    await repository.synchronize();

    final plans = await database.select(database.localStudyPlans).get();

    expect(service.changesCalled, isTrue);
    expect(service.bootstrapCalled, isTrue);
    expect(plans, hasLength(1));
    expect(plans.single.title, 'Bootstrap Fallback Plan');
    expect(stateStorage.lastSyncAt, DateTime.utc(2026, 5, 1, 10));
  });
}

SyncChangesModel _deleteChanges() {
  return SyncChangesModel.fromJson({
    'serverTimeUtc': '2026-05-01T11:00:00Z',
    'changes': [
      {
        'entityType': 'MaterialChunk',
        'entityId': 'chunk-delete',
        'changeType': 'Delete',
        'changedAtUtc': '2026-05-01T10:40:00Z',
        'payload': {
          'id': 'chunk-delete',
          'deletedAtUtc': '2026-05-01T10:40:00Z',
        },
      },
    ],
  });
}

SyncChangesModel _expandedChanges() {
  return SyncChangesModel.fromJson({
    'serverTimeUtc': '2026-05-01T11:00:00Z',
    'changes': [
      {
        'entityType': 'Material',
        'entityId': 'material-1',
        'changeType': 'Upsert',
        'changedAtUtc': '2026-05-01T10:10:00Z',
        'payload': _materialJson(),
      },
      {
        'entityType': 'MaterialChunk',
        'entityId': 'chunk-1',
        'changeType': 'Upsert',
        'changedAtUtc': '2026-05-01T10:15:00Z',
        'payload': _chunkJson(),
      },
      {
        'entityType': 'StudySession',
        'entityId': 'session-1',
        'changeType': 'Upsert',
        'changedAtUtc': '2026-05-01T10:20:00Z',
        'payload': _sessionDetailJson(),
      },
    ],
  });
}

Map<String, dynamic> _materialJson({String title = 'Delta Material'}) {
  return {
    'id': 'material-1',
    'userId': 'user-1',
    'title': title,
    'materialType': 'Text',
    'content': 'Delta material content',
    'estimatedDurationMinutes': 45,
    'description': 'Material description',
    'tags': 'delta,sync',
    'hasActivePlan': true,
    'activePlanId': 'plan-1',
    'activePlanTitle': 'Delta Plan',
  };
}

Map<String, dynamic> _chunkJson({String title = 'Delta Chunk'}) {
  return {
    'id': 'chunk-1',
    'learningMaterialId': 'material-1',
    'orderNo': 1,
    'title': title,
    'content': 'Delta chunk content',
    'summary': 'Chunk summary',
    'keywords': 'delta',
    'difficultyLevel': 3,
    'estimatedStudyMinutes': 20,
    'characterCount': 19,
    'isGeneratedByAI': true,
  };
}

Map<String, dynamic> _sessionDetailJson() {
  return {
    'id': 'session-1',
    'studyPlanId': 'plan-1',
    'studyPlanItemId': 'item-1',
    'learningMaterialId': 'material-1',
    'materialChunkId': 'chunk-1',
    'planTitle': 'Delta Plan',
    'materialTitle': 'Delta Material',
    'chunkTitle': 'Delta Chunk',
    'chunkContent': 'Delta chunk content',
    'itemType': 'Study',
    'sequenceNumber': 1,
    'scheduledAtUtc': '2026-05-01T08:55:00Z',
    'startedAtUtc': '2026-05-01T09:00:00Z',
    'plannedDurationMinutes': 25,
    'status': 'InProgress',
    'completedAtUtc': null,
    'actualDurationMinutes': null,
    'notes': null,
  };
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

SyncChangesModel _changes({String planTitle = 'Delta Plan'}) {
  return SyncChangesModel.fromJson({
    'serverTimeUtc': '2026-05-01T11:00:00Z',
    'changes': [
      {
        'entityType': 'StudyPlan',
        'entityId': 'plan-1',
        'changeType': 'Upsert',
        'changedAtUtc': '2026-05-01T10:30:00Z',
        'payload': _planJson(title: planTitle),
      },
    ],
  });
}

SyncBootstrapModel _bootstrap({String planTitle = 'Server Plan'}) {
  return SyncBootstrapModel.fromJson({
    'serverTimeUtc': '2026-05-01T10:00:00Z',
    'studyPlans': [_planJson(title: planTitle)],
    'materials': [_materialJson(title: 'Bootstrap Material')],
    'materialChunks': [_chunkJson(title: 'Bootstrap Chunk')],
    'dashboard': {
      'dueCount': 1,
      'todayPlannedMinutes': 25,
      'todayCompletedMinutes': 0,
      'nextSession': _nextSessionJson(),
      'weakMaterials': const [],
    },
    'nextSession': _nextSessionJson(),
  });
}

Map<String, dynamic> _planJson({required String title}) {
  return {
    'id': 'plan-1',
    'userId': 'user-1',
    'learningMaterialId': 'material-1',
    'title': title,
    'startDate': '2026-05-01',
    'dailyTargetMinutes': 25,
    'status': 'Active',
    'sessions': const [],
    'items': [
      {
        'id': 'item-1',
        'studyPlanId': 'plan-1',
        'materialChunkId': null,
        'title': 'Server Item',
        'description': null,
        'itemType': 'Study',
        'orderNo': 1,
        'plannedDateUtc': '2026-05-01T08:55:00Z',
        'plannedStartTime': null,
        'plannedEndTime': null,
        'durationMinutes': 25,
        'status': 'Pending',
        'materialChunk': null,
        'sessions': [_sessionJson()],
      },
    ],
  };
}

Map<String, dynamic> _sessionJson() {
  return {
    'id': 'session-1',
    'studyPlanId': 'plan-1',
    'sequenceNumber': 1,
    'scheduledAtUtc': '2026-05-01T08:55:00Z',
    'plannedDurationMinutes': 25,
    'status': 'Planned',
    'completedAtUtc': null,
    'actualDurationMinutes': null,
    'notes': null,
    'easinessFactor': null,
    'intervalDays': null,
    'repetitionCount': null,
  };
}

Map<String, dynamic> _nextSessionJson() {
  return {
    'sessionId': 'session-1',
    'studyPlanId': 'plan-1',
    'materialId': 'material-1',
    'materialTitle': 'Server Plan',
    'scheduledAtUtc': '2026-05-01T08:55:00Z',
    'startedAtUtc': null,
    'estimatedMinutes': 25,
    'isDue': true,
  };
}

class _FakeSyncService extends SyncService {
  final SyncPushResponse Function(List<SyncOutboxData> operations) response;
  final SyncBootstrapModel? bootstrapResponse;
  final SyncChangesModel? changesResponse;
  final bool throwOnChanges;
  List<SyncOutboxData> operations = const [];
  bool bootstrapCalled = false;
  bool changesCalled = false;
  DateTime? changesSince;

  _FakeSyncService({
    required this.response,
    this.bootstrapResponse,
    this.changesResponse,
    this.throwOnChanges = false,
  });

  @override
  Future<SyncPushResponse> pushOperations(
    List<SyncOutboxData> operations,
  ) async {
    this.operations = operations;
    return response(operations);
  }

  @override
  Future<SyncBootstrapModel> bootstrap() async {
    bootstrapCalled = true;
    return bootstrapResponse ?? _bootstrap();
  }

  @override
  Future<SyncChangesModel> changes({DateTime? since}) async {
    changesCalled = true;
    changesSince = since;

    if (throwOnChanges) {
      throw Exception('delta unavailable');
    }

    return changesResponse ?? _changes();
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

class _FakeSyncStateStorage implements SyncStateStorage {
  DateTime? lastSyncAt;

  _FakeSyncStateStorage({this.lastSyncAt});

  @override
  Future<void> clearLastSyncAt() async {
    lastSyncAt = null;
  }

  @override
  Future<DateTime?> getLastSyncAt() async {
    return lastSyncAt;
  }

  @override
  Future<void> saveLastSyncAt(DateTime value) async {
    lastSyncAt = value.toUtc();
  }
}
