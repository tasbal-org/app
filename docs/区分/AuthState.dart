// Auto-generated. Do not edit.
// Japanese: 認証状態
// Generated: 2026-01-10 16:07:00

import 'dart:collection';

/// 認証状態
enum AuthState {
  /// ゲスト
  Guest(1, 'ゲスト', true, 0.0, 10),
  /// 連携済み
  Linked(2, '連携済み', false, 0.0, 20),
  /// 無効
  Disabled(3, '無効', false, 0.0, 30);

  const AuthState(this.value, this.displayName, this.isDefault, this.numericValue, this.displayOrder);

  final int value;
  final String displayName;
  final bool isDefault;
  final double numericValue;
  final int displayOrder;

  static final Map<int, AuthState> _byValue = Map.unmodifiable({
    1: AuthState.Guest,
    2: AuthState.Linked,
    3: AuthState.Disabled,
  });

  static AuthState? fromValue(int value) => _byValue[value];

  static List<AuthState> listSorted() {
    final list = values.toList();
    list.sort((a, b) {
      final o = a.displayOrder.compareTo(b.displayOrder);
      if (o != 0) return o;
      return a.value.compareTo(b.value);
    });
    return List.unmodifiable(list);
  }

  static UnmodifiableListView<AuthState> viewSorted() {
    return UnmodifiableListView(listSorted());
  }
}
