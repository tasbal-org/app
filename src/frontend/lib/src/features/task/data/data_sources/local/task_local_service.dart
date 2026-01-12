/// Task Data: TaskLocalService
///
/// タスクのローカルストレージサービス
/// Hiveを使用してタスクデータを永続化
library;

import 'package:hive_flutter/hive_flutter.dart';
import 'package:tasbal/src/core/error/exceptions.dart';
import 'package:tasbal/src/features/task/data/models/task_model.dart';

/// タスクローカルサービス
///
/// タスクデータをHiveで管理
class TaskLocalService {
  /// Hiveボックス名
  static const String _boxName = 'tasks_box';

  /// タスク一覧をキャッシュから取得
  Future<List<TaskModel>> getTasks() async {
    try {
      final box = await Hive.openBox<Map>(_boxName);
      final tasks = <TaskModel>[];

      for (var key in box.keys) {
        final taskJson = Map<String, dynamic>.from(box.get(key) as Map);
        tasks.add(TaskModel.fromJson(taskJson));
      }

      return tasks;
    } catch (e) {
      throw CacheException(
        message: 'ローカルからのタスク取得に失敗しました: $e',
      );
    }
  }

  /// タスクをキャッシュに保存
  Future<void> saveTask(TaskModel task) async {
    try {
      final box = await Hive.openBox<Map>(_boxName);
      await box.put(task.id, task.toJson());
    } catch (e) {
      throw CacheException(
        message: 'タスクの保存に失敗しました: $e',
      );
    }
  }

  /// 複数のタスクをキャッシュに保存
  Future<void> saveTasks(List<TaskModel> tasks) async {
    try {
      final box = await Hive.openBox<Map>(_boxName);

      // 既存のキャッシュをクリア
      await box.clear();

      // 新しいタスクを保存
      for (var task in tasks) {
        await box.put(task.id, task.toJson());
      }
    } catch (e) {
      throw CacheException(
        message: 'タスクリストの保存に失敗しました: $e',
      );
    }
  }

  /// タスクIDで取得
  Future<TaskModel?> getTaskById(String id) async {
    try {
      final box = await Hive.openBox<Map>(_boxName);
      final taskJson = box.get(id);

      if (taskJson == null) return null;

      return TaskModel.fromJson(Map<String, dynamic>.from(taskJson as Map));
    } catch (e) {
      throw CacheException(
        message: 'タスクの取得に失敗しました: $e',
      );
    }
  }

  /// タスクを削除
  Future<void> deleteTask(String id) async {
    try {
      final box = await Hive.openBox<Map>(_boxName);
      await box.delete(id);
    } catch (e) {
      throw CacheException(
        message: 'タスクの削除に失敗しました: $e',
      );
    }
  }

  /// すべてのタスクを削除
  Future<void> clearAll() async {
    try {
      final box = await Hive.openBox<Map>(_boxName);
      await box.clear();
    } catch (e) {
      throw CacheException(
        message: 'タスクキャッシュのクリアに失敗しました: $e',
      );
    }
  }

  /// 最終同期日時を保存
  Future<void> saveLastSyncTime(DateTime time) async {
    try {
      final box = await Hive.openBox(_boxName);
      await box.put('_last_sync_time', time.toIso8601String());
    } catch (e) {
      throw CacheException(
        message: '同期日時の保存に失敗しました: $e',
      );
    }
  }

  /// 最終同期日時を取得
  Future<DateTime?> getLastSyncTime() async {
    try {
      final box = await Hive.openBox(_boxName);
      final timeStr = box.get('_last_sync_time') as String?;

      if (timeStr == null) return null;

      return DateTime.parse(timeStr);
    } catch (e) {
      throw CacheException(
        message: '同期日時の取得に失敗しました: $e',
      );
    }
  }
}
