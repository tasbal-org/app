/// Task Domain: GetTasksUseCase
///
/// タスク一覧取得ユースケース
/// フィルタリング条件に応じてタスクリストを取得
library;

import 'package:dartz/dartz.dart' hide Task;
import 'package:tasbal/src/core/error/failures.dart';
import 'package:tasbal/src/features/task/domain/entities/task.dart';
import 'package:tasbal/src/features/task/domain/repositories/task_repository.dart';

/// タスク一覧取得ユースケース
///
/// 表示トグルに応じてフィルタリングされたタスクリストを返す
class GetTasksUseCase {
  /// タスクリポジトリ
  final TaskRepository repository;

  GetTasksUseCase(this.repository);

  /// タスク一覧を取得
  ///
  /// [includeHidden] 非表示タスクを含める（デフォルト: false）
  /// [includeExpired] 期限切れタスクを含める（デフォルト: false）
  /// Returns: 成功時はRight(List<Task>)、失敗時はLeft(Failure)
  ///          リストはピン留め優先でソートされる
  Future<Either<Failure, List<Task>>> call({
    bool includeHidden = false,
    bool includeExpired = false,
  }) async {
    final result = await repository.getTasks(
      includeHidden: includeHidden,
      includeExpired: includeExpired,
    );

    return result.fold(
      (failure) => Left(failure),
      (tasks) {
        // ソート: ピン留め > 作成日時の新しい順
        final sortedTasks = List<Task>.from(tasks);
        sortedTasks.sort((a, b) {
          // ピン留め優先
          if (a.isPinned && !b.isPinned) return -1;
          if (!a.isPinned && b.isPinned) return 1;

          // 完了状態は下に
          if (!a.isCompleted && b.isCompleted) return -1;
          if (a.isCompleted && !b.isCompleted) return 1;

          // 期限が近い順（期限あり優先）
          if (a.hasDueDate && !b.hasDueDate) return -1;
          if (!a.hasDueDate && b.hasDueDate) return 1;
          if (a.hasDueDate && b.hasDueDate) {
            return a.dueAt!.compareTo(b.dueAt!);
          }

          // 作成日時の新しい順
          return b.createdAt.compareTo(a.createdAt);
        });

        return Right(sortedTasks);
      },
    );
  }
}
