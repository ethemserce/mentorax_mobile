class RegisterDeviceRequest {
  final String deviceToken;
  final String platform;

  RegisterDeviceRequest({
    required this.deviceToken,
    required this.platform,
  });

  Map<String, dynamic> toJson() {
    return {
      'deviceToken': deviceToken,
      'platform': platform,
    };
  }
}