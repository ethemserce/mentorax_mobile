import 'package:drift/drift.dart';
import 'package:mentorax/core/database/app_database.dart';
import 'package:mentorax/features/dashboard/data/dashboard_local_data_source.dart';
import 'package:mentorax/features/materials/data/material_local_data_source.dart';
import 'package:mentorax/features/materials/data/models/material_chunk_model.dart';
import 'package:mentorax/features/materials/data/models/material_model.dart';
import 'package:mentorax/features/study_plans/data/study_plan_local_data_source.dart';
import 'package:mentorax/features/study_plans/data/models/study_plan_model.dart';
import 'package:mentorax/features/study_sessions/data/models/study_session_detail_model.dart';
import 'package:mentorax/features/study_sessions/data/study_session_local_data_source.dart';

import 'sync_models.dart';
import 'sync_service.dart';
import 'sync_state_storage.dart';

class SyncRepository {
  static const _pendingStatus = 'pending';
  static const _syncedStatus = 'synced';
  static const _conflictStatus = 'conflict';
  static const _successfulRemoteStatuses = {
    'applied',
    'already_applied',
    'synced',
  };
  static const _terminalRemoteStatuses = {'conflict', 'rejected', 'invalid'};
  static const _terminalErrorCodes = {
    'study_session_not_found',
    'session_plan_not_found',
    'study_plan_not_active',
    'sync_invalid_payload',
    'sync_session_id_required',
    'sync_payload_field_required',
    'sync_payload_field_invalid',
    'sync_operation_not_supported',
  };

  final AppDatabase _database;
  final SyncService _service;
  final SyncStateStorage? _stateStorage;
  final StudyPlanLocalDataSource? _studyPlanLocal;
  final DashboardLocalDataSource? _dashboardLocal;
  final MaterialLocalDataSource? _materialLocal;
  final StudySessionLocalDataSource? _studySessionLocal;

  bool _isSyncing = false;

  SyncRepository({
    required AppDatabase database,
    required SyncService service,
    SyncStateStorage? stateStorage,
    StudyPlanLocalDataSource? studyPlanLocal,
    DashboardLocalDataSource? dashboardLocal,
    MaterialLocalDataSource? materialLocal,
    StudySessionLocalDataSource? studySessionLocal,
  }) : _database = database,
       _service = service,
       _stateStorage = stateStorage,
       _studyPlanLocal = studyPlanLocal,
       _dashboardLocal = dashboardLocal,
       _materialLocal = materialLocal,
       _studySessionLocal = studySessionLocal;

  Future<SyncRunResult> pushPendingOperations() async {
    if (_isSyncing) return SyncRunResult.empty;

    _isSyncing = true;

    try {
      return await _pushPendingOperations();
    } finally {
      _isSyncing = false;
    }
  }

