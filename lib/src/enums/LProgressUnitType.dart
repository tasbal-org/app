// Auto-generated. Do not edit.
// Japanese: 進捗集計単位
// Generated: 2026-01-10 16:07:00

import 'dart:collection';

/// 進捗集計単位
enum ProgressUnitType {
  /// ユーザー
  User(1, 'ユーザー', true, 0.0, 10),
  /// 国
  Country(2, '国', false, 0.0, 20),
  /// 全体
  Global(3, '全体', false, 0.0, 30),
  /// UTC日
  UtcDay(4, 'UTC日', false, 0.0, 40),
  /// イベント
  Event(5, 'イベント', false, 0.0, 50);

  const ProgressUnitType(this.value, this.displayName, this.isDefault, this.numericValue, this.displayOrder);

  final int value;
  final String displayName;
  final bool isDefault;
  final double numericValue;
  final int displayOrder;

  static final Map<int, ProgressUnitType> _byValue = Map.unmodifiable({
    1: ProgressUnitType.User,
    2: ProgressUnitType.Country,
    3: ProgressUnitType.Global,
    4: ProgressUnitType.UtcDay,
    5: ProgressUnitType.Event,
  });

  static ProgressUnitType? fromValue(int value) => _byValue[value];

  static List<ProgressUnitType> listSorted() {
    final list = values.toList();
    list.sort((a, b) {
      final o = a.displayOrder.compareTo(b.displayOrder);
      if (o != 0) return o;
      return a.value.compareTo(b.value);
    });
    return List.unmodifiable(list);
  }

  static UnmodifiableListView<ProgressUnitType> viewSorted() {
    return UnmodifiableListView(listSorted());
  }
}
