import 'package:equatable/equatable.dart';
import 'package:qrino_admin/src/core/constants/status.dart';
import 'package:qrino_admin/src/core/error/failures.dart';
import 'package:qrino_admin/src/features/auth/domain/entities/token.dart';

class AuthState extends Equatable {
  final Status status;
  final Failure? failure;

  const AuthState({
    required this.status,
    this.failure,
  });

  factory AuthState.initial() => const AuthState(status: Status.initial);

  AuthState copyWith({
    Status? status,
    Token? token,
    Failure? failure,
  }) => AuthState(
        status: status ?? this.status,
        failure: failure ?? this.failure,
      );

  @override
  List<Object?> get props => [status, failure];
}