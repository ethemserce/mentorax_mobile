import 'package:dio/dio.dart';

import '../../../core/api/dio_client.dart';
import '../../../core/error/api_exception.dart';
import 'models/study_session_detail_model.dart';

class StudySessionService {
  final Dio _dio = DioClient.dio;

  Future<StudySessionDetailModel> getSessionById(String sessionId) async {
    try {
      final response = await _dio.get('/api/study-sessions/$sessionId');

      return StudySessionDetailModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  ApiException _mapDioException(DioException e) {
    return ApiException.fromDioException(e);
  }
}
