class SyncPushResponse {
  final DateTime serverTimeUtc;
  final List<SyncPushOperationResult> results;

  SyncPushResponse({required this.serverTimeUtc, required this.results});

  factory SyncPushResponse.fromJson(Map<String, dynamic> json) {
    return SyncPushResponse(
      serverTimeUtc: _parseUtcDateTime(json['serverTimeUtc'] as String),
      results: (json['results'] as List<dynamic>)
          .map(
            (item) =>
                SyncPushOperationResult.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class SyncPushOperationResult {
  final String operationId;
  final String status;
  final String? error;

  SyncPushOperationResult({
    required this.operationId,
    required this.status,
    required this.error,
  });

  factory SyncPushOperationResult.fromJson(Map<String, dynamic> json) {
    return SyncPushOperationResult(
      operationId: json['operationId'] as String,
      status: json['status'] as String,
      error: json['error'] as String?,
    );
  }
}

class SyncRunResult {
  final int attemptedCount;
  final int syncedCount;
  final int retryCount;

  const SyncRunResult({
    required this.attemptedCount,
    required this.syncedCount,
    required this.retryCount,
  });

  static const empty = SyncRunResult(
    attemptedCount: 0,
    syncedCount: 0,
    retryCount: 0,
  );
}

DateTime _parseUtcDateTime(String value) {
  final normalized = value.endsWith('Z') ? value : '${value}Z';
  return DateTime.parse(normalized);
}
