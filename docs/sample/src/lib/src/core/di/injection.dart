import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:qrino_admin/src/core/network/dio_client.dart';
import 'package:qrino_admin/src/features/auth/di/auth_injection.dart';

final sl = GetIt.instance;

Future<void> addDependencies() async {

  // Dioクライアント
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerSingleton<Dio>(sl<DioClient>().instance);

  // 認証関連の依存関係を初期化
  await addAuthDependencies(sl);
}