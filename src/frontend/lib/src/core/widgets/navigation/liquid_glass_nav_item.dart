/// Model: LiquidGlassNavItem
///
/// ナビゲーションアイテムのデータモデル
library;

import 'package:flutter/material.dart';

/// ナビゲーションアイテムのデータモデル
class LiquidGlassNavItem {
  /// アイコン
  final IconData icon;

  /// 選択時のアイコン（オプション）
  final IconData? activeIcon;

  /// ラベル
  final String label;

  const LiquidGlassNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
  });
}
