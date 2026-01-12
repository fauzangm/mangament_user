import '../../data/models/user.dart';

/// Local authentication service for username/password authentication
/// This is a mock implementation for demonstration
/// In production, this should connect to your backend API
class LocalAuthService {
  // Mock user storage - in production, use a real backend
  static final Map<String, Map<String, String>> _users = {
    'demo': {
      'password': 'demo123',
      'email': 'demo@example.com',
    },
  };

  /// Login with username and password
  Future<User> login(String username, String password) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      if (_users.containsKey(username)) {
        final user = _users[username]!;
        if (user['password'] == password) {
          return User(
            id: username,
            username: username,
            email: user['email'] ?? 'unknown@example.com',
            token: _generateToken(username),
          );
        }
      }

      throw Exception('Invalid username or password');
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  /// Sign up with username, password, and email
  Future<User> signUp(String username, String password, String email) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      if (_users.containsKey(username)) {
        throw Exception('Username already exists');
      }

      if (username.isEmpty || password.isEmpty || email.isEmpty) {
        throw Exception('All fields are required');
      }

      if (password.length < 6) {
        throw Exception('Password must be at least 6 characters');
      }

      // Register new user
      _users[username] = {
        'password': password,
        'email': email,
      };

      return User(
        id: username,
        username: username,
        email: email,
        token: _generateToken(username),
      );
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  /// Generate a mock token
  String _generateToken(String username) {
    return 'local_token_${username}_${DateTime.now().millisecondsSinceEpoch}';
  }
}
