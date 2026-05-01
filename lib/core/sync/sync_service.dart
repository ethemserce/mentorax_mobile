import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mentorax/core/api/dio_client.dart';
import 'package:mentorax/core/database/app_database.dart';
import 'package:mentorax/core/error/api_exception.dart';

import 'sync_models.dart';

class SyncService {
  final Dio _dio;

  SyncService({Dio? dio}) : _dio = dio ?? DioClient.dio;

  Future<SyncBootstrapModel> bootstrap() async {
    try {
      final response = await _dio.get('/api/sync/bootstrap');
      return SyncBootstrapModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      throw ApiException.fromDioException(error);
    }
  }

  Future<SyncChangesModel> changes({DateTime? since}) async {
    try {
      final response = await _dio.get(
        '/api/sync/changes',
        queryParameters: {
          if (since != null) 'since': since.toUtc().toIso8601String(),
        },
      );

      return SyncChangesModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      throw ApiException.fromDioException(error);
    }
  }

  Future<SyncPushResponse> pushOperations(
    List<SyncOutboxData> operations,
  ) async {
    if (operations.isEmpty) {
      return SyncPushResponse(
        serverTimeUtc: DateTime.now().toUtc(),
        results: const [],
      );
    }

    try {
      final response = await _dio.post(
        '/api/sync/push',
        data: {'operations': operations.map(_operationToJson).toList()},
      );

      return SyncPushResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      throw ApiException.fromDioException(error);
    }
  }

  Map<String, dynamic> _operationToJson(SyncOutboxData operation) {
    return {
      'operationId': operation.id,
      'operationType': operation.operationType,
      'entityType': operation.entityType,
      'entityId': operation.entityId,
      'createdAtUtc': operation.createdAtUtc.toUtc().toIso8601String(),
      'payload': _decodePayload(operation.payload),
    };
  }

  Object? _decodePayload(String payload) {
    try {
      return jsonDecode(payload);
    } on FormatException {
      return payload;
    }
  }
}
