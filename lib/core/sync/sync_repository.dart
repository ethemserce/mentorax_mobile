import 'package:drift/drift.dart';
import 'package:mentorax/core/database/app_database.dart';
import 'package:mentorax/features/dashboard/data/dashboard_local_data_source.dart';
import 'package:mentorax/features/study_plans/data/study_plan_local_data_source.dart';

import 'sync_models.dart';
import 'sync_service.dart';

class SyncRepository {
  static const _pendingStatus = 'pending';
  static const _syncedStatus = 'synced';
  static const _successfulRemoteStatuses = {
    'applied',
    'already_applied',
    'synced',
  };

  final AppDatabase _database;
  final SyncService _service;
  final StudyPlanLocalDataSource? _studyPlanLocal;
  final DashboardLocalDataSource? _dashboardLocal;

  bool _isSyncing = false;

  SyncRepository({
    required AppDatabase database,
    required SyncService service,
    StudyPlanLocalDataSource? studyPlanLocal,
    DashboardLocalDataSource? dashboardLocal,
  }) : _database = database,
       _service = service,
       _studyPlanLocal = studyPlanLocal,
       _dashboardLocal = dashboardLocal;

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

      if (pushResult.retryCount == 0) {
        await _bootstrapFromServer();
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
      await _bootstrapFromServer();
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

  Future<void> _bootstrapFromServer() async {
    final bootstrap = await _service.bootstrap();

    final nextSession =
        bootstrap.nextSession ?? bootstrap.dashboard.nextSession;
    if (nextSession != null) {
      await _dashboardLocal?.cacheNextSession(nextSession);
    }

    await _studyPlanLocal?.cachePlans(bootstrap.studyPlans);
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

  Future<SyncRunResult> _applyPushResponse(
    List<SyncOutboxData> operations,
    SyncPushResponse response,
  ) async {
    final resultByOperationId = {
      for (final result in response.results) result.operationId: result,
    };

    var syncedCount = 0;
    var retryCount = 0;

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
}
