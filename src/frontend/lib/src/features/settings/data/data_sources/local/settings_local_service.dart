/// Settings Local Service
///
/// 設定のローカルストレージ操作を管理
/// Hiveを使用して設定を永続化
library;

import 'package:hive_flutter/hive_flutter.dart';
import 'package:tasbal/src/core/error/exceptions.dart';
import 'package:tasbal/src/features/settings/domain/entities/user_preferences.dart';

/// 設定ローカルサービス
///
/// 設定をHiveで永続化
class SettingsLocalService {
  /// Hiveボックス名
  static const String _boxName = 'settings_box';

  /// キー定義
  static const String _countryCodeKey = 'country_code';
  static const String _renderQualityKey = 'render_quality';
  static const String _autoLowPowerModeKey = 'auto_low_power_mode';
  static const String _themeModeKey = 'theme_mode';
  static const String _notificationsEnabledKey = 'notifications_enabled';

  /// 設定を取得
  Future<UserPreferences> getPreferences() async {
    try {
      final box = await Hive.openBox(_boxName);

      final countryCode = box.get(_countryCodeKey) as String?;
      final renderQualityIndex =
          box.get(_renderQualityKey, defaultValue: 0) as int;
      final autoLowPowerMode =
          box.get(_autoLowPowerModeKey, defaultValue: true) as bool;
      final themeModeIndex = box.get(_themeModeKey, defaultValue: 0) as int;
      final notificationsEnabled =
          box.get(_notificationsEnabledKey, defaultValue: false) as bool;

      return UserPreferences(
        countryCode: countryCode,
        renderQuality: RenderQuality.values[renderQualityIndex],
        autoLowPowerMode: autoLowPowerMode,
        themeMode: ThemeMode.values[themeModeIndex],
        notificationsEnabled: notificationsEnabled,
      );
    } catch (e) {
      throw CacheException(
        message: 'Failed to get preferences: $e',
      );
    }
  }

  /// 設定を保存
  Future<void> savePreferences(UserPreferences preferences) async {
    try {
      final box = await Hive.openBox(_boxName);

      await box.put(_countryCodeKey, preferences.countryCode);
      await box.put(_renderQualityKey, preferences.renderQuality.index);
      await box.put(_autoLowPowerModeKey, preferences.autoLowPowerMode);
      await box.put(_themeModeKey, preferences.themeMode.index);
      await box.put(_notificationsEnabledKey, preferences.notificationsEnabled);
    } catch (e) {
      throw CacheException(
        message: 'Failed to save preferences: $e',
      );
    }
  }

  /// 国コードを保存
  Future<void> saveCountryCode(String? countryCode) async {
    try {
      final box = await Hive.openBox(_boxName);
      await box.put(_countryCodeKey, countryCode);
    } catch (e) {
      throw CacheException(
        message: 'Failed to save country code: $e',
      );
    }
  }

  /// 描画品質を保存
  Future<void> saveRenderQuality(RenderQuality quality) async {
    try {
      final box = await Hive.openBox(_boxName);
      await box.put(_renderQualityKey, quality.index);
    } catch (e) {
      throw CacheException(
        message: 'Failed to save render quality: $e',
      );
    }
  }

  /// 省電力モード自動切替を保存
  Future<void> saveAutoLowPowerMode(bool enabled) async {
    try {
      final box = await Hive.openBox(_boxName);
      await box.put(_autoLowPowerModeKey, enabled);
    } catch (e) {
      throw CacheException(
        message: 'Failed to save auto low power mode: $e',
      );
    }
  }

  /// テーマモードを保存
  Future<void> saveThemeMode(ThemeMode mode) async {
    try {
      final box = await Hive.openBox(_boxName);
      await box.put(_themeModeKey, mode.index);
    } catch (e) {
      throw CacheException(
        message: 'Failed to save theme mode: $e',
      );
    }
  }

  /// 通知設定を保存
  Future<void> saveNotificationsEnabled(bool enabled) async {
    try {
      final box = await Hive.openBox(_boxName);
      await box.put(_notificationsEnabledKey, enabled);
    } catch (e) {
      throw CacheException(
        message: 'Failed to save notifications enabled: $e',
      );
    }
  }

  /// 設定をクリア
  Future<void> clearPreferences() async {
    try {
      final box = await Hive.openBox(_boxName);
      await box.clear();
    } catch (e) {
      throw CacheException(
        message: 'Failed to clear preferences: $e',
      );
    }
  }
}
