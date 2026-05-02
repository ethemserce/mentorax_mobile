import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/auth/auth_session.dart';
import '../core/constants/app_theme.dart';
import '../core/router/app_router.dart';
import '../features/auth/presentation/providers/auth_providers.dart';

class MentoraXApp extends ConsumerStatefulWidget {
  const MentoraXApp({super.key});

  @override
  ConsumerState<MentoraXApp> createState() => _MentoraXAppState();
}

class _MentoraXAppState extends ConsumerState<MentoraXApp> {
  StreamSubscription<void>? _unauthorizedSubscription;

  @override
  void initState() {
    super.initState();

    _unauthorizedSubscription = AuthSession.onUnauthorized.listen((_) async {
      await ref.read(authControllerProvider.notifier).handleUnauthorized();

      if (!mounted) return;
      AppRouter.router.go('/login');
    });
  }

  @override
  void dispose() {
    _unauthorizedSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MentoraX',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
