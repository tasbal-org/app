import 'package:dartz/dartz.dart';
import 'package:qrino_admin/src/core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> login(String email, String password);
  Future<Either<Failure, void>> refreshToken();
  Future<Either<Failure, void>> logout();
}