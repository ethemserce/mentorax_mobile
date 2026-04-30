// lib/core/api/api_endpoints.dart

class ApiEndpoints {
  static const String health = '/api/health';

  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';
  static const String refreshToken = '/api/auth/refresh-token';
  static const String logout = '/api/auth/logout';
  static const String me = '/api/auth/me';

  static const String materials = '/api/materials';

  static String materialById(String id) => '/api/materials/$id';
  static String materialChunks(String materialId) =>
      '/api/materials/$materialId/chunks';
}