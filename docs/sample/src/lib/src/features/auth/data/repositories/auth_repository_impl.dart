import 'package:dartz/dartz.dart';
import 'package:qrino_admin/src/core/error/exceptions.dart';
import 'package:qrino_admin/src/core/error/failures.dart';
import 'package:qrino_admin/src/features/auth/data/data_sources/remote/auth_api_service.dart';
import 'package:qrino_admin/src/features/auth/data/data_sources/local/auth_local_service.dart';
import 'package:qrino_admin/src/features/auth/data/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService apiService;
  final AuthLocalService localService;

  AuthRepositoryImpl({
    required this.apiService,
    required this.localService,
  });

  @override
  Future<Either<Failure, void>> login(String email, String password) async {
    try {
      await apiService.login(email, password);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> refreshToken() async {
    try {
      await apiService.refreshToken();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localService.clearToken();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}