/// Task Repository Interface
///
/// タスク機能のリポジトリインターフェース
/// ローカルストレージとAPIとの通信を抽象化
library;

import 'package:dartz/dartz.dart' hide Task;
import 'package:tasbal/src/core/error/failures.dart';
import 'package:tasbal/src/enums/task_state.dart';
import 'package:tasbal/src/features/task/domain/entities/task.dart';

/// タスクリポジトリ
///
/// タスクのCRUD操作と同期を担当
abstract class TaskRepository {
  /// タスク一覧を取得
  ///
  /// [includeHidden] 非表示タスクを含める
  /// [includeExpired] 期限切れタスクを含める
  /// Returns: 成功時はRight(List<Task>)、失敗時はLeft(Failure)
  Future<Either<Failure, List<Task>>> getTasks({
    bool includeHidden = false,
    bool includeExpired = false,
  });

  /// タスクIDで取得
  ///
  /// [id] タスクID
  /// Returns: 成功時はRight(Task)、失敗時はLeft(Failure)
  Future<Either<Failure, Task>> getTaskById(String id);

  /// タスクを作成
  ///
  /// [title] タイトル
  /// [memo] メモ（任意）
  /// [dueAt] 有効期限（任意）
  /// [tags] タグリスト
  /// Returns: 成功時はRight(Task)、失敗時はLeft(Failure)
  Future<Either<Failure, Task>> createTask({
    required String title,
    String? memo,
    DateTime? dueAt,
    List<String> tags = const [],
  });

  /// タスクを更新
  ///
  /// [id] タスクID
  /// [title] タイトル
  /// [memo] メモ
  /// [dueAt] 有効期限
  /// [tags] タグリスト
  /// Returns: 成功時はRight(Task)、失敗時はLeft(Failure)
  Future<Either<Failure, Task>> updateTask({
    required String id,
    String? title,
    String? memo,
    DateTime? dueAt,
    List<String>? tags,
  });

  /// タスクの状態を変更
  ///
  /// [id] タスクID
  /// [state] 新しい状態
  /// Returns: 成功時はRight(Task)、失敗時はLeft(Failure)
  Future<Either<Failure, Task>> updateTaskState({
    required String id,
    required TaskState state,
  });

  /// タスクを完了/未完了に切り替え
  ///
  /// [id] タスクID
  /// [completed] 完了フラグ
  /// Returns: 成功時はRight(Task)、失敗時はLeft(Failure)
  Future<Either<Failure, Task>> toggleTaskCompletion({
    required String id,
    required bool completed,
  });

  /// タスクのピン留めを切り替え
  ///
  /// [id] タスクID
  /// [pinned] ピン留めフラグ
  /// Returns: 成功時はRight(Task)、失敗時はLeft(Failure)
  Future<Either<Failure, Task>> toggleTaskPin({
    required String id,
    required bool pinned,
  });

  /// タスクを削除
  ///
  /// [id] タスクID
  /// Returns: 成功時はRight(void)、失敗時はLeft(Failure)
  Future<Either<Failure, void>> deleteTask(String id);

  /// 期限切れタスクを自動でアーカイブ
  ///
  /// Returns: 成功時はRight(int)（アーカイブした件数）、失敗時はLeft(Failure)
  Future<Either<Failure, int>> archiveExpiredTasks();

  /// ローカルキャッシュをクリア
  ///
  /// Returns: 成功時はRight(void)、失敗時はLeft(Failure)
  Future<Either<Failure, void>> clearCache();

  /// サーバーと同期
  ///
  /// Returns: 成功時はRight(void)、失敗時はLeft(Failure)
  Future<Either<Failure, void>> syncWithServer();
}
