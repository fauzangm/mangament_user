part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  const LoginRequested({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [username, password];
}

class SignUpRequested extends AuthEvent {
  final String username;
  final String password;
  final String email;

  const SignUpRequested({
    required this.username,
    required this.password,
    required this.email,
  });

  @override
  List<Object> get props => [username, password, email];
}

class LoginWithLogtoRequested extends AuthEvent {
  const LoginWithLogtoRequested();
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

