/// Task Data: TaskRepositoryImpl
///
/// TaskRepositoryインターフェースの実装
/// リモートAPIとローカルストレージを統合
library;

import 'package:dartz/dartz.dart' hide Task;
import 'package:tasbal/src/core/error/exceptions.dart';
import 'package:tasbal/src/core/error/failures.dart';
import 'package:tasbal/src/enums/task_state.dart';
import 'package:tasbal/src/features/task/data/data_sources/local/task_local_service.dart';
import 'package:tasbal/src/features/task/data/data_sources/remote/task_api_service.dart';
import 'package:tasbal/src/features/task/data/models/task_model.dart';
import 'package:tasbal/src/features/task/domain/entities/task.dart';
import 'package:tasbal/src/features/task/domain/repositories/task_repository.dart';

/// タスクリポジトリ実装
///
/// APIとローカルストレージを統合してタスク機能を提供
/// オフライン対応とキャッシュ戦略を実装
class TaskRepositoryImpl implements TaskRepository {
  /// リモートAPIサービス
  final TaskApiService apiService;

  /// ローカルストレージサービス
  final TaskLocalService localService;

  TaskRepositoryImpl({
    required this.apiService,
    required this.localService,
  });

  @override
  Future<Either<Failure, List<Task>>> getTasks({
    bool includeHidden = false,
    bool includeExpired = false,
  }) async {
    try {
      // ローカルキャッシュから取得を試みる
      final cachedTasks = await localService.getTasks();

      // TODO: ネットワーク接続確認
      // オンラインの場合はAPIから取得して更新
      try {
        final remoteTasks = await apiService.getTasks();
        await localService.saveTasks(remoteTasks);
        await localService.saveLastSyncTime(DateTime.now());

        // フィルタリングして返す
        final filtered = _filterTasks(
          remoteTasks.map((m) => m.toEntity()).toList(),
          includeHidden: includeHidden,
          includeExpired: includeExpired,
        );

        return Right(filtered);
      } on NetworkException {
        // オフライン時はキャッシュを使用
        final filtered = _filterTasks(
          cachedTasks.map((m) => m.toEntity()).toList(),
          includeHidden: includeHidden,
          includeExpired: includeExpired,
        );

        return Right(filtered);
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } catch (e) {
      return Left(ServerFailure(message: '予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, Task>> getTaskById(String id) async {
    try {
      // ローカルから取得を試みる
      final cachedTask = await localService.getTaskById(id);

      if (cachedTask != null) {
        return Right(cachedTask.toEntity());
      }

      // キャッシュになければ一覧を取得して探す
      final tasksResult = await getTasks();

      return tasksResult.fold(
        (failure) => Left(failure),
        (tasks) {
          final task = tasks.firstWhere(
            (t) => t.id == id,
            orElse: () => throw ServerException(
              message: 'タスクが見つかりません',
              statusCode: 404,
            ),
          );
          return Right(task);
        },
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } catch (e) {
      return Left(ServerFailure(message: '予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, Task>> createTask({
    required String title,
    String? memo,
    DateTime? dueAt,
    List<String> tags = const [],
  }) async {
    try {
      final taskModel = await apiService.createTask(
        title: title,
        memo: memo,
        dueAt: dueAt,
      );

      // ローカルに保存
      await localService.saveTask(taskModel);

      return Right(taskModel.toEntity());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: '予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, Task>> updateTask({
    required String id,
    String? title,
    String? memo,
    DateTime? dueAt,
    List<String>? tags,
  }) async {
    try {
      final taskModel = await apiService.updateTask(
        id: id,
        title: title,
        memo: memo,
        dueAt: dueAt,
      );

      // ローカルに保存
      await localService.saveTask(taskModel);

      return Right(taskModel.toEntity());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: '予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, Task>> updateTaskState({
    required String id,
    required TaskState state,
  }) async {
    try {
      final taskModel = await apiService.updateTask(
        id: id,
        state: state.value,
      );

      // ローカルに保存
      await localService.saveTask(taskModel);

      return Right(taskModel.toEntity());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: '予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, Task>> toggleTaskCompletion({
    required String id,
    required bool completed,
  }) async {
    try {
      final taskModel = await apiService.toggleCompletion(
        id: id,
        completed: completed,
      );

      // ローカルに保存
      await localService.saveTask(taskModel);

      return Right(taskModel.toEntity());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: '予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, Task>> toggleTaskPin({
    required String id,
    required bool pinned,
  }) async {
    try {
      final taskModel = await apiService.updateTask(
        id: id,
        isPinned: pinned,
      );

      // ローカルに保存
      await localService.saveTask(taskModel);

      return Right(taskModel.toEntity());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: '予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String id) async {
    try {
      await apiService.deleteTask(id);

      // ローカルからも削除
      await localService.deleteTask(id);

      return const Right(null);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: '予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> archiveExpiredTasks() async {
    try {
      // ローカルから全タスクを取得
      final tasks = await localService.getTasks();

      int archivedCount = 0;
      final now = DateTime.now();

      for (var taskModel in tasks) {
        final task = taskModel.toEntity();

        // 期限切れかつExpired状態でないものをアーカイブ
        if (task.dueAt != null &&
            now.isAfter(task.dueAt!) &&
            task.state != TaskState.Expired) {
          // APIで状態更新
          await apiService.updateTask(
            id: task.id,
            state: TaskState.Expired.value,
          );

          archivedCount++;
        }
      }

      // キャッシュを更新
      if (archivedCount > 0) {
        final remoteTasks = await apiService.getTasks();
        await localService.saveTasks(remoteTasks);
      }

      return Right(archivedCount);
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } catch (e) {
      return Left(ServerFailure(message: '予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearCache() async {
    try {
      await localService.clearAll();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: '予期しないエラーが発生しました: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> syncWithServer() async {
    try {
      final remoteTasks = await apiService.getTasks();
      await localService.saveTasks(remoteTasks);
      await localService.saveLastSyncTime(DateTime.now());

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } catch (e) {
      return Left(ServerFailure(message: '予期しないエラーが発生しました: $e'));
    }
  }

  /// タスクリストをフィルタリング
  List<Task> _filterTasks(
    List<Task> tasks, {
    required bool includeHidden,
    required bool includeExpired,
  }) {
    return tasks.where((task) {
      if (!includeHidden && task.isHidden) return false;
      if (!includeExpired && task.isExpired) return false;
      return true;
    }).toList();
  }
}
