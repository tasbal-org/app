// Auto-generated. Do not edit.
// Japanese: 表示グループ
// Generated: 2026-01-10 16:07:00

import 'dart:collection';

/// 表示グループ
enum BalloonDisplayGroup {
  /// ピン留め
  Pinned(1, 'ピン留め', true, 0.0, 10),
  /// 漂う
  Drifting(2, '漂う', false, 0.0, 20);

  const BalloonDisplayGroup(this.value, this.displayName, this.isDefault, this.numericValue, this.displayOrder);

  final int value;
  final String displayName;
  final bool isDefault;
  final double numericValue;
  final int displayOrder;

  static final Map<int, BalloonDisplayGroup> _byValue = Map.unmodifiable({
    1: BalloonDisplayGroup.Pinned,
    2: BalloonDisplayGroup.Drifting,
  });

  static BalloonDisplayGroup? fromValue(int value) => _byValue[value];

  static List<BalloonDisplayGroup> listSorted() {
    final list = values.toList();
    list.sort((a, b) {
      final o = a.displayOrder.compareTo(b.displayOrder);
      if (o != 0) return o;
      return a.value.compareTo(b.value);
    });
    return List.unmodifiable(list);
  }

  static UnmodifiableListView<BalloonDisplayGroup> viewSorted() {
    return UnmodifiableListView(listSorted());
  }
}