  Future<SyncRunResult> synchronize() async {
    if (_isSyncing) return SyncRunResult.empty;

    _isSyncing = true;

    try {
      final pushResult = await _pushPendingOperations();

      if (!await _hasPendingOperations()) {
        await _pullServerChanges();
      }

      return pushResult;
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> bootstrapFromServer() async {
    if (_isSyncing) return;

    _isSyncing = true;

    try {
      final bootstrap = await _bootstrapFromServer();
      await _stateStorage?.saveLastSyncAt(bootstrap.serverTimeUtc);
    } finally {
      _isSyncing = false;
    }
  }

  Future<SyncRunResult> _pushPendingOperations() async {
    final now = DateTime.now().toUtc();
    final operations = await _pendingOperations(now);

    if (operations.isEmpty) return SyncRunResult.empty;

    try {
      final response = await _service.pushOperations(operations);
      return await _applyPushResponse(operations, response);
    } catch (error) {
      for (final operation in operations) {
        await _markOperationForRetry(operation, error.toString());
      }

      return SyncRunResult(
        attemptedCount: operations.length,
        syncedCount: 0,
        retryCount: operations.length,
      );
    }
  }

  Future<void> _pullServerChanges() async {
    final lastSyncAt = await _stateStorage?.getLastSyncAt();

    if (lastSyncAt == null) {
      final bootstrap = await _bootstrapFromServer();
      await _stateStorage?.saveLastSyncAt(bootstrap.serverTimeUtc);
      return;
    }

    try {
      final changes = await _service.changes(since: lastSyncAt);
      await _applyChanges(changes);
      await _stateStorage?.saveLastSyncAt(changes.serverTimeUtc);
    } catch (_) {
      final bootstrap = await _bootstrapFromServer();
      await _stateStorage?.saveLastSyncAt(bootstrap.serverTimeUtc);
    }
  }

  Future<SyncBootstrapModel> _bootstrapFromServer() async {
    final bootstrap = await _service.bootstrap();

    final nextSession =
        bootstrap.nextSession ?? bootstrap.dashboard.nextSession;
    if (nextSession != null) {
      await _dashboardLocal?.cacheNextSession(nextSession);
    }

    await _studyPlanLocal?.cachePlans(bootstrap.studyPlans);

    return bootstrap;
  }

  Future<void> _applyChanges(SyncChangesModel changes) async {
    final plans = <StudyPlanModel>[];
    final materials = <MaterialModel>[];
    final chunks = <MaterialChunkModel>[];
    final sessions = <StudySessionDetailModel>[];
    final deletes = <SyncChangeModel>[];

    for (final change in changes.changes) {
      if (change.changeType == 'Delete') {
        deletes.add(change);
        continue;
      }

      if (change.changeType != 'Upsert' || change.payload == null) {
        throw UnsupportedError(
          'Unsupported sync change: ${change.entityType}/${change.changeType}',
        );
      }

      switch (change.entityType) {
        case 'Material':
          materials.add(MaterialModel.fromJson(change.payload!));
          break;
        case 'MaterialChunk':
          chunks.add(MaterialChunkModel.fromJson(change.payload!));
          break;
        case 'StudyPlan':
          plans.add(StudyPlanModel.fromJson(change.payload!));
          break;
        case 'StudySession':
          sessions.add(StudySessionDetailModel.fromJson(change.payload!));
          break;
        default:
          throw UnsupportedError(
            'Unsupported sync change: ${change.entityType}/${change.changeType}',
          );
      }
    }

    for (final material in materials) {
      await _materialLocal?.cacheMaterial(material);
    }

    for (final chunk in chunks) {
      await _materialLocal?.cacheChunk(chunk);
    }

    if (plans.isNotEmpty) {
      await _studyPlanLocal?.cachePlans(plans);
    }

    for (final session in sessions) {
      await _studySessionLocal?.cacheSessionDetail(
        session,
        syncStatus: _syncedStatus,
      );
    }

    for (final change in deletes) {
      await _applyDeleteChange(change);
    }
  }

  Future<void> _applyDeleteChange(SyncChangeModel change) async {
    switch (change.entityType) {
      case 'MaterialChunk':
        final materialLocal = _materialLocal;
        if (materialLocal == null) {
          throw StateError('Material local cache is required for delete sync.');
        }

        await materialLocal.deleteChunk(change.entityId);
        break;
      default:
        throw UnsupportedError(
          'Unsupported sync change: ${change.entityType}/${change.changeType}',
        );
    }
  }

  Future<List<SyncOutboxData>> _pendingOperations(DateTime now) async {
    final rows =
        await (_database.select(_database.syncOutbox)
              ..where((row) => row.status.equals(_pendingStatus))
              ..orderBy([(row) => OrderingTerm.asc(row.createdAtUtc)]))
            .get();

    return rows
        .where(
          (operation) =>
              operation.nextAttemptAtUtc == null ||
              !operation.nextAttemptAtUtc!.isAfter(now),
        )
        .toList();
  }

  Future<bool> _hasPendingOperations() async {
    final rows = await (_database.select(
      _database.syncOutbox,
    )..where((row) => row.status.equals(_pendingStatus))).get();

    return rows.isNotEmpty;
  }

  Future<SyncRunResult> _applyPushResponse(
    List<SyncOutboxData> operations,
    SyncPushResponse response,
  ) async {
    final resultByOperationId = {
      for (final result in response.results) result.operationId: result,
    };

    var syncedCount = 0;
    var retryCount = 0;
    var conflictCount = 0;

    for (final operation in operations) {
      final result = resultByOperationId[operation.id];

      if (result == null) {
        await _markOperationForRetry(
          operation,
          'sync_result_missing: Backend did not return an operation result.',
        );
        retryCount += 1;
        continue;
      }

      if (_successfulRemoteStatuses.contains(result.status)) {
        await _markOperationSynced(operation);
        syncedCount += 1;
        continue;
      }

      if (_isTerminalConflict(result)) {
        await _markOperationConflict(
          operation,
          result.error ?? 'sync_operation_conflict: ${result.status}',
        );
        conflictCount += 1;
        continue;
      }

      await _markOperationForRetry(
        operation,
        result.error ?? 'sync_operation_failed: ${result.status}',
      );
      retryCount += 1;
    }

    return SyncRunResult(
      attemptedCount: operations.length,
      syncedCount: syncedCount,
      retryCount: retryCount,
      conflictCount: conflictCount,
    );
  }

  Future<void> _markOperationSynced(SyncOutboxData operation) async {
    final now = DateTime.now().toUtc();

    await _database.transaction(() async {
      await (_database.update(
        _database.syncOutbox,
      )..where((row) => row.id.equals(operation.id))).write(
        SyncOutboxCompanion(
          status: const Value(_syncedStatus),
          lastError: const Value(null),
          nextAttemptAtUtc: const Value(null),
          updatedAtUtc: Value(now),
        ),
      );

      final entityOperations =
          await (_database.select(_database.syncOutbox)..where(
                (row) =>
                    row.entityType.equals(operation.entityType) &
                    row.entityId.equals(operation.entityId),
              ))
              .get();

      final hasUnsyncedEntityOperation = entityOperations.any(
        (item) => item.status != _syncedStatus,
      );

      if (!hasUnsyncedEntityOperation &&
          operation.entityType == 'StudySession') {
        await (_database.update(
          _database.localStudySessions,
        )..where((row) => row.id.equals(operation.entityId))).write(
          LocalStudySessionsCompanion(
            syncStatus: const Value(_syncedStatus),
            updatedAtUtc: Value(now),
          ),
        );
      }
    });
  }

  Future<void> _markOperationForRetry(
    SyncOutboxData operation,
    String error,
  ) async {
    final now = DateTime.now().toUtc();
    final retryCount = operation.retryCount + 1;

    await (_database.update(
      _database.syncOutbox,
    )..where((row) => row.id.equals(operation.id))).write(
      SyncOutboxCompanion(
        status: const Value(_pendingStatus),
        retryCount: Value(retryCount),
        lastError: Value(_trimError(error)),
        nextAttemptAtUtc: Value(now.add(_retryDelay(retryCount))),
        updatedAtUtc: Value(now),
      ),
    );
  }

  Future<void> _markOperationConflict(
    SyncOutboxData operation,
    String error,
  ) async {
    final now = DateTime.now().toUtc();

    await _database.transaction(() async {
      await (_database.update(
        _database.syncOutbox,
      )..where((row) => row.id.equals(operation.id))).write(
        SyncOutboxCompanion(
          status: const Value(_conflictStatus),
          lastError: Value(_trimError(error)),
          nextAttemptAtUtc: const Value(null),
          updatedAtUtc: Value(now),
        ),
      );

      if (operation.entityType == 'StudySession') {
        await (_database.update(
          _database.localStudySessions,
        )..where((row) => row.id.equals(operation.entityId))).write(
          LocalStudySessionsCompanion(
            syncStatus: const Value(_conflictStatus),
            updatedAtUtc: Value(now),
          ),
        );
      }
    });
  }

  Duration _retryDelay(int retryCount) {
    final minutes = retryCount <= 1
        ? 1
        : retryCount == 2
        ? 5
        : 15;

    return Duration(minutes: minutes);
  }

  String _trimError(String error) {
    const maxLength = 500;

    if (error.length <= maxLength) return error;
    return error.substring(0, maxLength);
  }

  bool _isTerminalConflict(SyncPushOperationResult result) {
    if (_terminalRemoteStatuses.contains(result.status)) return true;

    if (result.status != 'failed' || result.error == null) return false;

    return _terminalErrorCodes.any(
      (code) => result.error!.startsWith('$code:'),
    );
  }
}
