class ApiException implements Exception {
  final String message;
  final String? code;
  final Map<String, List<String>>? validationErrors;

  ApiException({
    required this.message,
    this.code,
    this.validationErrors,
  });

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
      case 'material_chunk_not_found':
        return 'This chunk could not be found.';
      case 'chunk_is_used_in_study_plan':
        return 'This chunk is used in a study plan and cannot be deleted.';
      case 'validation_error':
        return 'Please check the form fields.';
      default:
        return message;
    }
  }

  @override
  String toString() => userFriendlyMessage;
}