/// Auth Actions
///
/// 認証機能のReduxアクション
/// 認証状態の変更を表すアクション群
library;

import 'package:tasbal/src/features/auth/domain/entities/auth_token.dart';
import 'package:tasbal/src/features/auth/domain/entities/auth_user.dart';
import 'package:tasbal/src/features/auth/domain/entities/device.dart';

// ============================================================
// デバイス登録関連アクション
// ============================================================

/// デバイス登録開始
class RegisterDeviceStartAction {
  const RegisterDeviceStartAction();
}

/// デバイス登録成功
class RegisterDeviceSuccessAction {
  final Device device;

  const RegisterDeviceSuccessAction(this.device);
}

/// デバイス登録失敗
class RegisterDeviceFailureAction {
  final String errorMessage;

  const RegisterDeviceFailureAction(this.errorMessage);
}

// ============================================================
// ゲスト認証関連アクション
// ============================================================

/// ゲスト認証開始
class GuestAuthStartAction {
  const GuestAuthStartAction();
}

/// ゲスト認証成功
class GuestAuthSuccessAction {
  final AuthUser user;
  final AuthToken token;

  const GuestAuthSuccessAction({
    required this.user,
    required this.token,
  });
}

/// ゲスト認証失敗
class GuestAuthFailureAction {
  final String errorMessage;

  const GuestAuthFailureAction(this.errorMessage);
}

// ============================================================
// トークン関連アクション
// ============================================================

/// トークンリフレッシュ開始
class RefreshTokenStartAction {
  const RefreshTokenStartAction();
}

/// トークンリフレッシュ成功
class RefreshTokenSuccessAction {
  final AuthToken token;

  const RefreshTokenSuccessAction(this.token);
}

/// トークンリフレッシュ失敗
class RefreshTokenFailureAction {
  final String errorMessage;

  const RefreshTokenFailureAction(this.errorMessage);
}

/// トークンをセット（ローカルストレージから復元時など）
class SetTokenAction {
  final AuthToken? token;

  const SetTokenAction(this.token);
}

// ============================================================
// ユーザー関連アクション
// ============================================================

/// ユーザー情報をセット
class SetUserAction {
  final AuthUser? user;

  const SetUserAction(this.user);
}

/// ユーザー情報をクリア
class ClearUserAction {
  const ClearUserAction();
}

// ============================================================
// デバイス関連アクション
// ============================================================

/// デバイス情報をセット（ローカルストレージから復元時など）
class SetDeviceAction {
  final Device? device;

  const SetDeviceAction(this.device);
}

// ============================================================
// エラー関連アクション
// ============================================================

/// エラーメッセージをクリア
class ClearAuthErrorAction {
  const ClearAuthErrorAction();
}

// ============================================================
// ログアウト関連アクション
// ============================================================

/// ログアウト開始
class LogoutStartAction {
  const LogoutStartAction();
}

/// ログアウト成功
class LogoutSuccessAction {
  const LogoutSuccessAction();
}

/// ログアウト失敗
class LogoutFailureAction {
  final String errorMessage;

  const LogoutFailureAction(this.errorMessage);
}
