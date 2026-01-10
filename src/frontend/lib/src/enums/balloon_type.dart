// Auto-generated. Do not edit.
// Japanese: 風船タイプ
// Generated: 2026-01-10 16:07:00

import 'dart:collection';

/// 風船タイプ
enum BalloonType {
  /// グローバル風船
  Global(1, 'グローバル風船', true, 0.0, 10),
  /// ロケーション風船
  Location(2, 'ロケーション風船', false, 0.0, 20),
  /// 深呼吸風船
  Breath(3, '深呼吸風船', false, 0.0, 30),
  /// ユーザー作成風船
  User(4, 'ユーザー作成風船', false, 0.0, 40),
  /// ゲリラ風船
  Guerrilla(5, 'ゲリラ風船', false, 0.0, 50);

  const BalloonType(this.value, this.displayName, this.isDefault, this.numericValue, this.displayOrder);

  final int value;
  final String displayName;
  final bool isDefault;
  final double numericValue;
  final int displayOrder;

  static final Map<int, BalloonType> _byValue = Map.unmodifiable({
    1: BalloonType.Global,
    2: BalloonType.Location,
    3: BalloonType.Breath,
    4: BalloonType.User,
    5: BalloonType.Guerrilla,
  });

  static BalloonType? fromValue(int value) => _byValue[value];

  static List<BalloonType> listSorted() {
    final list = values.toList();
    list.sort((a, b) {
      final o = a.displayOrder.compareTo(b.displayOrder);
      if (o != 0) return o;
      return a.value.compareTo(b.value);
    });
    return List.unmodifiable(list);
  }

  static UnmodifiableListView<BalloonType> viewSorted() {
    return UnmodifiableListView(listSorted());
  }
}
