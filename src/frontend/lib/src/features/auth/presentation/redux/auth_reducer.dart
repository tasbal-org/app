/// Auth Reducer
///
/// 認証機能のReduxリデューサー
/// アクションに応じて状態を更新
library;

import 'package:tasbal/src/features/auth/presentation/redux/auth_actions.dart';
import 'package:tasbal/src/features/auth/presentation/redux/auth_state.dart';

/// 認証リデューサー
///
/// 各アクションに応じてAuthStateを更新して返す
AuthState authReducer(AuthState state, dynamic action) {
  // ============================================================
  // デバイス登録関連
  // ============================================================

  if (action is RegisterDeviceStartAction) {
    return state.copyWith(
      isAuthenticating: true,
      clearError: true,
    );
  }

  if (action is RegisterDeviceSuccessAction) {
    return state.copyWith(
      device: action.device,
      isAuthenticating: false,
      clearError: true,
    );
  }

  if (action is RegisterDeviceFailureAction) {
    return state.copyWith(
      isAuthenticating: false,
      errorMessage: action.errorMessage,
    );
  }

  // ============================================================
  // ゲスト認証関連
  // ============================================================

  if (action is GuestAuthStartAction) {
    return state.copyWith(
      isAuthenticating: true,
      clearError: true,
    );
  }

  if (action is GuestAuthSuccessAction) {
    return state.copyWith(
      user: action.user,
      token: action.token,
      isAuthenticating: false,
      clearError: true,
    );
  }

  if (action is GuestAuthFailureAction) {
    return state.copyWith(
      isAuthenticating: false,
      errorMessage: action.errorMessage,
    );
  }

  // ============================================================
  // トークン関連
  // ============================================================

  if (action is RefreshTokenStartAction) {
    return state.copyWith(
      isAuthenticating: true,
      clearError: true,
    );
  }

  if (action is RefreshTokenSuccessAction) {
    return state.copyWith(
      token: action.token,
      isAuthenticating: false,
      clearError: true,
    );
  }

  if (action is RefreshTokenFailureAction) {
    return state.copyWith(
      isAuthenticating: false,
      errorMessage: action.errorMessage,
    );
  }

  if (action is SetTokenAction) {
    return state.copyWith(
      token: action.token,
      clearToken: action.token == null,
    );
  }

  // ============================================================
  // ユーザー関連
  // ============================================================

  if (action is SetUserAction) {
    return state.copyWith(
      user: action.user,
      clearUser: action.user == null,
    );
  }

  if (action is ClearUserAction) {
    return state.copyWith(clearUser: true);
  }

  // ============================================================
  // デバイス関連
  // ============================================================

  if (action is SetDeviceAction) {
    return state.copyWith(
      device: action.device,
      clearDevice: action.device == null,
    );
  }

  // ============================================================
  // エラー関連
  // ============================================================

  if (action is ClearAuthErrorAction) {
    return state.copyWith(clearError: true);
  }

  // ============================================================
  // ログアウト関連
  // ============================================================

  if (action is LogoutStartAction) {
    return state.copyWith(
      isAuthenticating: true,
      clearError: true,
    );
  }

  if (action is LogoutSuccessAction) {
    return AuthState.initial(); // 完全にクリア
  }

  if (action is LogoutFailureAction) {
    return state.copyWith(
      isAuthenticating: false,
      errorMessage: action.errorMessage,
    );
  }

  return state;
}
