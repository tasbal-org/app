/// Task State
///
/// タスク機能のRedux状態
/// タスク一覧、フィルタ、ローディング状態を管理
library;

import 'package:equatable/equatable.dart';
import 'package:tasbal/src/features/task/domain/entities/task.dart';

/// タスク状態
///
/// アプリ全体で使用するタスク情報を保持
class TaskState extends Equatable {
  /// タスク一覧
  final List<Task> tasks;

  /// 非表示タスクを表示するか
  final bool showHidden;

  /// 期限切れタスク（アーカイブ）を表示するか
  final bool showExpired;

  /// タスク取得中フラグ
  final bool isLoading;

  /// タスク操作中フラグ（完了切替、ピン留め等）
  final bool isUpdating;

  /// エラーメッセージ
  final String? errorMessage;

  const TaskState({
    this.tasks = const [],
    this.showHidden = false,
    this.showExpired = false,
    this.isLoading = false,
    this.isUpdating = false,
    this.errorMessage,
  });

  /// 初期状態
  factory TaskState.initial() => const TaskState();

  /// 表示対象タスク一覧を取得
  ///
  /// フィルタ設定に応じてタスクをフィルタリング
  List<Task> get visibleTasks {
    return tasks.where((task) {
      if (!showHidden && task.isHidden) return false;
      if (!showExpired && task.isExpired) return false;
      return true;
    }).toList();
  }

  /// 通常タスク（未完了）
  List<Task> get activeTasks {
    return visibleTasks.where((task) => task.isActive && !task.isCompleted).toList();
  }

  /// 完了タスク（ピン留めは除外）
  List<Task> get completedTasks {
    return visibleTasks.where((task) => task.isCompleted && !task.isPinned).toList();
  }

  /// ピン留めされたタスク（完了状態も含む）
  List<Task> get pinnedTasks {
    return visibleTasks.where((task) => task.isPinned).toList();
  }

  /// 非ピン留めのタスク
  List<Task> get unpinnedTasks {
    return activeTasks.where((task) => !task.isPinned).toList();
  }

  /// 期限付きタスク（期限が設定されていて未完了、ピン留めは除外）
  List<Task> get tasksWithDueDate {
    return unpinnedTasks.where((task) => task.hasDueDate).toList()
      ..sort((a, b) => a.dueAt!.compareTo(b.dueAt!));
  }

  /// 期限なしタスク（期限が設定されていなくて未完了、ピン留めは除外）
  List<Task> get tasksWithoutDueDate {
    return unpinnedTasks.where((task) => !task.hasDueDate).toList();
  }

  /// 全タスクで使用されているタグ一覧（重複なし、アルファベット順）
  List<String> get allTags {
    final tagSet = <String>{};
    for (final task in tasks) {
      tagSet.addAll(task.tags);
    }
    return tagSet.toList()..sort();
  }

  @override
  List<Object?> get props => [
        tasks,
        showHidden,
        showExpired,
        isLoading,
        isUpdating,
        errorMessage,
      ];

  /// コピーwith
  TaskState copyWith({
    List<Task>? tasks,
    bool? showHidden,
    bool? showExpired,
    bool? isLoading,
    bool? isUpdating,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      showHidden: showHidden ?? this.showHidden,
      showExpired: showExpired ?? this.showExpired,
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
