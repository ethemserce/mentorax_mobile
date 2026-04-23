import 'package:dio/dio.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/error/api_exception.dart';
import 'auth_response_model.dart';

class AuthService {
  final Dio _dio = DioClient.dio;

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/api/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<AuthResponseModel> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/api/auth/register',
        data: {
          'fullName': fullName,
          'email': email,
          'password': password,
          'timeZone': 'Europe/Istanbul',
        },
      );

      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  ApiException _mapDioException(DioException e) {
  print('DIO ERROR TYPE: ${e.type}');
  print('DIO ERROR MESSAGE: ${e.message}');
  print('DIO STATUS CODE: ${e.response?.statusCode}');
  print('DIO RESPONSE DATA: ${e.response?.data}');
  print('DIO REQUEST URI: ${e.requestOptions.uri}');

  final data = e.response?.data;

  if (data is Map<String, dynamic> && data['error'] is Map<String, dynamic>) {
    final error = data['error'] as Map<String, dynamic>;

    Map<String, List<String>>? validationMap;

    if (error['validationErrors'] is List) {
      final items = error['validationErrors'] as List;
      validationMap = {};

      for (final item in items) {
        if (item is Map<String, dynamic>) {
          final property = item['property']?.toString() ?? 'Unknown';
          final message = item['message']?.toString() ?? 'Invalid value';

          validationMap.putIfAbsent(property, () => []);
          validationMap[property]!.add(message);
        }
      }
    }

    return ApiException(
      message: error['message']?.toString() ?? 'An error occurred.',
      code: error['code']?.toString(),
      validationErrors: validationMap,
    );
  }

  return ApiException(
    message:
        'Network or server error occurred. Type: ${e.type}, Status: ${e.response?.statusCode}, Message: ${e.message}',
  );
}
}