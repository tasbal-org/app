/// Task Data: TaskApiService
///
/// タスクのリモートAPIサービス
/// APIエンドポイントとの通信を担当
library;

import 'package:dio/dio.dart';
import 'package:tasbal/src/core/constants/api_constants.dart';
import 'package:tasbal/src/core/error/exceptions.dart';
import 'package:tasbal/src/features/task/data/models/task_model.dart';

/// タスクAPIサービス
///
/// タスク関連のAPI呼び出しを担当
class TaskApiService {
  final Dio dio;

  TaskApiService(this.dio);

  /// タスク一覧を取得
  ///
  /// [limit] 取得件数
  /// [cursor] ページネーションカーソル
  Future<List<TaskModel>> getTasks({
    int limit = 100,
    String? cursor,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.tasksEndpoint,
        queryParameters: {
          'limit': limit,
          if (cursor != null) 'cursor': cursor,
        },
      );

      final items = response.data['items'] as List;
      return items.map((json) => TaskModel.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException(
          message: e.response?.data['error']?['message'] ?? '認証エラー',
        );
      }
      throw ServerException(
        message: e.response?.data['error']?['message'] ?? 'サーバーエラー',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: '予期しないエラーが発生しました: $e');
    }
  }

  /// タスクを作成
  ///
  /// [title] タイトル
  /// [memo] メモ
  /// [dueAt] 有効期限
  Future<TaskModel> createTask({
    required String title,
    String? memo,
    DateTime? dueAt,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.tasksEndpoint,
        data: {
          'title': title,
          if (memo != null) 'memo': memo,
          if (dueAt != null) 'due_at': dueAt.toIso8601String(),
        },
      );

      return TaskModel.fromJson(response.data['task']);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException(
          message: e.response?.data['error']?['message'] ?? '認証エラー',
        );
      }
      throw ServerException(
        message: e.response?.data['error']?['message'] ?? 'サーバーエラー',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: '予期しないエラーが発生しました: $e');
    }
  }

  /// タスクを更新
  ///
  /// [id] タスクID
  /// [title] タイトル
  /// [memo] メモ
  /// [dueAt] 有効期限
  /// [state] 状態
  /// [isPinned] ピン留め
  Future<TaskModel> updateTask({
    required String id,
    String? title,
    String? memo,
    DateTime? dueAt,
    int? state,
    bool? isPinned,
  }) async {
    try {
      final response = await dio.put(
        '${ApiConstants.tasksEndpoint}/$id',
        data: {
          if (title != null) 'title': title,
          if (memo != null) 'memo': memo,
          if (dueAt != null) 'due_at': dueAt.toIso8601String(),
          if (state != null) 'state': state,
          if (isPinned != null) 'is_pinned': isPinned,
        },
      );

      return TaskModel.fromJson(response.data['task']);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException(
          message: e.response?.data['error']?['message'] ?? '認証エラー',
        );
      }
      if (e.response?.statusCode == 404) {
        throw ServerException(
          message: 'タスクが見つかりません',
          statusCode: 404,
        );
      }
      throw ServerException(
        message: e.response?.data['error']?['message'] ?? 'サーバーエラー',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: '予期しないエラーが発生しました: $e');
    }
  }

  /// タスクを完了/未完了に切り替え
  ///
  /// [id] タスクID
  /// [completed] 完了フラグ
  Future<TaskModel> toggleCompletion({
    required String id,
    required bool completed,
  }) async {
    try {
      final response = await dio.post(
        '${ApiConstants.tasksEndpoint}/$id/${completed ? 'complete' : 'uncomplete'}',
      );

      return TaskModel.fromJson(response.data['task']);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException(
          message: e.response?.data['error']?['message'] ?? '認証エラー',
        );
      }
      if (e.response?.statusCode == 404) {
        throw ServerException(
          message: 'タスクが見つかりません',
          statusCode: 404,
        );
      }
      throw ServerException(
        message: e.response?.data['error']?['message'] ?? 'サーバーエラー',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: '予期しないエラーが発生しました: $e');
    }
  }

  /// タスクを削除
  ///
  /// [id] タスクID
  Future<void> deleteTask(String id) async {
    try {
      await dio.delete('${ApiConstants.tasksEndpoint}/$id');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException(
          message: e.response?.data['error']?['message'] ?? '認証エラー',
        );
      }
      if (e.response?.statusCode == 404) {
        throw ServerException(
          message: 'タスクが見つかりません',
          statusCode: 404,
        );
      }
      throw ServerException(
        message: e.response?.data['error']?['message'] ?? 'サーバーエラー',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: '予期しないエラーが発生しました: $e');
    }
  }
}
