/// Auth DI: Injection
///
/// Auth機能の依存性注入設定
/// データソース、リポジトリ、ユースケースを登録
library;

import 'package:get_it/get_it.dart';
import 'package:tasbal/src/features/auth/data/data_sources/local/auth_local_service.dart';
import 'package:tasbal/src/features/auth/data/data_sources/remote/auth_api_service.dart';
import 'package:tasbal/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:tasbal/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:tasbal/src/features/auth/domain/use_cases/guest_auth_use_case.dart';
import 'package:tasbal/src/features/auth/domain/use_cases/register_device_use_case.dart';

/// Auth機能の依存性を登録
///
/// アプリ起動時にCore DIから呼び出される
Future<void> addAuthDependencies(GetIt sl) async {
  // ============================================================
  // Data Sources
  // ============================================================

  // Remote
  sl.registerLazySingleton<AuthApiService>(
    () => AuthApiService(sl()),
  );

  // Local
  sl.registerLazySingleton<AuthLocalService>(
    () => AuthLocalService(),
  );

  // ============================================================
  // Repository
  // ============================================================

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      apiService: sl(),
      localService: sl(),
    ),
  );

  // ============================================================
  // Use Cases
  // ============================================================

  sl.registerLazySingleton<RegisterDeviceUseCase>(
    () => RegisterDeviceUseCase(sl()),
  );

  sl.registerLazySingleton<GuestAuthUseCase>(
    () => GuestAuthUseCase(sl()),
  );
}
