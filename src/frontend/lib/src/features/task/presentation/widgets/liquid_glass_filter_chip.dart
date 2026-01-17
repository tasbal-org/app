/// Widget: LiquidGlassFilterChip
///
/// Liquid Glass効果を使用したフィルターチップ
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

/// Liquid Glass効果のフィルターチップ
class LiquidGlassFilterChip extends StatelessWidget {
  /// ラベル
  final String label;

  /// 選択状態
  final bool isSelected;

  /// ダークモードかどうか
  final bool isDarkMode;

  /// タップ時のコールバック
  final ValueChanged<bool>? onSelected;

  /// アイコン（オプション）
  final IconData? icon;

  const LiquidGlassFilterChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.isDarkMode = false,
    this.onSelected,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onSelected?.call(!isSelected);
      },
      child: LiquidStretch(
        child: LiquidGlass.withOwnLayer(
          settings: LiquidGlassSettings(
            thickness: isDarkMode ? 12 : 18,
            glassColor: isSelected
                ? (isDarkMode
                    ? const Color(0x70007AFF)
                    : const Color(0x80007AFF))
                : (isDarkMode
                    ? const Color(0x60000000)
                    : const Color(0x80FFFFFF)),
            lightIntensity: isDarkMode ? 0.3 : 0.5,
            saturation: isSelected ? 0.9 : 0.8,
            blur: isDarkMode ? 30.0 : 35.0,
          ),
          shape: LiquidRoundedSuperellipse(borderRadius: 16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 16,
                    color: _getContentColor(),
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: _getContentColor(),
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 6),
                  Icon(
                    Icons.check,
                    size: 14,
                    color: _getContentColor(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getContentColor() {
    if (isSelected) {
      return isDarkMode ? const Color(0xFF64B5F6) : const Color(0xFF007AFF);
    }
    return isDarkMode
        ? Colors.white.withValues(alpha: 0.7)
        : Colors.black.withValues(alpha: 0.6);
  }
}
