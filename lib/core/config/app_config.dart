class AppConfig {
  static const String baseUrl = String.fromEnvironment(
    'MENTORAX_API_URL',
    defaultValue: 'http://10.0.2.2:5107',
  );

  static const bool enableNetworkLog = bool.fromEnvironment(
    'MENTORAX_NETWORK_LOG',
    defaultValue: true,
  );
}