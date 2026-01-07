import 'package:get_it/get_it.dart';
import 'package:qrino_admin/src/features/auth/data/data_sources/local/auth_local_service.dart';
import 'package:qrino_admin/src/features/auth/data/data_sources/remote/auth_api_service.dart';
import 'package:qrino_admin/src/features/auth/data/repositories/auth_repository.dart';
import 'package:qrino_admin/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:qrino_admin/src/features/auth/domain/use_cases/login_use_case.dart';
import 'package:qrino_admin/src/features/auth/domain/use_cases/logout_use_case.dart';
import 'package:qrino_admin/src/features/auth/domain/use_cases/refresh_token_use_case.dart';

Future<void> addAuthDependencies(GetIt sl) async {
  sl.registerLazySingleton(() => AuthApiService(sl()));
  sl.registerLazySingleton(() => AuthLocalService());
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(apiService: sl(),localService: sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RefreshTokenUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
}