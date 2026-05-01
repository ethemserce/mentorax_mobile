typedef AsyncBoolGetter = Future<bool> Function();
typedef AsyncVoidCallback = Future<void> Function();
typedef DateTimeGetter = DateTime Function();

enum AppLifecycleSyncResult {
  synchronized,
  failed,
  skippedUnauthenticated,
  skippedRecently,
  skippedAlreadyRunning,
}

class AppLifecycleSyncController {
  final AsyncBoolGetter isAuthenticated;
  final AsyncVoidCallback synchronize;
  final AsyncVoidCallback onSynchronized;
  final DateTimeGetter now;
  final Duration minInterval;

  DateTime? _lastAttemptAtUtc;
  bool _isRunning = false;

  AppLifecycleSyncController({
    required this.isAuthenticated,
    required this.synchronize,
    required this.onSynchronized,
    DateTimeGetter? now,
    this.minInterval = const Duration(minutes: 3),
  }) : now = now ?? (() => DateTime.now().toUtc());

  Future<AppLifecycleSyncResult> trigger({bool force = false}) async {
    if (_isRunning) return AppLifecycleSyncResult.skippedAlreadyRunning;

    _isRunning = true;

    try {
      final current = now().toUtc();
      final lastAttemptAt = _lastAttemptAtUtc;

      if (!force &&
          lastAttemptAt != null &&
          current.difference(lastAttemptAt) < minInterval) {
        return AppLifecycleSyncResult.skippedRecently;
      }

      if (!await isAuthenticated()) {
        return AppLifecycleSyncResult.skippedUnauthenticated;
      }

      _lastAttemptAtUtc = current;

      try {
        await synchronize();
        await onSynchronized();
        return AppLifecycleSyncResult.synchronized;
      } catch (_) {
        return AppLifecycleSyncResult.failed;
      }
    } finally {
      _isRunning = false;
    }
  }
}
