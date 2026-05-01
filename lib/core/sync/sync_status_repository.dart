import 'package:mentorax/core/database/app_database.dart';

import 'sync_state_storage.dart';
import 'sync_status_model.dart';

class SyncStatusRepository {
  final AppDatabase _database;
  final SyncStateStorage _stateStorage;

  SyncStatusRepository({
    required AppDatabase database,
    required SyncStateStorage stateStorage,
  }) : _database = database,
       _stateStorage = stateStorage;

  Future<SyncStatusModel> getStatus() async {
    final now = DateTime.now().toUtc();
    final operations = await _database.select(_database.syncOutbox).get();
    final lastSyncAt = await _stateStorage.getLastSyncAt();
    final pendingOperations = operations
        .where((operation) => operation.status == 'pending')
        .toList();
    final conflictOperations = operations
        .where((operation) => operation.status == 'conflict')
        .toList();
    final retryScheduledCount = pendingOperations
        .where(
          (operation) =>
              operation.nextAttemptAtUtc != null &&
              operation.nextAttemptAtUtc!.isAfter(now),
        )
        .length;

    operations.sort((a, b) {
      final aTime = a.updatedAtUtc ?? a.createdAtUtc;
      final bTime = b.updatedAtUtc ?? b.createdAtUtc;
      return bTime.compareTo(aTime);
    });

    final errorCandidates = operations
        .map((operation) => operation.lastError)
        .whereType<String>()
        .where((error) => error.trim().isNotEmpty)
        .toList();

    return SyncStatusModel(
      lastSyncAt: lastSyncAt,
      pendingCount: pendingOperations.length,
      conflictCount: conflictOperations.length,
      retryScheduledCount: retryScheduledCount,
      lastError: errorCandidates.isEmpty ? null : errorCandidates.first,
    );
  }
}
