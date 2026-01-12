import '../models/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/services/logto_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LogtoService logtoService;

  AuthRepositoryImpl(this.logtoService);

  @override
  Future<User> login(String username, String password) async {
    // Note: With Logto, we use OAuth flow instead of username/password
    // This method is kept for backward compatibility
    // For Logto authentication, use loginWithLogto() instead
    throw Exception('Use loginWithLogto() for Logto authentication');
  }

  /// Sign in with Logto OAuth
  Future<User> loginWithLogto() async {
    try {
      return await logtoService.signIn();
    } catch (e) {
      throw Exception('Failed to login with Logto: $e');
    }
  }

  @override
  Future<User> signUp(String username, String password, String email) async {
    // Note: With Logto, sign up is handled through the OAuth flow
    // Users sign up through Logto's sign-up page
    throw Exception('Use loginWithLogto() for Logto authentication (handles both sign up and login)');
  }

  @override
  Future<void> logout() async {
    try {
      await logtoService.signOut();
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final isAuthenticated = await logtoService.isAuthenticated();
      if (isAuthenticated) {
        return await logtoService.getCurrentUser();
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
