import 'package:flutter/foundation.dart';
import 'package:qrino_admin/src/core/error/failures.dart';

abstract class AuthAction {}

@immutable
class LoginAction implements AuthAction {
  final String email;
  final String password;

  const LoginAction({required this.email, required this.password});
}

@immutable
class LoginSuccessAction implements AuthAction {
}

@immutable
class LoginFailureAction implements AuthAction {
  final Failure failure;

  const LoginFailureAction({required this.failure});
}

@immutable
class RefreshTokenAction implements AuthAction {
}

@immutable
class RefreshTokenSuccessAction implements AuthAction {
}

@immutable
class RefreshTokenFailureAction implements AuthAction {
  final Failure failure;

  const RefreshTokenFailureAction({required this.failure});
}

@immutable
class LogoutAction implements AuthAction {}

@immutable
class LogoutSuccessAction implements AuthAction {}

@immutable
class LogoutFailureAction implements AuthAction {
  final Failure failure;

  const LogoutFailureAction({required this.failure});
}