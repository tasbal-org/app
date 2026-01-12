/// Task Domain: DeleteTaskUseCase
///
/// タスク削除ユースケース
library;

import 'package:dartz/dartz.dart';
import 'package:tasbal/src/core/error/failures.dart';
import 'package:tasbal/src/features/task/domain/repositories/task_repository.dart';

/// タスク削除ユースケース
class DeleteTaskUseCase {
  final TaskRepository repository;

  DeleteTaskUseCase(this.repository);

  /// タスクを削除
  ///
  /// [id] タスクID
  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteTask(id);
  }
}
