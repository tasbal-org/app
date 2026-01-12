/// Task Data: TaskModel
///
/// タスクのデータモデル
/// JSON ⇔ Entity の変換を担当
library;

import 'package:json_annotation/json_annotation.dart';
import 'package:tasbal/src/enums/task_state.dart';
import 'package:tasbal/src/features/task/domain/entities/task.dart';

part 'task_model.g.dart';

/// タスクモデル
///
/// API/ローカルストレージとのデータ交換用
@JsonSerializable()
class TaskModel {
  /// タスクID
  final String id;

  /// タイトル
  final String title;

  /// メモ
  final String? memo;

  /// タスク状態（数値）
  @JsonKey(name: 'state')
  final int stateValue;

  /// ピン留めフラグ
  @JsonKey(name: 'is_pinned')
  final bool isPinned;

  /// 有効期限
  @JsonKey(name: 'due_at')
  final String? dueAt;

  /// タグリスト
  final List<String> tags;

  /// 作成日時
  @JsonKey(name: 'created_at')
  final String createdAt;

  /// 更新日時
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  /// 完了日時
  @JsonKey(name: 'completed_at')
  final String? completedAt;

  TaskModel({
    required this.id,
    required this.title,
    this.memo,
    required this.stateValue,
    this.isPinned = false,
    this.dueAt,
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
  });

  /// JSONからモデルを生成
  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  /// モデルをJSONに変換
  Map<String, dynamic> toJson() => _$TaskModelToJson(this);

  /// エンティティに変換
  Task toEntity() {
    return Task(
      id: id,
      title: title,
      memo: memo,
      state: TaskState.fromValue(stateValue) ?? TaskState.Active,
      isPinned: isPinned,
      dueAt: dueAt != null ? DateTime.parse(dueAt!) : null,
      tags: tags,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
      completedAt: completedAt != null ? DateTime.parse(completedAt!) : null,
    );
  }

  /// エンティティからモデルを生成
  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      memo: task.memo,
      stateValue: task.state.value,
      isPinned: task.isPinned,
      dueAt: task.dueAt?.toIso8601String(),
      tags: task.tags,
      createdAt: task.createdAt.toIso8601String(),
      updatedAt: task.updatedAt.toIso8601String(),
      completedAt: task.completedAt?.toIso8601String(),
    );
  }
}
