import 'package:dartz/dartz.dart';
import 'package:qrino_admin/src/core/error/failures.dart';
import 'package:qrino_admin/src/features/auth/data/repositories/auth_repository.dart';

class RefreshTokenUseCase {
  final AuthRepository repository;

  RefreshTokenUseCase(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.refreshToken();
  }
}