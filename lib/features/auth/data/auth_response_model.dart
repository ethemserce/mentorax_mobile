class AuthResponseModel {
  final String userId;
  final String fullName;
  final String email;
  final String token;

  AuthResponseModel({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.token,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      userId: json['userId'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      token: json['token'] as String,
    );
  }
}