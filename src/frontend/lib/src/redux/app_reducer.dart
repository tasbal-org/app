/// Redux: App Reducer
///
/// アプリケーション全体のReducer
/// アクションに基づいてAppStateを更新
library;

import 'package:tasbal/src/redux/app_state.dart';
import 'package:tasbal/src/redux/app_actions.dart';
import 'package:tasbal/src/features/auth/presentation/redux/auth_reducer.dart';

/// ルートReducer
///
/// すべてのアクションを受け取り、適切なReducerに振り分ける
/// 各機能のReducerと統合される
AppState appReducer(AppState state, dynamic action) {
  // グローバルローディングアクション
  if (action is SetLoadingAction) {
    return state.copyWith(isLoading: action.isLoading);
  }

  // 各機能のReducerを呼び出す
  // 認証状態の更新
  final newAuthState = authReducer(state.authState, action);

  // TODO: 他の機能のReducerを呼び出す
  // final newTaskState = taskReducer(state.taskState, action);
  // final newBalloonState = balloonReducer(state.balloonState, action);

  // 更新された状態を返す
  return state.copyWith(
    authState: newAuthState,
  );
}
