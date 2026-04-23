import 'package:dio/dio.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/error/api_exception.dart';
import 'models/create_study_plan_request.dart';
import 'models/study_plan_model.dart';
import 'models/study_plan_detail_model.dart';

class StudyPlanService {
  final Dio _dio = DioClient.dio;

Future<StudyPlanModel> createPlan(CreateStudyPlanRequest request) async {
  try {
    final response = await _dio.post(
      '/api/study-plans',
      data: request.toJson(),
    );

    return StudyPlanModel.fromJson(response.data as Map<String, dynamic>);
  } on DioException catch (e) {
    throw _mapDioException(e);
  }
}

  Future<void> pausePlan(String id) async {
  await _dio.post('/api/study-plans/$id/pause');
}

Future<void> resumePlan(String id) async {
  await _dio.post('/api/study-plans/$id/resume');
}

Future<void> cancelPlan(String id) async {
  await _dio.post('/api/study-plans/$id/cancel');
}

  Future<List<StudyPlanModel>> getPlans() async {
    try {
      final response = await _dio.get('/api/study-plans');
      final data = response.data as List<dynamic>;

      return data
          .map((e) => StudyPlanModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<StudyPlanDetailModel> getPlanById(String planId) async {
  try {
    final response = await _dio.get('/api/study-plans/$planId');
    return StudyPlanDetailModel.fromJson(response.data as Map<String, dynamic>);
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