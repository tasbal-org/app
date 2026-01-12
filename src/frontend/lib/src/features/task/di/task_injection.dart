/// Task DI: Injection
///
/// Task機能の依存性注入設定
/// データソース、リポジトリ、ユースケースを登録
library;

import 'package:get_it/get_it.dart';
import 'package:tasbal/src/features/task/data/data_sources/local/task_local_service.dart';
import 'package:tasbal/src/features/task/data/data_sources/remote/task_api_service.dart';
import 'package:tasbal/src/features/task/data/repositories/task_repository_impl.dart';
import 'package:tasbal/src/features/task/domain/repositories/task_repository.dart';
import 'package:tasbal/src/features/task/domain/use_cases/create_task_use_case.dart';
import 'package:tasbal/src/features/task/domain/use_cases/delete_task_use_case.dart';
import 'package:tasbal/src/features/task/domain/use_cases/get_tasks_use_case.dart';
import 'package:tasbal/src/features/task/domain/use_cases/toggle_task_completion_use_case.dart';
import 'package:tasbal/src/features/task/domain/use_cases/toggle_task_pin_use_case.dart';
import 'package:tasbal/src/features/task/domain/use_cases/update_task_use_case.dart';

/// Task機能の依存性を登録
///
/// アプリ起動時にCore DIから呼び出される
Future<void> addTaskDependencies(GetIt sl) async {
  // ============================================================
  // Data Sources
  // ============================================================

  // Remote
  sl.registerLazySingleton<TaskApiService>(
    () => TaskApiService(sl()),
  );

  // Local
  sl.registerLazySingleton<TaskLocalService>(
    () => TaskLocalService(),
  );

  // ============================================================
  // Repository
  // ============================================================

  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(
      apiService: sl(),
      localService: sl(),
    ),
  );

  // ============================================================
  // Use Cases
  // ============================================================

  sl.registerLazySingleton<GetTasksUseCase>(
    () => GetTasksUseCase(sl()),
  );

  sl.registerLazySingleton<CreateTaskUseCase>(
    () => CreateTaskUseCase(sl()),
  );

  sl.registerLazySingleton<UpdateTaskUseCase>(
    () => UpdateTaskUseCase(sl()),
  );

  sl.registerLazySingleton<ToggleTaskCompletionUseCase>(
    () => ToggleTaskCompletionUseCase(sl()),
  );

  sl.registerLazySingleton<ToggleTaskPinUseCase>(
    () => ToggleTaskPinUseCase(sl()),
  );

  sl.registerLazySingleton<DeleteTaskUseCase>(
    () => DeleteTaskUseCase(sl()),
  );
}
