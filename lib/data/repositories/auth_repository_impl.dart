import '../models/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/services/logto_service.dart';
import '../../core/services/local_auth_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LogtoService logtoService;
  final LocalAuthService localAuthService;

  AuthRepositoryImpl(
    this.logtoService,
    this.localAuthService,
  );

  @override
  Future<User> login(String username, String password) async {
    try {
      return await localAuthService.login(username, password);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
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
    try {
      return await localAuthService.signUp(username, password, email);
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
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
