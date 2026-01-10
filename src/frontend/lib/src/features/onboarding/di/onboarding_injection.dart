/// Onboarding DI: Injection
///
/// Onboarding機能の依存性注入設定
/// データソース、リポジトリ、ユースケースを登録
library;

import 'package:get_it/get_it.dart';
import 'package:tasbal/src/features/onboarding/data/data_sources/local/onboarding_local_service.dart';
import 'package:tasbal/src/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:tasbal/src/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:tasbal/src/features/onboarding/domain/use_cases/check_onboarding_use_case.dart';
import 'package:tasbal/src/features/onboarding/domain/use_cases/complete_onboarding_use_case.dart';

/// Onboarding機能の依存性を登録
///
/// アプリ起動時にCore DIから呼び出される
Future<void> addOnboardingDependencies(GetIt sl) async {
  // ============================================================
  // Data Sources
  // ============================================================

  // Local
  sl.registerLazySingleton<OnboardingLocalService>(
    () => OnboardingLocalService(),
  );

  // ============================================================
  // Repository
  // ============================================================

  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(
      localService: sl(),
    ),
  );

  // ============================================================
  // Use Cases
  // ============================================================

  sl.registerLazySingleton<CompleteOnboardingUseCase>(
    () => CompleteOnboardingUseCase(sl()),
  );

  sl.registerLazySingleton<CheckOnboardingUseCase>(
    () => CheckOnboardingUseCase(sl()),
  );
}
