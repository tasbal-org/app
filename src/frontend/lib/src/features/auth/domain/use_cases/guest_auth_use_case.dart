/// Auth Domain: GuestAuthUseCase
///
/// ゲスト認証ユースケース
/// デバイスキーを使用してゲストユーザーとして認証
library;

import 'package:dartz/dartz.dart';
import 'package:tasbal/src/core/error/failures.dart';
import 'package:tasbal/src/features/auth/domain/entities/auth_token.dart';
import 'package:tasbal/src/features/auth/domain/entities/auth_user.dart';
import 'package:tasbal/src/features/auth/domain/repositories/auth_repository.dart';

/// ゲスト認証結果
class GuestAuthResult {
  final AuthUser user;
  final AuthToken token;

  GuestAuthResult({required this.user, required this.token});
}

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
  /// Returns: ユーザー情報とトークンを含む結果
  Future<Either<Failure, GuestAuthResult>> call({
    required String deviceKey,
  }) async {
    // ゲスト認証APIを呼び出し
    final result = await repository.guestAuth(deviceKey: deviceKey);

    return await result.fold(
      (failure) => Left(failure),
      (user) async {
        // 成功時はトークンがリポジトリ内で保存されているので取得
        final tokenResult = await repository.getSavedToken();

        return tokenResult.fold(
          (failure) => Left(failure),
          (token) {
            if (token == null) {
              return const Left(CacheFailure(
                message: '認証トークンの取得に失敗しました',
              ));
            }
            return Right(GuestAuthResult(user: user, token: token));
          },
        );
      },
    );
  }
}
