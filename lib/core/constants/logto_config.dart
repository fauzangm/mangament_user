/// Logto Configuration Constants
/// Update these with your actual Logto credentials
class LogtoConfig {
  // Replace these with your actual Logto credentials
  static const String endpoint = 'https://your-app.logto.app'; // e.g., https://my-app.logto.app
  static const String clientId = 'YOUR_CLIENT_ID'; // Get from Logto Dashboard
  static const String appScheme = 'io.logto.flutter'; // Custom redirect scheme for Flutter
  static const String redirectUrl = '$appScheme://callback'; // OAuth redirect URL

  // Optional: Scopes for requesting additional user information
  static const List<String> scopes = [
    'openid',
    'profile',
    'email',
  ];
}
