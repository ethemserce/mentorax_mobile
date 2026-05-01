import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mentorax/core/sync/sync_lifecycle_controller.dart';

void main() {
  test('runs sync and refresh callbacks when authenticated', () async {
    var syncCount = 0;
    var refreshCount = 0;

    final controller = AppLifecycleSyncController(
      isAuthenticated: () async => true,
      synchronize: () async {
        syncCount += 1;
      },
      onSynchronized: () async {
        refreshCount += 1;
      },
      now: () => DateTime.utc(2026, 5, 1, 10),
    );

    final result = await controller.trigger(force: true);

    expect(result, AppLifecycleSyncResult.synchronized);
    expect(syncCount, 1);
    expect(refreshCount, 1);
  });

  test('skips sync when user is not authenticated', () async {
    var syncCount = 0;

    final controller = AppLifecycleSyncController(
      isAuthenticated: () async => false,
      synchronize: () async {
        syncCount += 1;
      },
      onSynchronized: () async {},
      now: () => DateTime.utc(2026, 5, 1, 10),
    );

    final result = await controller.trigger(force: true);

    expect(result, AppLifecycleSyncResult.skippedUnauthenticated);
    expect(syncCount, 0);
  });

  test('throttles resume sync attempts inside the minimum interval', () async {
    var current = DateTime.utc(2026, 5, 1, 10);
    var syncCount = 0;

    final controller = AppLifecycleSyncController(
      isAuthenticated: () async => true,
      synchronize: () async {
        syncCount += 1;
      },
      onSynchronized: () async {},
      now: () => current,
      minInterval: const Duration(minutes: 3),
    );

    expect(
      await controller.trigger(force: true),
      AppLifecycleSyncResult.synchronized,
    );

    current = DateTime.utc(2026, 5, 1, 10, 2);
    expect(await controller.trigger(), AppLifecycleSyncResult.skippedRecently);

    current = DateTime.utc(2026, 5, 1, 10, 4);
    expect(await controller.trigger(), AppLifecycleSyncResult.synchronized);
    expect(syncCount, 2);
  });

  test('does not overlap running sync attempts', () async {
    final gate = Completer<void>();

    final controller = AppLifecycleSyncController(
      isAuthenticated: () async => true,
      synchronize: () async {
        await gate.future;
      },
      onSynchronized: () async {},
      now: () => DateTime.utc(2026, 5, 1, 10),
    );

    final firstRun = controller.trigger(force: true);

    expect(
      await controller.trigger(force: true),
      AppLifecycleSyncResult.skippedAlreadyRunning,
    );

    gate.complete();
    expect(await firstRun, AppLifecycleSyncResult.synchronized);
  });

  test('swallows sync errors and resets running state', () async {
    var shouldThrow = true;
    var syncCount = 0;

    final controller = AppLifecycleSyncController(
      isAuthenticated: () async => true,
      synchronize: () async {
        syncCount += 1;

        if (shouldThrow) {
          throw Exception('network unavailable');
        }
      },
      onSynchronized: () async {},
      now: () =>
          DateTime.utc(2026, 5, 1, 10).add(Duration(minutes: syncCount * 4)),
    );

    expect(
      await controller.trigger(force: true),
      AppLifecycleSyncResult.failed,
    );

    shouldThrow = false;
    expect(await controller.trigger(), AppLifecycleSyncResult.synchronized);
    expect(syncCount, 2);
  });
}
