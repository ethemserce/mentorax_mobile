import 'dart:async';
import 'package:flutter/material.dart';
import '../core/auth/auth_session.dart';
import '../core/constants/app_theme.dart';
import '../core/router/app_router.dart';

class MentoraXApp extends StatefulWidget {
  const MentoraXApp({super.key});

  @override
  State<MentoraXApp> createState() => _MentoraXAppState();
}

class _MentoraXAppState extends State<MentoraXApp> {
  StreamSubscription<void>? _unauthorizedSubscription;

  @override
  void initState() {
    super.initState();

    _unauthorizedSubscription = AuthSession.onUnauthorized.listen((_) {
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