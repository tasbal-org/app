/// Task Thunks
///
/// タスク機能の非同期アクション
/// Redux-Thunkを使用してユースケースを実行
library;

import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:tasbal/src/features/task/domain/use_cases/create_task_use_case.dart';
import 'package:tasbal/src/features/task/domain/use_cases/delete_task_use_case.dart';
import 'package:tasbal/src/features/task/domain/use_cases/get_tasks_use_case.dart';
import 'package:tasbal/src/features/task/domain/use_cases/toggle_task_completion_use_case.dart';
import 'package:tasbal/src/features/task/domain/use_cases/toggle_task_pin_use_case.dart';
import 'package:tasbal/src/features/task/domain/use_cases/update_task_use_case.dart';
import 'package:tasbal/src/features/task/presentation/redux/task_actions.dart';
import 'package:tasbal/src/redux/app_state.dart';

/// タスク一覧取得Thunk
ThunkAction<AppState> fetchTasksThunk({
  required GetTasksUseCase useCase,
  bool includeHidden = false,
  bool includeExpired = false,
}) {
  return (Store<AppState> store) async {
    store.dispatch(const FetchTasksStartAction());

    final result = await useCase(
      includeHidden: includeHidden,
      includeExpired: includeExpired,
    );

    result.fold(
      (failure) {
        store.dispatch(FetchTasksFailureAction(failure.message));
      },
      (tasks) {
        store.dispatch(FetchTasksSuccessAction(tasks));
      },
    );
  };
}

/// タスク作成Thunk
ThunkAction<AppState> createTaskThunk({
  required CreateTaskUseCase useCase,
  required String title,
  String? memo,
  DateTime? dueAt,
  List<String> tags = const [],
}) {
  return (Store<AppState> store) async {
    store.dispatch(const CreateTaskStartAction());

    final result = await useCase(
      title: title,
      memo: memo,
      dueAt: dueAt,
      tags: tags,
    );

    result.fold(
      (failure) {
        store.dispatch(CreateTaskFailureAction(failure.message));
      },
      (task) {
        store.dispatch(CreateTaskSuccessAction(task));
      },
    );
  };
}

/// タスク更新Thunk
ThunkAction<AppState> updateTaskThunk({
  required UpdateTaskUseCase useCase,
  required String id,
  String? title,
  String? memo,
  DateTime? dueAt,
  List<String>? tags,
}) {
  return (Store<AppState> store) async {
    store.dispatch(const UpdateTaskStartAction());

    final result = await useCase(
      id: id,
      title: title,
      memo: memo,
      dueAt: dueAt,
      tags: tags,
    );

    result.fold(
      (failure) {
        store.dispatch(UpdateTaskFailureAction(failure.message));
      },
      (task) {
        store.dispatch(UpdateTaskSuccessAction(task));
      },
    );
  };
}

/// タスク完了切替Thunk
ThunkAction<AppState> toggleTaskCompletionThunk({
  required ToggleTaskCompletionUseCase useCase,
  required String id,
  required bool completed,
}) {
  return (Store<AppState> store) async {
    store.dispatch(const ToggleTaskCompletionStartAction());

    final result = await useCase(
      id: id,
      completed: completed,
    );

    result.fold(
      (failure) {
        store.dispatch(ToggleTaskCompletionFailureAction(failure.message));
      },
      (task) {
        store.dispatch(ToggleTaskCompletionSuccessAction(task));
        // TODO: 風船への加算処理を通知
      },
    );
  };
}

/// タスクピン留め切替Thunk
ThunkAction<AppState> toggleTaskPinThunk({
  required ToggleTaskPinUseCase useCase,
  required String id,
  required bool pinned,
}) {
  return (Store<AppState> store) async {
    store.dispatch(const ToggleTaskPinStartAction());

    final result = await useCase(
      id: id,
      pinned: pinned,
    );

    result.fold(
      (failure) {
        store.dispatch(ToggleTaskPinFailureAction(failure.message));
      },
      (task) {
        store.dispatch(ToggleTaskPinSuccessAction(task));
      },
    );
  };
}

/// タスク削除Thunk
ThunkAction<AppState> deleteTaskThunk({
  required DeleteTaskUseCase useCase,
  required String id,
}) {
  return (Store<AppState> store) async {
    store.dispatch(const DeleteTaskStartAction());

    final result = await useCase(id);

    result.fold(
      (failure) {
        store.dispatch(DeleteTaskFailureAction(failure.message));
      },
      (_) {
        store.dispatch(DeleteTaskSuccessAction(id));
      },
    );
  };
}
