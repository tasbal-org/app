/// Settings Redux: Thunks
///
/// 設定機能の非同期アクション
library;

import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:tasbal/src/features/settings/domain/entities/user_preferences.dart';
import 'package:tasbal/src/features/settings/domain/use_cases/get_preferences_use_case.dart';
import 'package:tasbal/src/features/settings/domain/use_cases/update_preferences_use_case.dart';
import 'package:tasbal/src/features/settings/presentation/redux/settings_actions.dart';
import 'package:tasbal/src/redux/app_state.dart';

/// 設定を読み込むThunk
ThunkAction<AppState> loadSettingsThunk({
  required GetPreferencesUseCase useCase,
}) {
  return (Store<AppState> store) async {
    store.dispatch(LoadSettingsStartAction());

    final result = await useCase();

    result.fold(
      (failure) {
        store.dispatch(LoadSettingsFailureAction(failure.message));
      },
      (preferences) {
        store.dispatch(LoadSettingsSuccessAction(preferences));
      },
    );
  };
}

/// 設定を保存するThunk
ThunkAction<AppState> saveSettingsThunk({
  required UpdatePreferencesUseCase useCase,
  required UserPreferences preferences,
}) {
  return (Store<AppState> store) async {
    store.dispatch(SaveSettingsStartAction());

    final result = await useCase(preferences);

    result.fold(
      (failure) {
        store.dispatch(SaveSettingsFailureAction(failure.message));
      },
      (savedPreferences) {
        store.dispatch(SaveSettingsSuccessAction(savedPreferences));
      },
    );
  };
}

/// 国コードを更新するThunk
ThunkAction<AppState> updateCountryCodeThunk({
  required UpdatePreferencesUseCase useCase,
  required String? countryCode,
}) {
  return (Store<AppState> store) async {
    // 楽観的更新：先にローカルを更新
    store.dispatch(UpdateCountryCodeAction(countryCode));

    final result = await useCase.updateCountryCode(countryCode);

    result.fold(
      (failure) {
        store.dispatch(SaveSettingsFailureAction(failure.message));
      },
      (preferences) {
        store.dispatch(SaveSettingsSuccessAction(preferences));
      },
    );
  };
}

/// 描画品質を更新するThunk
ThunkAction<AppState> updateRenderQualityThunk({
  required UpdatePreferencesUseCase useCase,
  required RenderQuality quality,
}) {
  return (Store<AppState> store) async {
    // 楽観的更新
    store.dispatch(UpdateRenderQualityAction(quality));

    final result = await useCase.updateRenderQuality(quality);

    result.fold(
      (failure) {
        store.dispatch(SaveSettingsFailureAction(failure.message));
      },
      (preferences) {
        store.dispatch(SaveSettingsSuccessAction(preferences));
      },
    );
  };
}

/// 省電力モード自動切替を更新するThunk
ThunkAction<AppState> updateAutoLowPowerModeThunk({
  required UpdatePreferencesUseCase useCase,
  required bool enabled,
}) {
  return (Store<AppState> store) async {
    // 楽観的更新
    store.dispatch(UpdateAutoLowPowerModeAction(enabled));

    final result = await useCase.updateAutoLowPowerMode(enabled);

    result.fold(
      (failure) {
        store.dispatch(SaveSettingsFailureAction(failure.message));
      },
      (preferences) {
        store.dispatch(SaveSettingsSuccessAction(preferences));
      },
    );
  };
}

/// テーマモードを更新するThunk
ThunkAction<AppState> updateThemeModeThunk({
  required UpdatePreferencesUseCase useCase,
  required ThemeMode mode,
}) {
  return (Store<AppState> store) async {
    // 楽観的更新（UIをすぐに反映）
    store.dispatch(UpdateThemeModeAction(mode));

    final result = await useCase.updateThemeMode(mode);

    result.fold(
      (failure) {
        store.dispatch(SaveSettingsFailureAction(failure.message));
      },
      (preferences) {
        store.dispatch(SaveSettingsSuccessAction(preferences));
      },
    );
  };
}

/// 設定をリセットするThunk
ThunkAction<AppState> resetSettingsThunk({
  required UpdatePreferencesUseCase useCase,
}) {
  return (Store<AppState> store) async {
    store.dispatch(SaveSettingsStartAction());

    final result = await useCase.reset();

    result.fold(
      (failure) {
        store.dispatch(SaveSettingsFailureAction(failure.message));
      },
      (preferences) {
        store.dispatch(ResetSettingsSuccessAction(preferences));
      },
    );
  };
}
