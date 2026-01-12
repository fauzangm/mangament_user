import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String email;
  final String? token;

  const User({
    required this.id,
    required this.username,
    required this.email,
    this.token,
  });

  @override
  List<Object?> get props => [id, username, email, token];

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      token: token ?? this.token,
    );
  }
}
