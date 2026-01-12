/// Core DI: Injection
///
/// 依存性注入（Dependency Injection）の設定
/// GetItを使用したService Locatorパターン
library;

import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:tasbal/src/core/network/dio_client.dart';
import 'package:tasbal/src/config/environment.dart';
import 'package:tasbal/src/features/auth/di/auth_injection.dart';
import 'package:tasbal/src/features/onboarding/di/onboarding_injection.dart';
import 'package:tasbal/src/features/task/di/task_injection.dart';

/// GetItのグローバルインスタンス
///
/// アプリ全体でこのインスタンスを使用して依存性を解決
final sl = GetIt.instance;

/// 依存性の登録
///
/// アプリケーション起動時に1度だけ呼び出される
/// Core層とFeature層の依存性を登録
Future<void> addDependencies() async {
  // ============================================================
  // Core層の依存性
  // ============================================================

  // DioClient を登録
  sl.registerLazySingleton<DioClient>(
    () => DioClient(
      baseUrl: Environment.isDev
          ? Environment.devBaseUrl + Environment.apiVersion
          : Environment.baseUrl + Environment.apiVersion,
    ),
  );

  // Dio インスタンスを登録
  sl.registerSingleton<Dio>(sl<DioClient>().instance);

  // ============================================================
  // Feature層の依存性（各機能ごとに分離）
  // ============================================================

  // 認証機能の依存性を登録
  await addAuthDependencies(sl);

  // オンボーディング機能の依存性を登録
  await addOnboardingDependencies(sl);

  // タスク機能の依存性を登録
  await addTaskDependencies(sl);

  // TODO: 風船機能の依存性を登録
  // await addBalloonDependencies(sl);
}

/// 依存性の解放
///
/// テスト時や再初期化時に使用
Future<void> removeDependencies() async {
  await sl.reset();
}
