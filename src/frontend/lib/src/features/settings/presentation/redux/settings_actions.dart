/// Settings Redux: Actions
///
/// 設定機能のReduxアクション
library;

import 'package:tasbal/src/features/settings/domain/entities/user_preferences.dart';

// ============================================================
// 設定読み込み
// ============================================================

/// 設定読み込み開始
class LoadSettingsStartAction {}

/// 設定読み込み成功
class LoadSettingsSuccessAction {
  final UserPreferences preferences;

  LoadSettingsSuccessAction(this.preferences);
}

/// 設定読み込み失敗
class LoadSettingsFailureAction {
  final String message;

  LoadSettingsFailureAction(this.message);
}

// ============================================================
// 設定保存
// ============================================================

/// 設定保存開始
class SaveSettingsStartAction {}

/// 設定保存成功
class SaveSettingsSuccessAction {
  final UserPreferences preferences;

  SaveSettingsSuccessAction(this.preferences);
}

/// 設定保存失敗
class SaveSettingsFailureAction {
  final String message;

  SaveSettingsFailureAction(this.message);
}

// ============================================================
// 個別設定の更新
// ============================================================

/// 国コード更新
class UpdateCountryCodeAction {
  final String? countryCode;

  UpdateCountryCodeAction(this.countryCode);
}

/// 描画品質更新
class UpdateRenderQualityAction {
  final RenderQuality quality;

  UpdateRenderQualityAction(this.quality);
}

/// 省電力モード自動切替更新
class UpdateAutoLowPowerModeAction {
  final bool enabled;

  UpdateAutoLowPowerModeAction(this.enabled);
}

/// テーマモード更新
class UpdateThemeModeAction {
  final ThemeMode mode;

  UpdateThemeModeAction(this.mode);
}

/// 通知設定更新
class UpdateNotificationsEnabledAction {
  final bool enabled;

  UpdateNotificationsEnabledAction(this.enabled);
}

// ============================================================
// その他
// ============================================================

/// 設定リセット成功
class ResetSettingsSuccessAction {
  final UserPreferences preferences;

  ResetSettingsSuccessAction(this.preferences);
}

/// エラークリア
class ClearSettingsErrorAction {}

// ============================================================
// ローカル更新（Thunkを経由せず直接更新）
// ============================================================

/// ローカルでテーマモードを即座に更新
class UpdateThemeModeLocalAction {
  final ThemeMode mode;

  UpdateThemeModeLocalAction(this.mode);
}

/// ローカルで設定を即座に更新
class UpdatePreferencesLocalAction {
  final UserPreferences preferences;

  UpdatePreferencesLocalAction(this.preferences);
}
