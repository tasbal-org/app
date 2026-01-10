/// Core Utils: Thunk Helper
///
/// Redux-Thunkで非同期処理を扱うためのヘルパー関数
/// ボイラープレートを削減し、一貫したエラーハンドリングを提供
library;

import 'package:dartz/dartz.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:tasbal/src/core/error/failures.dart';

/// Thunk作成ヘルパー
///
/// 非同期処理を実行し、成功/失敗に応じてアクションをディスパッチ
///
/// [TResult] ユースケースの戻り値の型
/// [TAction] ディスパッチするアクションの基底型
/// [TState] Reduxストアの状態型
///
/// [triggerAction] 処理開始時にディスパッチするアクション
/// [useCase] 実行する非同期処理（`Either<Failure, TResult>`を返す）
/// [onSuccess] 成功時にディスパッチするアクションを生成
/// [onFailure] 失敗時にディスパッチするアクションを生成
/// [onSuccessCallback] 成功時の追加処理（画面遷移等）
/// [onFailureCallback] 失敗時の追加処理（エラー表示等）
/// [isLoading] グローバルローディング表示のON/OFF
ThunkAction<TState> createThunk<TResult, TAction, TState>({
  required TAction triggerAction,
  required Future<Either<Failure, TResult>> Function() useCase,
  required TAction Function(TResult result) onSuccess,
  required TAction Function(Failure failure) onFailure,
  void Function()? onSuccessCallback,
  void Function(Failure failure)? onFailureCallback,
  bool isLoading = false,
}) {
  return (Store<TState> store) async {
    // 1. 開始アクションをディスパッチ
    store.dispatch(triggerAction);

    // 2. グローバルローディング開始（必要な場合）
    if (isLoading) {
      // TODO: グローバルローディングアクションをディスパッチ
      // store.dispatch(SetLoadingAction(isLoading: true));
    }

    // 3. ユースケースを実行
    final result = await useCase();

    // 4. グローバルローディング終了（必要な場合）
    if (isLoading) {
      // TODO: グローバルローディングアクションをディスパッチ
      // store.dispatch(SetLoadingAction(isLoading: false));
    }

    // 5. 結果に応じてアクションをディスパッチ
    result.fold(
      (failure) {
        // 失敗時
        store.dispatch(onFailure(failure));
        onFailureCallback?.call(failure);
      },
      (data) {
        // 成功時
        store.dispatch(onSuccess(data));
        onSuccessCallback?.call();
      },
    );
  };
}
