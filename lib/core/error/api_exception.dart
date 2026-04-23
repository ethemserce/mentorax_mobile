class ApiException implements Exception {
  final String message;
  final String? code;
  final Map<String, List<String>>? validationErrors;

  ApiException({
    required this.message,
    this.code,
    this.validationErrors,
  });

  @override
  String toString() => message;
}