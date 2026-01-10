/// Auth Domain: AuthRepository Interface
///
/// 認証機能のリポジトリインターフェース
/// Data層で実装される
library;

import 'package:dartz/dartz.dart';
import 'package:tasbal/src/core/error/failures.dart';
import 'package:tasbal/src/features/auth/domain/entities/auth_token.dart';
import 'package:tasbal/src/features/auth/domain/entities/auth_user.dart';
import 'package:tasbal/src/features/auth/domain/entities/device.dart';

/// 認証リポジトリインターフェース
///
/// ゲスト認証、トークン管理、デバイス登録等の操作を定義
abstract class AuthRepository {
  /// デバイス登録
  ///
  /// 初回起動時にデバイス情報を登録
  /// [deviceName] デバイス名（例: "Yohei's iPhone"）
  /// [pushToken] プッシュ通知用トークン（任意）
  Future<Either<Failure, Device>> registerDevice({
    required String deviceName,
    String? pushToken,
  });

  /// ゲスト認証
  ///
  /// デバイスキーを使用してゲストユーザーとして認証
  /// [deviceKey] デバイス登録時に発行されたキー
  Future<Either<Failure, AuthUser>> guestAuth({
    required String deviceKey,
  });

  /// トークンリフレッシュ
  ///
  /// リフレッシュトークンを使用してアクセストークンを更新
  Future<Either<Failure, AuthToken>> refreshToken();

  /// ローカルに保存されたトークンを取得
  Future<Either<Failure, AuthToken?>> getSavedToken();

  /// トークンを保存
  ///
  /// [token] 保存する認証トークン
  Future<Either<Failure, void>> saveToken(AuthToken token);

  /// トークンを削除（ログアウト）
  Future<Either<Failure, void>> clearToken();

  /// ローカルに保存されたデバイス情報を取得
  Future<Either<Failure, Device?>> getSavedDevice();

  /// デバイス情報を保存
  ///
  /// [device] 保存するデバイス情報
  Future<Either<Failure, void>> saveDevice(Device device);
}
