import 'package:logto_dart_sdk/logto_dart_sdk.dart';
import 'package:mangament_acara/core/constants/logto_config.dart' as config;
import '../../data/models/user.dart';
class LogtoService {
  LogtoService._internal();

  static final LogtoService _instance = LogtoService._internal();
  factory LogtoService() => _instance;

  late LogtoClient _logtoClient;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    final logtoConfig = LogtoConfig(
      endpoint: config.LogtoConfig.endpoint,
      appId: config.LogtoConfig.clientId,
    );

    _logtoClient = LogtoClient(config: logtoConfig);
    _initialized = true;
  }

  Future<User> signIn() async {
    if (!_initialized) {
      throw Exception('LogtoService not initialized. Call init() first.');
    }

    await _logtoClient.signIn(config.LogtoConfig.redirectUrl);
    return await getCurrentUser();
  }

  Future<void> signOut() async {
    await _logtoClient.signOut(config.LogtoConfig.redirectUrl);
  }

  Future<User> getCurrentUser() async {
    final claims = await _logtoClient.idTokenClaims;
    if (claims == null) {
      throw Exception('User not authenticated');
    }

    return User(
      id: claims.subject,
      username: claims.username ?? claims.subject,
      email: claims.email ?? '',
      token: (await _logtoClient.getAccessToken())?.token ?? '',
    );
  }

  Future<bool> isAuthenticated() async {
    return await _logtoClient.isAuthenticated;
  }
}
