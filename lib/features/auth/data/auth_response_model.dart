class AuthResponseModel {
  final String userId;
  final String fullName;
  final String email;
  final String accessToken;
  final String refreshToken;
  final DateTime accessTokenExpiresAtUtc;
  final DateTime refreshTokenExpiresAtUtc;

  AuthResponseModel({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpiresAtUtc,
    required this.refreshTokenExpiresAtUtc,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      userId: json['userId'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      accessTokenExpiresAtUtc:
          DateTime.parse(json['accessTokenExpiresAtUtc'] as String),
      refreshTokenExpiresAtUtc:
          DateTime.parse(json['refreshTokenExpiresAtUtc'] as String),
    );
  }
}