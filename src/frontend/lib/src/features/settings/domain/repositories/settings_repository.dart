/// Settings Domain: Repository Interface
///
/// 設定リポジトリのインターフェース
/// ドメイン層で定義し、データ層で実装
library;

import 'package:dartz/dartz.dart';
import 'package:tasbal/src/core/error/failures.dart';
import 'package:tasbal/src/features/settings/domain/entities/user_preferences.dart';

/// 設定リポジトリインターフェース
///
/// 設定の取得・保存を抽象化
abstract class SettingsRepository {
  /// 設定を取得
  ///
  /// Returns: ユーザー設定（取得失敗時はFailure）
  Future<Either<Failure, UserPreferences>> getPreferences();

  /// 設定を保存
  ///
  /// [preferences] 保存する設定
  /// Returns: 保存成功時は保存した設定、失敗時はFailure
  Future<Either<Failure, UserPreferences>> savePreferences(
    UserPreferences preferences,
  );

  /// 国コードを更新
  ///
  /// [countryCode] 国コード（nullで未設定に）
  Future<Either<Failure, UserPreferences>> updateCountryCode(
    String? countryCode,
  );

  /// 描画品質を更新
  ///
  /// [quality] 描画品質
  Future<Either<Failure, UserPreferences>> updateRenderQuality(
    RenderQuality quality,
  );

  /// 省電力モード自動切替設定を更新
  ///
  /// [enabled] 有効/無効
  Future<Either<Failure, UserPreferences>> updateAutoLowPowerMode(
    bool enabled,
  );

  /// テーマモードを更新
  ///
  /// [mode] テーマモード
  Future<Either<Failure, UserPreferences>> updateThemeMode(ThemeMode mode);

  /// 設定をリセット
  ///
  /// 全設定を初期値に戻す
  Future<Either<Failure, UserPreferences>> resetPreferences();
}
