/// Auth Domain: RegisterDeviceUseCase
///
/// デバイス登録ユースケース
/// 初回起動時にデバイスを登録し、デバイスキーを取得
library;

import 'package:dartz/dartz.dart';
import 'package:tasbal/src/core/error/failures.dart';
import 'package:tasbal/src/features/auth/domain/entities/device.dart';
import 'package:tasbal/src/features/auth/domain/repositories/auth_repository.dart';

/// デバイス登録ユースケース
///
/// 初回起動時にデバイスを登録してデバイスキーを取得
/// 取得したデバイス情報はローカルに保存される
class RegisterDeviceUseCase {
  /// 認証リポジトリ
  final AuthRepository repository;

  /// コンストラクタ
  RegisterDeviceUseCase(this.repository);

  /// デバイスを登録
  ///
  /// [deviceName] デバイス名（例: "Yohei's iPhone"）
  /// [pushToken] プッシュ通知用トークン（任意）
  Future<Either<Failure, Device>> call({
    required String deviceName,
    String? pushToken,
  }) async {
    // デバイス登録APIを呼び出し
    final result = await repository.registerDevice(
      deviceName: deviceName,
      pushToken: pushToken,
    );

    // 成功時はデバイス情報をローカルに保存
    return result.fold(
      (failure) => Left(failure),
      (device) async {
        await repository.saveDevice(device);
        return Right(device);
      },
    );
  }
}
