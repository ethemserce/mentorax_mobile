import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class PushNotificationService {
  PushNotificationService._();

  static final PushNotificationService instance = PushNotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final token = await _messaging.getToken();
    debugPrint('FCM Token: $token');

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
  }

  Future<String?> getToken() async {
    return _messaging.getToken();
  }

  void _onForegroundMessage(RemoteMessage message) {
    debugPrint('Foreground push received: ${message.messageId}');
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    debugPrint('Push tapped: ${message.messageId}');
  }
}