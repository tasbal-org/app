/// Model: TaskInput
///
/// タスク入力データモデル
library;

/// タスク入力データ
class TaskInput {
  /// タスク名（必須）
  final String title;

  /// メモ（任意）
  final String? memo;

  /// 期限日時（任意）
  final DateTime? dueAt;

  /// タグリスト（任意）
  final List<String> tags;

  const TaskInput({
    required this.title,
    this.memo,
    this.dueAt,
    this.tags = const [],
  });
}
