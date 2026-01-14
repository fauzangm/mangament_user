import 'dart:convert';

import 'package:mangament_acara/core/constants/contans.dart';
import 'package:mangament_acara/core/exception.dart';
import 'package:mangament_acara/data/models/loginResponse.dart';

import '../models/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/services/logto_service.dart';
import '../../core/services/local_auth_service.dart';
import 'package:http/http.dart' as http;

class AuthRepositoryImpl implements AuthRepository {
  final LogtoService logtoService;
  final LocalAuthService localAuthService;
  final http.Client client;

  AuthRepositoryImpl(this.logtoService, this.localAuthService, this.client);

  @override
  Future<LoginResponse> login(String username, String password) async {
    final response = await client.post(
      Uri.parse("${Constans.baseUrl}login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': username, 'password': password}),
    );
    var responseKu = LoginResponse.fromJson(json.decode(response.body));
    print(
      "LOGIN RESPONSE ${response.statusCode} dengan pesan ${responseKu.accessToken}",
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
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
