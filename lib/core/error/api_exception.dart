import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final String? code;
  final Map<String, List<String>>? validationErrors;

  ApiException({
    required this.message,
    this.code,
    this.validationErrors,
  });

  factory ApiException.fromDioException(DioException e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      final errorObj = data['error'] ?? data['Error'];

      if (errorObj is Map<String, dynamic>) {
        final validationErrors =
            _parseValidationErrors(errorObj['validationErrors'] ??
                errorObj['ValidationErrors']);

        return ApiException(
          message: errorObj['message']?.toString() ??
              errorObj['Message']?.toString() ??
              'An error occurred.',
          code: errorObj['code']?.toString() ??
              errorObj['Code']?.toString(),
          validationErrors: validationErrors,
        );
      }

      return ApiException(
        message: data['message']?.toString() ??
            data['Message']?.toString() ??
            'An error occurred.',
        code: data['code']?.toString() ?? data['Code']?.toString(),
      );
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return ApiException(
        message: 'The request timed out. Please try again.',
        code: 'timeout',
      );
    }

    if (e.type == DioExceptionType.connectionError) {
      return ApiException(
        message: 'Could not connect to the server. Please check your connection.',
        code: 'connection_error',
      );
    }

    return ApiException(
      message: 'Network or server error occurred.',
      code: e.response?.statusCode?.toString(),
    );
  }

  static Map<String, List<String>>? _parseValidationErrors(dynamic value) {
    if (value is! Map) return null;

    final result = <String, List<String>>{};

    for (final entry in value.entries) {
      final key = entry.key.toString();
      final rawMessages = entry.value;

      if (rawMessages is List) {
        result[key] = rawMessages.map((x) => x.toString()).toList();
      } else if (rawMessages != null) {
        result[key] = [rawMessages.toString()];
      }
    }

    return result.isEmpty ? null : result;
  }

  String get userFriendlyMessage {
    switch (code) {
      case 'plan_is_not_active':
        return 'This plan is no longer active. Please refresh the page.';
      case 'session_already_completed':
        return 'This session has already been completed.';
      case 'study_session_not_found':
        return 'This study session could not be found.';
      case 'study_plan_not_found':
        return 'This study plan could not be found.';
      case 'learning_material_not_found':
        return 'This material could not be found.';
      case 'material_chunk_not_found':
        return 'This chunk could not be found.';
      case 'chunk_is_used_in_study_plan':
        return 'This chunk is used in a study plan and cannot be deleted.';
      case 'chunk_content_required':
        return 'Chunk content is required.';
      case 'invalid_difficulty_level':
        return 'Difficulty level must be between 1 and 5.';
      case 'invalid_estimated_study_minutes':
        return 'Estimated study minutes must be greater than zero.';
      case 'material_chunks_not_found':
        return 'Please create at least one chunk before creating a plan.';
      case 'cancelled_plan_cannot_be_resumed':
        return 'Cancelled plans cannot be resumed.';
      case 'completed_plan_cannot_be_resumed':
        return 'Completed plans cannot be resumed.';
      case 'completed_plan_cannot_be_cancelled':
        return 'Completed plans cannot be cancelled.';
      case 'cancelled_plan_cannot_be_completed':
        return 'Cancelled plans cannot be completed.';
      case 'timeout':
        return 'The request timed out. Please try again.';
      case 'connection_error':
        return 'Could not connect to the server. Please check your connection.';
      case 'validation_error':
        return 'Please check the form fields.';
      default:
        if (validationErrors != null && validationErrors!.isNotEmpty) {
          return validationErrors!.entries
              .expand((entry) => entry.value)
              .join('\n');
        }

        return message;
    }
  }

  @override
  String toString() => userFriendlyMessage;
}