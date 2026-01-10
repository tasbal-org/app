// Auto-generated. Do not edit.
// Japanese: 公開区分
// Generated: 2026-01-10 16:07:00

import 'dart:collection';

/// 公開区分
enum BalloonVisibility {
  /// システム
  System(1, 'システム', true, 0.0, 10),
  /// 非公開
  Private(2, '非公開', false, 0.0, 20),
  /// 公開
  Public(3, '公開', false, 0.0, 30);

  const BalloonVisibility(this.value, this.displayName, this.isDefault, this.numericValue, this.displayOrder);

  final int value;
  final String displayName;
  final bool isDefault;
  final double numericValue;
  final int displayOrder;

  static final Map<int, BalloonVisibility> _byValue = Map.unmodifiable({
    1: BalloonVisibility.System,
    2: BalloonVisibility.Private,
    3: BalloonVisibility.Public,
  });

  static BalloonVisibility? fromValue(int value) => _byValue[value];

  static List<BalloonVisibility> listSorted() {
    final list = values.toList();
    list.sort((a, b) {
      final o = a.displayOrder.compareTo(b.displayOrder);
      if (o != 0) return o;
      return a.value.compareTo(b.value);
    });
    return List.unmodifiable(list);
  }

  static UnmodifiableListView<BalloonVisibility> viewSorted() {
    return UnmodifiableListView(listSorted());
  }
}
