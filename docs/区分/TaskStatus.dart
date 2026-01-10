// Auto-generated. Do not edit.
// Japanese: タスク状態
// Generated: 2026-01-10 16:07:00

import 'dart:collection';

/// タスク状態
enum TaskStatus {
  /// 未着手
  Todo(1, '未着手', true, 0.0, 10),
  /// 進行中
  InProgress(2, '進行中', false, 0.0, 20),
  /// 完了
  Done(3, '完了', false, 0.0, 30),
  /// アーカイブ
  Archived(4, 'アーカイブ', false, 0.0, 40);

  const TaskStatus(this.value, this.displayName, this.isDefault, this.numericValue, this.displayOrder);

  final int value;
  final String displayName;
  final bool isDefault;
  final double numericValue;
  final int displayOrder;

  static final Map<int, TaskStatus> _byValue = Map.unmodifiable({
    1: TaskStatus.Todo,
    2: TaskStatus.InProgress,
    3: TaskStatus.Done,
    4: TaskStatus.Archived,
  });

  static TaskStatus? fromValue(int value) => _byValue[value];

  static List<TaskStatus> listSorted() {
    final list = values.toList();
    list.sort((a, b) {
      final o = a.displayOrder.compareTo(b.displayOrder);
      if (o != 0) return o;
      return a.value.compareTo(b.value);
    });
    return List.unmodifiable(list);
  }

  static UnmodifiableListView<TaskStatus> viewSorted() {
    return UnmodifiableListView(listSorted());
  }
}
