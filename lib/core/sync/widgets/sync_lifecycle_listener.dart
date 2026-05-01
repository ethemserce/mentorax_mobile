import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentorax/core/state/app_refresh_controller.dart';
import 'package:mentorax/core/sync/sync_lifecycle_controller.dart';
import 'package:mentorax/core/sync/sync_providers.dart';
import 'package:mentorax/features/auth/presentation/providers/auth_providers.dart';

class SyncLifecycleListener extends ConsumerStatefulWidget {
  final Widget child;

  const SyncLifecycleListener({super.key, required this.child});

  @override
  ConsumerState<SyncLifecycleListener> createState() =>
      _SyncLifecycleListenerState();
}

class _SyncLifecycleListenerState extends ConsumerState<SyncLifecycleListener>
    with WidgetsBindingObserver {
  late final AppLifecycleSyncController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AppLifecycleSyncController(
      isAuthenticated: _hasToken,
      synchronize: () async {
        await ref.read(syncRepositoryProvider).synchronize();
      },
      onSynchronized: () async {
        if (!mounted) return;

        ref.invalidate(syncStatusProvider);
        ref.read(appRefreshControllerProvider).refreshStudyFlow();
      },
    );

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(_controller.trigger(force: true));
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_controller.trigger());
    }
  }

  Future<bool> _hasToken() async {
    final token = await ref.read(tokenStorageProvider).getToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
