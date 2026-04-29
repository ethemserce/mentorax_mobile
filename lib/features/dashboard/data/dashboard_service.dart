import 'package:dio/dio.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/error/api_exception.dart';
import 'models/mobile_dashboard_model.dart';
import 'models/next_session_model.dart';

class DashboardService {
  final Dio _dio = DioClient.dio;

  Future<MobileDashboardModel> getDashboard() async {
    try {
      final response = await _dio.get('/api/mobile/dashboard');
      return MobileDashboardModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<NextSessionModel> getNextSession() async {
    try {
      final response = await _dio.get('/api/mobile/study-sessions/next');
      return NextSessionModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<NextSessionModel> startSession(String sessionId) async {
    try {
      final response = await _dio.post('/api/mobile/study-sessions/$sessionId/start');
      return NextSessionModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<void> completeSession({
    required String sessionId,
    required int qualityScore,
    required int difficultyScore,
    required int actualDurationMinutes,
    required String? reviewNotes,
  }) async {
    try {
      await _dio.post(
        '/api/mobile/study-sessions/$sessionId/complete',
        data: {
          'qualityScore': qualityScore,
          'difficultyScore': difficultyScore,
          'actualDurationMinutes': actualDurationMinutes,
          'reviewNotes': reviewNotes,
        },
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

ApiException _mapDioException(DioException e) {
  return ApiException.fromDioException(e);
}

}