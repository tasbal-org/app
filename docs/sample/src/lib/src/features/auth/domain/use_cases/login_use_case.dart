import 'package:dartz/dartz.dart';
import 'package:qrino_admin/src/core/error/failures.dart';
import 'package:qrino_admin/src/features/auth/data/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, void>> call(String email, String password) async {
    return await repository.login(email, password);
  }
}