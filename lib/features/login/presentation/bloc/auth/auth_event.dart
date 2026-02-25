part of 'auth_bloc.dart';

abstract class AuthEvent {}

/// Triggers login with given credentials
class LoginEvent extends AuthEvent {
  final String username;
  final String password;
  LoginEvent({required this.username, required this.password});
}

/// Clears auth state (logout)
class LogoutEvent extends AuthEvent {}
