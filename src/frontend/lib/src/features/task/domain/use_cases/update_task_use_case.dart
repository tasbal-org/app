/// Task Domain: UpdateTaskUseCase
///
/// タスク更新ユースケース
library;

import 'package:dartz/dartz.dart' hide Task;
import 'package:tasbal/src/core/error/failures.dart';
import 'package:tasbal/src/features/task/domain/entities/task.dart';
import 'package:tasbal/src/features/task/domain/repositories/task_repository.dart';

/// タスク更新ユースケース
class UpdateTaskUseCase {
  final TaskRepository repository;

  UpdateTaskUseCase(this.repository);

  /// タスクを更新
  ///
  /// [id] タスクID
  /// [title] タイトル
  /// [memo] メモ
  /// [dueAt] 有効期限
  /// [tags] タグリスト
  Future<Either<Failure, Task>> call({
    required String id,
    String? title,
    String? memo,
    DateTime? dueAt,
    List<String>? tags,
  }) async {
    // タイトルのバリデーション
    if (title != null && title.trim().isEmpty) {
      return const Left(ValidationFailure(
        message: 'タイトルを入力してください',
      ));
    }

    return await repository.updateTask(
      id: id,
      title: title?.trim(),
      memo: memo?.trim(),
      dueAt: dueAt,
      tags: tags,
    );
  }
}
