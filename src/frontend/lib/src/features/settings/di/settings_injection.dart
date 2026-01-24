/// Settings DI: Dependency Injection
///
/// 設定機能の依存性注入設定
library;

import 'package:get_it/get_it.dart';
import 'package:tasbal/src/features/settings/data/data_sources/local/settings_local_service.dart';
import 'package:tasbal/src/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:tasbal/src/features/settings/domain/repositories/settings_repository.dart';
import 'package:tasbal/src/features/settings/domain/use_cases/get_preferences_use_case.dart';
import 'package:tasbal/src/features/settings/domain/use_cases/update_preferences_use_case.dart';

/// 設定機能の依存性を登録
Future<void> addSettingsDependencies(GetIt sl) async {
  // ============================================================
  // Data Sources
  // ============================================================
  sl.registerLazySingleton<SettingsLocalService>(
    () => SettingsLocalService(),
  );

  // ============================================================
  // Repositories
  // ============================================================
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(
      localService: sl<SettingsLocalService>(),
    ),
  );

  // ============================================================
  // Use Cases
  // ============================================================
  sl.registerFactory<GetPreferencesUseCase>(
    () => GetPreferencesUseCase(sl<SettingsRepository>()),
  );

  sl.registerFactory<UpdatePreferencesUseCase>(
    () => UpdatePreferencesUseCase(sl<SettingsRepository>()),
  );
}
