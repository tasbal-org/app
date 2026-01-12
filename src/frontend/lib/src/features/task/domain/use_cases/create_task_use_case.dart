/// Task Domain: CreateTaskUseCase
///
/// タスク作成ユースケース
library;

import 'package:dartz/dartz.dart' hide Task;
import 'package:tasbal/src/core/error/failures.dart';
import 'package:tasbal/src/features/task/domain/entities/task.dart';
import 'package:tasbal/src/features/task/domain/repositories/task_repository.dart';

/// タスク作成ユースケース
class CreateTaskUseCase {
  final TaskRepository repository;

  CreateTaskUseCase(this.repository);

  /// タスクを作成
  ///
  /// [title] タイトル（必須）
  /// [memo] メモ（任意）
  /// [dueAt] 有効期限（任意）
  /// [tags] タグリスト
  Future<Either<Failure, Task>> call({
    required String title,
    String? memo,
    DateTime? dueAt,
    List<String> tags = const [],
  }) async {
    // バリデーション
    if (title.trim().isEmpty) {
      return const Left(ValidationFailure(
        message: 'タイトルを入力してください',
      ));
    }

    return await repository.createTask(
      title: title.trim(),
      memo: memo?.trim(),
      dueAt: dueAt,
      tags: tags,
    );
  }
}
