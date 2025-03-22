// ignore_for_file: must_be_immutable

part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthOtpSent extends AuthState {}

class AuthLoginSuccess extends AuthState {
  final String? token;
  final User user;

  const AuthLoginSuccess({required this.user, this.token});

  @override
  List<Object> get props => [user, token!];
}

class AuthWrongEmailOrPassword extends AuthState {}

class AuthRegistrationSuccess extends AuthState {}

class AuthLogoutSuccess extends AuthState {}

class AuthGetUserByIdSuccess extends AuthState {
  final User user;
  const AuthGetUserByIdSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

class AuthError extends AuthState {
  final String error;

  const AuthError({required this.error});

  @override
  List<Object> get props => [error];
}

class AuthProfileLoaded extends AuthState {
  final User user;

  const AuthProfileLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

class AuthSearchLoaded extends AuthState {
  final List<User> users;

  const AuthSearchLoaded({required this.users});

  @override
  List<Object> get props => [users];
}
