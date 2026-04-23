import 'package:dio/dio.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/error/api_exception.dart';
import 'models/register_device_request.dart';

class DeviceService {
  final Dio _dio = DioClient.dio;

  Future<void> registerDevice(RegisterDeviceRequest request) async {
    try {
      await _dio.post(
        '/api/mobile/devices',
        data: request.toJson(),
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic> && data['error'] is Map<String, dynamic>) {
        final error = data['error'] as Map<String, dynamic>;
        throw ApiException(
          message: error['message']?.toString() ?? 'An error occurred.',
          code: error['code']?.toString(),
        );
      }

      throw ApiException(message: 'Network or server error occurred.');
    }
  }
}