import '../../data/models/user.dart';

abstract class AuthRepository {
  Future<User> login(String username, String password);
  Future<User> signUp(String username, String password, String email);
  Future<void> logout();
  Future<User?> getCurrentUser();
}
