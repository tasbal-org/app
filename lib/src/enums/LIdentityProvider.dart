// Auto-generated. Do not edit.
// Japanese: 認証プロバイダ
// Generated: 2026-01-10 16:07:00

import 'dart:collection';

/// 認証プロバイダ
enum IdentityProvider {
  /// APPLE
  Apple(1, 'APPLE', true, 0.0, 10),
  /// GOOGLE
  Google(2, 'GOOGLE', false, 0.0, 20),
  /// ANON
  Anon(3, 'ANON', false, 0.0, 30);

  const IdentityProvider(this.value, this.displayName, this.isDefault, this.numericValue, this.displayOrder);

  final int value;
  final String displayName;
  final bool isDefault;
  final double numericValue;
  final int displayOrder;

  static final Map<int, IdentityProvider> _byValue = Map.unmodifiable({
    1: IdentityProvider.Apple,
    2: IdentityProvider.Google,
    3: IdentityProvider.Anon,
  });

  static IdentityProvider? fromValue(int value) => _byValue[value];

  static List<IdentityProvider> listSorted() {
    final list = values.toList();
    list.sort((a, b) {
      final o = a.displayOrder.compareTo(b.displayOrder);
      if (o != 0) return o;
      return a.value.compareTo(b.value);
    });
    return List.unmodifiable(list);
  }

  static UnmodifiableListView<IdentityProvider> viewSorted() {
    return UnmodifiableListView(listSorted());
  }
}
