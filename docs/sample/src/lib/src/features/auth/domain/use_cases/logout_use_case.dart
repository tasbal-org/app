import 'package:dartz/dartz.dart';
import 'package:qrino_admin/src/core/error/failures.dart';
import 'package:qrino_admin/src/features/auth/data/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.logout();
  }
}