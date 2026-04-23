import 'package:dio/dio.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/error/api_exception.dart';
import 'models/mobile_progress_summary_model.dart';

class ProgressService {
  final Dio _dio = DioClient.dio;

  Future<MobileProgressSummaryModel> getSummary() async {
    try {
      final response = await _dio.get('/api/mobile/progress/summary');
      return MobileProgressSummaryModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  ApiException _mapDioException(DioException e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic> && data['error'] is Map<String, dynamic>) {
      final error = data['error'] as Map<String, dynamic>;

      return ApiException(
        message: error['message']?.toString() ?? 'An error occurred.',
        code: error['code']?.toString(),
      );
    }

    return ApiException(
      message: 'Network or server error occurred.',
    );
  }
}