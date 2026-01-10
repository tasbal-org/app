/// Auth Domain: GuestAuthUseCase
///
/// ゲスト認証ユースケース
/// デバイスキーを使用してゲストユーザーとして認証
library;

import 'package:dartz/dartz.dart';
import 'package:tasbal/src/core/error/failures.dart';
import 'package:tasbal/src/features/auth/domain/entities/auth_user.dart';
import 'package:tasbal/src/features/auth/domain/repositories/auth_repository.dart';

/// ゲスト認証ユースケース
///
/// デバイスキーを使用してゲストユーザーとして認証
/// 認証トークンを取得してローカルに保存
class GuestAuthUseCase {
  /// 認証リポジトリ
  final AuthRepository repository;

  /// コンストラクタ
  GuestAuthUseCase(this.repository);

  /// ゲスト認証を実行
  ///
  /// [deviceKey] デバイス登録時に発行されたキー
  Future<Either<Failure, AuthUser>> call({
    required String deviceKey,
  }) async {
    // ゲスト認証APIを呼び出し
    final result = await repository.guestAuth(deviceKey: deviceKey);

    // 成功時はトークンがリポジトリ内で保存される
    return result;
  }
}
