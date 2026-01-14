import 'package:mangament_acara/data/models/loginResponse.dart';

import '../../data/models/user.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(String username, String password);
  Future<User> signUp(String username, String password, String email);
  Future<void> logout();
  Future<User?> getCurrentUser();
}
