// Auto-generated. Do not edit.
// Japanese: 割れ要因
// Generated: 2026-01-10 16:07:00

import 'dart:collection';

/// 割れ要因
enum PopContextType {
  /// タスク
  Task(1, 'タスク', true, 0.0, 10),
  /// 深呼吸
  Breath(2, '深呼吸', false, 0.0, 20),
  /// その他
  Other(3, 'その他', false, 0.0, 30);

  const PopContextType(this.value, this.displayName, this.isDefault, this.numericValue, this.displayOrder);

  final int value;
  final String displayName;
  final bool isDefault;
  final double numericValue;
  final int displayOrder;

  static final Map<int, PopContextType> _byValue = Map.unmodifiable({
    1: PopContextType.Task,
    2: PopContextType.Breath,
    3: PopContextType.Other,
  });

  static PopContextType? fromValue(int value) => _byValue[value];

  static List<PopContextType> listSorted() {
    final list = values.toList();
    list.sort((a, b) {
      final o = a.displayOrder.compareTo(b.displayOrder);
      if (o != 0) return o;
      return a.value.compareTo(b.value);
    });
    return List.unmodifiable(list);
  }

  static UnmodifiableListView<PopContextType> viewSorted() {
    return UnmodifiableListView(listSorted());
  }
}
