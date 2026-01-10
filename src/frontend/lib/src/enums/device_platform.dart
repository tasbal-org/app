// Auto-generated. Do not edit.
// Japanese: 端末種別
// Generated: 2026-01-10 16:07:00

import 'dart:collection';

/// 端末種別
enum DevicePlatform {
  /// iOS
  IOS(1, 'iOS', true, 0.0, 10),
  /// Android
  Android(2, 'Android', false, 0.0, 20),
  /// Web
  Web(3, 'Web', false, 0.0, 30);

  const DevicePlatform(this.value, this.displayName, this.isDefault, this.numericValue, this.displayOrder);

  final int value;
  final String displayName;
  final bool isDefault;
  final double numericValue;
  final int displayOrder;

  static final Map<int, DevicePlatform> _byValue = Map.unmodifiable({
    1: DevicePlatform.IOS,
    2: DevicePlatform.Android,
    3: DevicePlatform.Web,
  });

  static DevicePlatform? fromValue(int value) => _byValue[value];

  static List<DevicePlatform> listSorted() {
    final list = values.toList();
    list.sort((a, b) {
      final o = a.displayOrder.compareTo(b.displayOrder);
      if (o != 0) return o;
      return a.value.compareTo(b.value);
    });
    return List.unmodifiable(list);
  }

  static UnmodifiableListView<DevicePlatform> viewSorted() {
    return UnmodifiableListView(listSorted());
  }
}
