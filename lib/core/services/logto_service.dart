import 'package:logto_dart_sdk/logto_dart_sdk.dart';
import 'package:mangament_acara/core/constants/logto_config.dart' as config;
import '../../data/models/user.dart';

class LogtoService {
  late LogtoClient _logtoClient;

  LogtoService() {
    _initializeLogto();
  }

  void _initializeLogto() {
    final logtoConfig = LogtoConfig(
      endpoint: config.LogtoConfig.endpoint,
      appId: config.LogtoConfig.clientId,
    );

    _logtoClient = LogtoClient(
      config: logtoConfig,
    );
  }

  /// Sign in with Logto
  /// Returns a User object with the authenticated user's information
  Future<User> signIn() async {
    try {
      await _logtoClient.signIn(config.LogtoConfig.redirectUrl);
      return await getCurrentUser();
    } catch (e) {
      throw Exception('Logto sign in failed: $e');
    }
  }

  /// Sign out from Logto
  Future<void> signOut() async {
    try {
      await _logtoClient.signOut(config.LogtoConfig.redirectUrl);
    } catch (e) {
      throw Exception('Logto sign out failed: $e');
    }
  }

  /// Get current authenticated user
  Future<User> getCurrentUser() async {
    try {
      final idTokenClaims = await _logtoClient.idTokenClaims;
      
      if (idTokenClaims == null) {
        throw Exception('Failed to get user information');
      }

      final userId = idTokenClaims.subject;
      final username = idTokenClaims.username ?? userId;

      return User(
        id: userId,
        username: username,
        email: idTokenClaims.email ?? 'unknown@example.com',
        token: await _getAccessToken(),
      );
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  /// Get access token
  Future<String> _getAccessToken() async {
    try {
      final accessToken = await _logtoClient.getAccessToken();
      return accessToken?.token ?? 'unknown_token';
    } catch (e) {
      return 'unknown_token';
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      final idTokenClaims = await _logtoClient.idTokenClaims;
      return idTokenClaims != null;
    } catch (e) {
      return false;
    }
  }

  /// Check if user is still authenticated (using native property)
  Future<bool> isAuthenticatedCheck() async {
    try {
      return await _logtoClient.isAuthenticated;
    } catch (e) {
      return false;
    }
  }
}
