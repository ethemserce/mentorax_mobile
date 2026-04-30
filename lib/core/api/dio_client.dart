// lib/core/api/dio_client.dart

import 'package:dio/dio.dart';

import '../auth/auth_session.dart';
import '../config/app_config.dart';
import '../storage/token_storage.dart';

class DioClient {
  static final Dio dio = _createDio();

  static Dio _createDio() {
    final client = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    client.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenStorage().getToken();

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          handler.next(options);
        },
        onError: (error, handler) async {
          final statusCode = error.response?.statusCode;

          if (statusCode == 401) {
            await TokenStorage().clearToken();
            AuthSession.notifyUnauthorized();
          }

          handler.next(error);
        },
      ),
    );

    if (AppConfig.enableNetworkLog) {
      client.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
        ),
      );
    }

    return client;
  }
}