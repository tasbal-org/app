/// Task Reducer
///
/// タスク機能のReduxリデューサー
/// アクションに応じて状態を更新
library;

import 'package:tasbal/src/features/task/presentation/redux/task_actions.dart';
import 'package:tasbal/src/features/task/presentation/redux/task_state.dart';

/// タスクリデューサー
///
/// 各アクションに応じてTaskStateを更新して返す
TaskState taskReducer(TaskState state, dynamic action) {
  // ============================================================
  // タスク一覧取得関連
  // ============================================================

  if (action is FetchTasksStartAction) {
    return state.copyWith(
      isLoading: true,
      clearError: true,
    );
  }

  if (action is FetchTasksSuccessAction) {
    return state.copyWith(
      tasks: action.tasks,
      isLoading: false,
      clearError: true,
    );
  }

  if (action is FetchTasksFailureAction) {
    return state.copyWith(
      isLoading: false,
      errorMessage: action.errorMessage,
    );
  }

  // ============================================================
  // タスク作成関連
  // ============================================================

  if (action is CreateTaskStartAction) {
    return state.copyWith(
      isUpdating: true,
      clearError: true,
    );
  }

  if (action is CreateTaskSuccessAction) {
    return state.copyWith(
      tasks: [...state.tasks, action.task],
      isUpdating: false,
      clearError: true,
    );
  }

  if (action is CreateTaskFailureAction) {
    return state.copyWith(
      isUpdating: false,
      errorMessage: action.errorMessage,
    );
  }

  // ============================================================
  // タスク更新関連
  // ============================================================

  if (action is UpdateTaskStartAction) {
    return state.copyWith(
      isUpdating: true,
      clearError: true,
    );
  }

  if (action is UpdateTaskSuccessAction) {
    final updatedTasks = state.tasks.map((task) {
      return task.id == action.task.id ? action.task : task;
    }).toList();

    return state.copyWith(
      tasks: updatedTasks,
      isUpdating: false,
      clearError: true,
    );
  }

  if (action is UpdateTaskFailureAction) {
    return state.copyWith(
      isUpdating: false,
      errorMessage: action.errorMessage,
    );
  }

  // ============================================================
  // タスク完了切替関連
  // ============================================================

  if (action is ToggleTaskCompletionStartAction) {
    return state.copyWith(
      isUpdating: true,
      clearError: true,
    );
  }

  if (action is ToggleTaskCompletionSuccessAction) {
    final updatedTasks = state.tasks.map((task) {
      return task.id == action.task.id ? action.task : task;
    }).toList();

    return state.copyWith(
      tasks: updatedTasks,
      isUpdating: false,
      clearError: true,
    );
  }

  if (action is ToggleTaskCompletionFailureAction) {
    return state.copyWith(
      isUpdating: false,
      errorMessage: action.errorMessage,
    );
  }

  // ============================================================
  // タスクピン留め切替関連
  // ============================================================

  if (action is ToggleTaskPinStartAction) {
    return state.copyWith(
      isUpdating: true,
      clearError: true,
    );
  }

  if (action is ToggleTaskPinSuccessAction) {
    final updatedTasks = state.tasks.map((task) {
      return task.id == action.task.id ? action.task : task;
    }).toList();

    return state.copyWith(
      tasks: updatedTasks,
      isUpdating: false,
      clearError: true,
    );
  }

  if (action is ToggleTaskPinFailureAction) {
    return state.copyWith(
      isUpdating: false,
      errorMessage: action.errorMessage,
    );
  }

  // ============================================================
  // タスク削除関連
  // ============================================================

  if (action is DeleteTaskStartAction) {
    return state.copyWith(
      isUpdating: true,
      clearError: true,
    );
  }

  if (action is DeleteTaskSuccessAction) {
    final filteredTasks = state.tasks.where((task) => task.id != action.taskId).toList();

    return state.copyWith(
      tasks: filteredTasks,
      isUpdating: false,
      clearError: true,
    );
  }

  if (action is DeleteTaskFailureAction) {
    return state.copyWith(
      isUpdating: false,
      errorMessage: action.errorMessage,
    );
  }

  // ============================================================
  // フィルタ切替関連
  // ============================================================

  if (action is ToggleShowHiddenAction) {
    return state.copyWith(showHidden: action.showHidden);
  }

  if (action is ToggleShowExpiredAction) {
    return state.copyWith(showExpired: action.showExpired);
  }

  // ============================================================
  // エラー関連
  // ============================================================

  if (action is ClearTaskErrorAction) {
    return state.copyWith(clearError: true);
  }

  return state;
}
