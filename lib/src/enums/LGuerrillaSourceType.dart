// Auto-generated. Do not edit.
// Japanese: イベント生成元
// Generated: 2026-01-10 16:07:00

import 'dart:collection';

/// イベント生成元
enum GuerrillaSourceType {
  /// 自動
  Auto(1, '自動', true, 0.0, 10),
  /// 管理者
  Admin(2, '管理者', false, 0.0, 20);

  const GuerrillaSourceType(this.value, this.displayName, this.isDefault, this.numericValue, this.displayOrder);

  final int value;
  final String displayName;
  final bool isDefault;
  final double numericValue;
  final int displayOrder;

  static final Map<int, GuerrillaSourceType> _byValue = Map.unmodifiable({
    1: GuerrillaSourceType.Auto,
    2: GuerrillaSourceType.Admin,
  });

  static GuerrillaSourceType? fromValue(int value) => _byValue[value];

  static List<GuerrillaSourceType> listSorted() {
    final list = values.toList();
    list.sort((a, b) {
      final o = a.displayOrder.compareTo(b.displayOrder);
      if (o != 0) return o;
      return a.value.compareTo(b.value);
    });
    return List.unmodifiable(list);
  }

  static UnmodifiableListView<GuerrillaSourceType> viewSorted() {
    return UnmodifiableListView(listSorted());
  }
}
