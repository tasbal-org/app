/// Widget: LiquidGlassNavBarItem
///
/// 個別のナビゲーションアイテム（タップ領域とアイコン/ラベル表示）
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'liquid_glass_nav_item.dart';

/// 個別のナビゲーションアイテム
class LiquidGlassNavBarItem extends StatelessWidget {
  /// アイテムデータ
  final LiquidGlassNavItem item;

  /// 選択状態
  final bool isSelected;

  /// ダークモードかどうか
  final bool isDarkMode;

  /// タップ時のコールバック
  final VoidCallback onTap;

  const LiquidGlassNavBarItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // カラー設定
    final selectedColor = isDarkMode
        ? Colors.white
        : const Color(0xFF007AFF); // iOS Blue

    final unselectedColor = isDarkMode
        ? Colors.white.withValues(alpha: 0.6)
        : Colors.grey.shade500;

    final color = isSelected ? selectedColor : unselectedColor;

    return GestureDetector(
      onTap: () {
        // iOSっぽい触感フィードバック
        HapticFeedback.selectionClick();
        onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? (item.activeIcon ?? item.icon) : item.icon,
              size: 24,
              color: color,
            ),
            const SizedBox(height: 2),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
