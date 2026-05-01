class SyncStatusModel {
  final DateTime? lastSyncAt;
  final int pendingCount;
  final int conflictCount;
  final int retryScheduledCount;
  final String? lastError;

  const SyncStatusModel({
    required this.lastSyncAt,
    required this.pendingCount,
    required this.conflictCount,
    required this.retryScheduledCount,
    required this.lastError,
  });

  bool get hasPending => pendingCount > 0;

  bool get hasConflicts => conflictCount > 0;

  bool get hasRetryScheduled => retryScheduledCount > 0;

  bool get isSynced => !hasPending && !hasConflicts && !hasRetryScheduled;
}
