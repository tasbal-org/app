/// Task Domain: ToggleTaskPinUseCase
///
/// タスクピン留め切替ユースケース
library;

import 'package:dartz/dartz.dart' hide Task;
import 'package:tasbal/src/core/error/failures.dart';
import 'package:tasbal/src/features/task/domain/entities/task.dart';
import 'package:tasbal/src/features/task/domain/repositories/task_repository.dart';

/// タスクピン留め切替ユースケース
class ToggleTaskPinUseCase {
  final TaskRepository repository;

  ToggleTaskPinUseCase(this.repository);

  /// タスクのピン留め状態を切り替え
  ///
  /// [id] タスクID
  /// [pinned] ピン留めフラグ
  Future<Either<Failure, Task>> call({
    required String id,
    required bool pinned,
  }) async {
    return await repository.toggleTaskPin(
      id: id,
      pinned: pinned,
    );
  }
}
