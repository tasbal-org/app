/// Redux: App Reducer
///
/// アプリケーション全体のReducer
/// アクションに基づいてAppStateを更新
library;

import 'package:tasbal/src/redux/app_state.dart';
import 'package:tasbal/src/redux/app_actions.dart';

/// ルートReducer
///
/// すべてのアクションを受け取り、適切なReducerに振り分ける
/// 各機能のReducerと統合される
AppState appReducer(AppState state, dynamic action) {
  // グローバルローディングアクション
  if (action is SetLoadingAction) {
    return state.copyWith(isLoading: action.isLoading);
  }

  // TODO: 各機能のReducerを呼び出す
  // state = authReducer(state, action);
  // state = taskReducer(state, action);
  // state = balloonReducer(state, action);

  return state;
}
