/// Logto Configuration Constants
/// Update these with your actual Logto credentials
class LogtoConfig {
  // Replace these with your actual Logto credentials
  static const String endpoint = 'https://auth.dev.siap.id'; // e.g., https://my-app.logto.app
  static const String clientId = 'utoltbqbloc673gbk5wi5'; // Get from Logto Dashboard
  static const String appScheme = 'acara.logto'; // Custom redirect scheme for Flutter
  static const String redirectUrl = 'acara.logto://callback'; // OAuth redirect URL

  // Optional: Scopes for requesting additional user information
  static const List<String> scopes = [
    'openid',
    'profile',
    'email',
  ];
}
