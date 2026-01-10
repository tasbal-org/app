// Auto-generated. Do not edit.
// Japanese: 描画品質
// Generated: 2026-01-10 16:07:00

import 'dart:collection';

/// 描画品質
enum RenderQuality {
  /// 自動
  Auto(1, '自動', true, 0.0, 10),
  /// 通常
  Normal(2, '通常', false, 0.0, 20),
  /// 低品質
  Low(3, '低品質', false, 0.0, 30);

  const RenderQuality(this.value, this.displayName, this.isDefault, this.numericValue, this.displayOrder);

  final int value;
  final String displayName;
  final bool isDefault;
  final double numericValue;
  final int displayOrder;

  static final Map<int, RenderQuality> _byValue = Map.unmodifiable({
    1: RenderQuality.Auto,
    2: RenderQuality.Normal,
    3: RenderQuality.Low,
  });

  static RenderQuality? fromValue(int value) => _byValue[value];

  static List<RenderQuality> listSorted() {
    final list = values.toList();
    list.sort((a, b) {
      final o = a.displayOrder.compareTo(b.displayOrder);
      if (o != 0) return o;
      return a.value.compareTo(b.value);
    });
    return List.unmodifiable(list);
  }

  static UnmodifiableListView<RenderQuality> viewSorted() {
    return UnmodifiableListView(listSorted());
  }
}
