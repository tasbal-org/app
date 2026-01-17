/// Task Actions
///
/// タスク機能のReduxアクション
/// タスク状態の変更を表すアクション群
library;

import 'package:tasbal/src/features/task/domain/entities/task.dart';

// ============================================================
// タスク取得関連アクション
// ============================================================

/// タスク一覧取得開始
class FetchTasksStartAction {
  const FetchTasksStartAction();
}

/// タスク一覧取得成功
class FetchTasksSuccessAction {
  final List<Task> tasks;

  const FetchTasksSuccessAction(this.tasks);
}

/// タスク一覧取得失敗
class FetchTasksFailureAction {
  final String errorMessage;

  const FetchTasksFailureAction(this.errorMessage);
}

// ============================================================
// タスク作成関連アクション
// ============================================================

/// タスク作成開始
class CreateTaskStartAction {
  const CreateTaskStartAction();
}

/// タスク作成成功
class CreateTaskSuccessAction {
  final Task task;

  const CreateTaskSuccessAction(this.task);
}

/// タスク作成失敗
class CreateTaskFailureAction {
  final String errorMessage;

  const CreateTaskFailureAction(this.errorMessage);
}

// ============================================================
// タスク更新関連アクション
// ============================================================

/// タスク更新開始
class UpdateTaskStartAction {
  const UpdateTaskStartAction();
}

/// タスク更新成功
class UpdateTaskSuccessAction {
  final Task task;

  const UpdateTaskSuccessAction(this.task);
}

/// タスク更新失敗
class UpdateTaskFailureAction {
  final String errorMessage;

  const UpdateTaskFailureAction(this.errorMessage);
}

// ============================================================
// タスク完了切替関連アクション
// ============================================================

/// タスク完了切替開始
class ToggleTaskCompletionStartAction {
  const ToggleTaskCompletionStartAction();
}

/// タスク完了切替成功
class ToggleTaskCompletionSuccessAction {
  final Task task;

  const ToggleTaskCompletionSuccessAction(this.task);
}

/// タスク完了切替失敗
class ToggleTaskCompletionFailureAction {
  final String errorMessage;

  const ToggleTaskCompletionFailureAction(this.errorMessage);
}

// ============================================================
// タスクピン留め切替関連アクション
// ============================================================

/// タスクピン留め切替開始
class ToggleTaskPinStartAction {
  const ToggleTaskPinStartAction();
}

/// タスクピン留め切替成功
class ToggleTaskPinSuccessAction {
  final Task task;

  const ToggleTaskPinSuccessAction(this.task);
}

/// タスクピン留め切替失敗
class ToggleTaskPinFailureAction {
  final String errorMessage;

  const ToggleTaskPinFailureAction(this.errorMessage);
}

// ============================================================
// タスク削除関連アクション
// ============================================================

/// タスク削除開始
class DeleteTaskStartAction {
  const DeleteTaskStartAction();
}

/// タスク削除成功
class DeleteTaskSuccessAction {
  final String taskId;

  const DeleteTaskSuccessAction(this.taskId);
}

/// タスク削除失敗
class DeleteTaskFailureAction {
  final String errorMessage;

  const DeleteTaskFailureAction(this.errorMessage);
}

// ============================================================
// フィルタ切替関連アクション
// ============================================================

/// 非表示タスク表示切替
class ToggleShowHiddenAction {
  final bool showHidden;

  const ToggleShowHiddenAction(this.showHidden);
}

/// 期限切れタスク表示切替
class ToggleShowExpiredAction {
  final bool showExpired;

  const ToggleShowExpiredAction(this.showExpired);
}

// ============================================================
// エラー関連アクション
// ============================================================

/// エラーメッセージをクリア
class ClearTaskErrorAction {
  const ClearTaskErrorAction();
}

// ============================================================
// デモデータ関連アクション
// ============================================================

/// デモデータをロード
class LoadDemoTasksAction {
  final List<Task> tasks;

  const LoadDemoTasksAction(this.tasks);
}
