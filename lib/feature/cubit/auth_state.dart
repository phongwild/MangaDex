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

//Change pass
class AuthChangePassLoading extends AuthState {}

class AuthChangePassSuccess extends AuthState {}

class AuthChangePassError extends AuthState {
  final String error;
  const AuthChangePassError(this.error);

  @override
  List<Object> get props => [error];
}

//Avatar
class AuthUploadAvatarLoading extends AuthState {}

class AuthUploadAvatarSuccess extends AuthState {
  final String? avatar;
  const AuthUploadAvatarSuccess({this.avatar});
  @override
  List<Object> get props => [avatar!];
}

class AuthUploadAvatarError extends AuthState {
  final String error;
  const AuthUploadAvatarError(this.error);

  @override
  List<Object> get props => [error];
}

//Update profile
class AuthUpdateProfileLoading extends AuthState {}

class AuthUpdateProfileSuccess extends AuthState {}

class AuthUpdateProfileError extends AuthState {
  final String error;
  const AuthUpdateProfileError(this.error);

  @override
  List<Object> get props => [error];
}

//
