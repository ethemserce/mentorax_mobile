import 'package:dio/dio.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/error/api_exception.dart';
import 'models/create_material_request_model.dart';
import 'models/material_model.dart';

class MaterialService {
  final Dio _dio = DioClient.dio;

  Future<MaterialModel> createMaterial(CreateMaterialRequestModel request) async {
    try {
      final response = await _dio.post(
        '/api/materials',
        data: request.toJson(),
      );

      return MaterialModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<List<MaterialModel>> getMaterials() async {
  try {
    final response = await _dio.get('/api/materials');

    final list = response.data as List<dynamic>;

    return list
        .map((e) => MaterialModel.fromJson(e as Map<String, dynamic>))
        .toList();
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