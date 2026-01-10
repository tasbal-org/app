/// Auth Thunks
///
/// 認証機能の非同期アクション
/// Redux-Thunkを使用してユースケースを実行
library;

import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:tasbal/src/features/auth/domain/use_cases/guest_auth_use_case.dart';
import 'package:tasbal/src/features/auth/domain/use_cases/register_device_use_case.dart';
import 'package:tasbal/src/features/auth/presentation/redux/auth_actions.dart';
import 'package:tasbal/src/redux/app_state.dart';

/// デバイス登録Thunk
///
/// デバイス登録ユースケースを実行し、結果に応じてアクションをディスパッチ
ThunkAction<AppState> registerDeviceThunk({
  required String deviceName,
  String? pushToken,
}) {
  return (Store<AppState> store) async {
    // 登録開始アクションをディスパッチ
    store.dispatch(const RegisterDeviceStartAction());

    // ユースケースの取得はDIから行う想定
    // ここではパラメータとして受け取る形に変更
    // 実際の使用時はwidgetからDIコンテナ経由で取得したユースケースを渡す
  };
}

/// ゲスト認証Thunk
///
/// ゲスト認証ユースケースを実行し、結果に応じてアクションをディスパッチ
ThunkAction<AppState> guestAuthThunk({
  required GuestAuthUseCase useCase,
  required String deviceKey,
}) {
  return (Store<AppState> store) async {
    // 認証開始アクションをディスパッチ
    store.dispatch(const GuestAuthStartAction());

    // ユースケース実行
    final result = await useCase(deviceKey: deviceKey);

    // 結果に応じてアクションをディスパッチ
    result.fold(
      (failure) {
        store.dispatch(GuestAuthFailureAction(failure.message));
      },
      (authResult) {
        store.dispatch(GuestAuthSuccessAction(
          user: authResult.user,
          token: authResult.token,
        ));
      },
    );
  };
}

/// デバイス登録 + ゲスト認証Thunk
///
/// デバイス登録とゲスト認証を連続して実行
/// スプラッシュ画面での初期化時に使用
ThunkAction<AppState> registerAndAuthThunk({
  required RegisterDeviceUseCase registerDeviceUseCase,
  required GuestAuthUseCase guestAuthUseCase,
  required String deviceName,
  String? pushToken,
}) {
  return (Store<AppState> store) async {
    // 1. デバイス登録
    store.dispatch(const RegisterDeviceStartAction());

    final registerResult = await registerDeviceUseCase(
      deviceName: deviceName,
      pushToken: pushToken,
    );

    String? deviceKey;

    final registerSuccess = registerResult.fold(
      (failure) {
        store.dispatch(RegisterDeviceFailureAction(failure.message));
        return false;
      },
      (device) {
        deviceKey = device.deviceKey;
        store.dispatch(RegisterDeviceSuccessAction(device));
        return true;
      },
    );

    // デバイス登録失敗時は終了
    if (!registerSuccess || deviceKey == null) {
      return;
    }

    // 2. ゲスト認証
    store.dispatch(const GuestAuthStartAction());

    final authResult = await guestAuthUseCase(deviceKey: deviceKey!);

    authResult.fold(
      (failure) {
        store.dispatch(GuestAuthFailureAction(failure.message));
      },
      (result) {
        store.dispatch(GuestAuthSuccessAction(
          user: result.user,
          token: result.token,
        ));
      },
    );
  };
}

/// トークンリフレッシュThunk
///
/// トークンをリフレッシュし、新しいトークンを保存
/// （将来的にリフレッシュAPIが実装された際に使用）
ThunkAction<AppState> refreshTokenThunk() {
  return (Store<AppState> store) async {
    store.dispatch(const RefreshTokenStartAction());

    // TODO: リフレッシュトークンユースケースの実装
    // 現在はゲスト認証のみなのでリフレッシュ機能は未実装

    store.dispatch(const RefreshTokenFailureAction(
      'トークンリフレッシュは未実装です',
    ));
  };
}

/// ログアウトThunk
///
/// ローカルストレージからトークンとユーザー情報を削除
ThunkAction<AppState> logoutThunk() {
  return (Store<AppState> store) async {
    store.dispatch(const LogoutStartAction());

    // TODO: ログアウトユースケースの実装
    // ローカルストレージのクリアなど

    // とりあえず状態のクリアのみ
    store.dispatch(const LogoutSuccessAction());
  };
}
