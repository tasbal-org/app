/// Settings Use Case: Update Preferences
///
/// 設定更新ユースケース
library;

import 'package:dartz/dartz.dart';
import 'package:tasbal/src/core/error/failures.dart';
import 'package:tasbal/src/features/settings/domain/entities/user_preferences.dart';
import 'package:tasbal/src/features/settings/domain/repositories/settings_repository.dart';

/// 設定更新ユースケース
///
/// 各種設定を更新
class UpdatePreferencesUseCase {
  final SettingsRepository _repository;

  UpdatePreferencesUseCase(this._repository);

  /// 設定全体を更新
  Future<Either<Failure, UserPreferences>> call(UserPreferences preferences) {
    return _repository.savePreferences(preferences);
  }

  /// 国コードを更新
  Future<Either<Failure, UserPreferences>> updateCountryCode(
    String? countryCode,
  ) {
    return _repository.updateCountryCode(countryCode);
  }

  /// 描画品質を更新
  Future<Either<Failure, UserPreferences>> updateRenderQuality(
    RenderQuality quality,
  ) {
    return _repository.updateRenderQuality(quality);
  }

  /// 省電力モード自動切替を更新
  Future<Either<Failure, UserPreferences>> updateAutoLowPowerMode(
    bool enabled,
  ) {
    return _repository.updateAutoLowPowerMode(enabled);
  }

  /// テーマモードを更新
  Future<Either<Failure, UserPreferences>> updateThemeMode(ThemeMode mode) {
    return _repository.updateThemeMode(mode);
  }

  /// 設定をリセット
  Future<Either<Failure, UserPreferences>> reset() {
    return _repository.resetPreferences();
  }
}
