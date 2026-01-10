// Auto-generated. Do not edit.
// Japanese: ユーザープラン
// Generated: 2026-01-10 16:07:00

import 'dart:collection';

/// ユーザープラン
enum UserPlan {
  /// FREE
  Free(1, 'FREE', true, 0.0, 10),
  /// PRO
  Pro(2, 'PRO', false, 0.0, 20);

  const UserPlan(this.value, this.displayName, this.isDefault, this.numericValue, this.displayOrder);

  final int value;
  final String displayName;
  final bool isDefault;
  final double numericValue;
  final int displayOrder;

  static final Map<int, UserPlan> _byValue = Map.unmodifiable({
    1: UserPlan.Free,
    2: UserPlan.Pro,
  });

  static UserPlan? fromValue(int value) => _byValue[value];

  static List<UserPlan> listSorted() {
    final list = values.toList();
    list.sort((a, b) {
      final o = a.displayOrder.compareTo(b.displayOrder);
      if (o != 0) return o;
      return a.value.compareTo(b.value);
    });
    return List.unmodifiable(list);
  }

  static UnmodifiableListView<UserPlan> viewSorted() {
    return UnmodifiableListView(listSorted());
  }
}
