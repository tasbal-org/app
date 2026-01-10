// Auto-generated. Do not edit.
// Japanese: 加算元種別
// Generated: 2026-01-10 16:07:00

import 'dart:collection';

/// 加算元種別
enum ContributionSourceType {
  /// タスク
  Task(1, 'タスク', true, 0.0, 10),
  /// 深呼吸
  Breath(2, '深呼吸', false, 0.0, 20),
  /// システム
  System(3, 'システム', false, 0.0, 30),
  /// 管理者
  Admin(4, '管理者', false, 0.0, 40);

  const ContributionSourceType(this.value, this.displayName, this.isDefault, this.numericValue, this.displayOrder);

  final int value;
  final String displayName;
  final bool isDefault;
  final double numericValue;
  final int displayOrder;

  static final Map<int, ContributionSourceType> _byValue = Map.unmodifiable({
    1: ContributionSourceType.Task,
    2: ContributionSourceType.Breath,
    3: ContributionSourceType.System,
    4: ContributionSourceType.Admin,
  });

  static ContributionSourceType? fromValue(int value) => _byValue[value];

  static List<ContributionSourceType> listSorted() {
    final list = values.toList();
    list.sort((a, b) {
      final o = a.displayOrder.compareTo(b.displayOrder);
      if (o != 0) return o;
      return a.value.compareTo(b.value);
    });
    return List.unmodifiable(list);
  }

  static UnmodifiableListView<ContributionSourceType> viewSorted() {
    return UnmodifiableListView(listSorted());
  }
}
