/// Task Domain: Task Entity
///
/// タスクエンティティ
/// タスクのビジネスロジックを表現
library;

import 'package:equatable/equatable.dart';
import 'package:tasbal/src/enums/task_state.dart';

/// タスクエンティティ
///
/// タスクのドメインモデル
/// 状態（通常/完了/非表示/期限切れ）を管理
class Task extends Equatable {
  /// タスクID
  final String id;

  /// タイトル（必須）
  final String title;

  /// メモ（任意）
  final String? memo;

  /// タスク状態
  final TaskState state;

  /// ピン留めフラグ
  final bool isPinned;

  /// 有効期限（任意）
  final DateTime? dueAt;

  /// タグリスト（任意・複数）
  final List<String> tags;

  /// 作成日時
  final DateTime createdAt;

  /// 更新日時
  final DateTime updatedAt;

  /// 完了日時（完了状態の場合のみ）
  final DateTime? completedAt;

  const Task({
    required this.id,
    required this.title,
    this.memo,
    required this.state,
    this.isPinned = false,
    this.dueAt,
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
  });

  /// 完了済みかどうか
  bool get isCompleted => state == TaskState.Completed;

  /// 非表示かどうか
  bool get isHidden => state == TaskState.Hidden;

  /// 期限切れかどうか（アーカイブ）
  bool get isExpired => state == TaskState.Expired;

  /// 通常状態かどうか
  bool get isActive => state == TaskState.Active;

  /// 期限が設定されているかどうか
  bool get hasDueDate => dueAt != null;

  /// 期限が近いかどうか（24時間以内）
  bool get isDueSoon {
    if (dueAt == null) return false;
    final now = DateTime.now();
    final diff = dueAt!.difference(now);
    return diff.inHours <= 24 && diff.inHours > 0;
  }

  /// 期限超過かどうか（まだExpired状態になっていないが期限は過ぎている）
  bool get isOverdue {
    if (dueAt == null || isExpired) return false;
    return DateTime.now().isAfter(dueAt!);
  }

  @override
  List<Object?> get props => [
        id,
        title,
        memo,
        state,
        isPinned,
        dueAt,
        tags,
        createdAt,
        updatedAt,
        completedAt,
      ];

  /// コピーwith
  Task copyWith({
    String? id,
    String? title,
    String? memo,
    TaskState? state,
    bool? isPinned,
    DateTime? dueAt,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
    bool clearMemo = false,
    bool clearDueAt = false,
    bool clearCompletedAt = false,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      memo: clearMemo ? null : (memo ?? this.memo),
      state: state ?? this.state,
      isPinned: isPinned ?? this.isPinned,
      dueAt: clearDueAt ? null : (dueAt ?? this.dueAt),
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: clearCompletedAt ? null : (completedAt ?? this.completedAt),
    );
  }
}
