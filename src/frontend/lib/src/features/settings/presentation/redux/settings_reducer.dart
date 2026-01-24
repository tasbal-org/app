/// Settings Redux: Reducer
///
/// 設定機能のReducer
library;

import 'package:tasbal/src/features/settings/presentation/redux/settings_state.dart';
import 'package:tasbal/src/features/settings/presentation/redux/settings_actions.dart';

/// 設定Reducer
///
/// 設定関連のアクションを処理してStateを更新
SettingsState settingsReducer(SettingsState state, dynamic action) {
  // 設定読み込み
  if (action is LoadSettingsStartAction) {
    return state.copyWith(
      isLoading: true,
      clearError: true,
    );
  }

  if (action is LoadSettingsSuccessAction) {
    return state.copyWith(
      preferences: action.preferences,
      isLoading: false,
    );
  }

  if (action is LoadSettingsFailureAction) {
    return state.copyWith(
      isLoading: false,
      errorMessage: action.message,
    );
  }

  // 設定保存
  if (action is SaveSettingsStartAction) {
    return state.copyWith(
      isSaving: true,
      clearError: true,
    );
  }

  if (action is SaveSettingsSuccessAction) {
    return state.copyWith(
      preferences: action.preferences,
      isSaving: false,
    );
  }

  if (action is SaveSettingsFailureAction) {
    return state.copyWith(
      isSaving: false,
      errorMessage: action.message,
    );
  }

  // 個別設定の更新（ローカル＆サーバー）
  if (action is UpdateCountryCodeAction) {
    return state.copyWith(
      preferences: state.preferences.copyWith(
        countryCode: action.countryCode,
        clearCountryCode: action.countryCode == null,
      ),
    );
  }

  if (action is UpdateRenderQualityAction) {
    return state.copyWith(
      preferences: state.preferences.copyWith(
        renderQuality: action.quality,
      ),
    );
  }

  if (action is UpdateAutoLowPowerModeAction) {
    return state.copyWith(
      preferences: state.preferences.copyWith(
        autoLowPowerMode: action.enabled,
      ),
    );
  }

  if (action is UpdateThemeModeAction) {
    return state.copyWith(
      preferences: state.preferences.copyWith(
        themeMode: action.mode,
      ),
    );
  }

  if (action is UpdateNotificationsEnabledAction) {
    return state.copyWith(
      preferences: state.preferences.copyWith(
        notificationsEnabled: action.enabled,
      ),
    );
  }

  // リセット
  if (action is ResetSettingsSuccessAction) {
    return state.copyWith(
      preferences: action.preferences,
    );
  }

  // エラークリア
  if (action is ClearSettingsErrorAction) {
    return state.copyWith(clearError: true);
  }

  // ローカル更新
  if (action is UpdateThemeModeLocalAction) {
    return state.copyWith(
      preferences: state.preferences.copyWith(
        themeMode: action.mode,
      ),
    );
  }

  if (action is UpdatePreferencesLocalAction) {
    return state.copyWith(
      preferences: action.preferences,
    );
  }

  return state;
}
