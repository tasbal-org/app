/// Task Domain: ToggleTaskCompletionUseCase
///
/// タスク完了切替ユースケース
/// 完了時は風船への加算処理も行う（将来的に）
library;

import 'package:dartz/dartz.dart' hide Task;
import 'package:tasbal/src/core/error/failures.dart';
import 'package:tasbal/src/features/task/domain/entities/task.dart';
import 'package:tasbal/src/features/task/domain/repositories/task_repository.dart';

/// タスク完了切替ユースケース
///
/// タスクの完了/未完了を切り替え
/// 完了時は風船に加算される（将来実装）
class ToggleTaskCompletionUseCase {
  final TaskRepository repository;

  ToggleTaskCompletionUseCase(this.repository);

  /// タスクの完了状態を切り替え
  ///
  /// [id] タスクID
  /// [completed] 完了フラグ
  Future<Either<Failure, Task>> call({
    required String id,
    required bool completed,
  }) async {
    final result = await repository.toggleTaskCompletion(
      id: id,
      completed: completed,
    );

    // TODO: 完了時の風船加算処理
    // if (completed) {
    //   await _addToBalloons();
    // }

    return result;
  }
}
