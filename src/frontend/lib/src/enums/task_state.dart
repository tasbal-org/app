// タスク状態
// 設計書の仕様に基づく
// 状態: 通常 / 完了 / 非表示 / 期限切れ（アーカイブ）

import 'dart:collection';

/// タスク状態
enum TaskState {
  /// 通常（アクティブ）
  Active(1, '通常', true, 0.0, 10),

  /// 完了
  Completed(2, '完了', false, 0.0, 20),

  /// 非表示
  Hidden(3, '非表示', false, 0.0, 30),

  /// 期限切れ（アーカイブ）
  Expired(4, '期限切れ', false, 0.0, 40);

  const TaskState(
    this.value,
    this.displayName,
    this.isDefault,
    this.numericValue,
    this.displayOrder,
  );

  final int value;
  final String displayName;
  final bool isDefault;
  final double numericValue;
  final int displayOrder;

  static final Map<int, TaskState> _byValue = Map.unmodifiable({
    1: TaskState.Active,
    2: TaskState.Completed,
    3: TaskState.Hidden,
    4: TaskState.Expired,
  });

  static TaskState? fromValue(int value) => _byValue[value];

  static List<TaskState> listSorted() {
    final list = values.toList();
    list.sort((a, b) {
      final o = a.displayOrder.compareTo(b.displayOrder);
      if (o != 0) return o;
      return a.value.compareTo(b.value);
    });
    return List.unmodifiable(list);
  }

  static UnmodifiableListView<TaskState> viewSorted() {
    return UnmodifiableListView(listSorted());
  }
}
