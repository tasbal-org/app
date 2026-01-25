/// Widget: LiquidGlassIconButton
///
/// Liquid Glassスタイルの丸いアイコンボタン
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 丸いアイコンボタンウィジェット
class LiquidGlassIconButton extends StatelessWidget {
  /// アイコン
  final IconData icon;

  /// ダークモードかどうか
  final bool isDarkMode;

  /// タップ時のコールバック
  final VoidCallback? onTap;

  /// 有効かどうか
  final bool enabled;

  /// ボタンの色
  final Color? color;

  /// アイコンの色
  final Color? iconColor;

  /// ボタンのサイズ
  final double size;

  /// アイコンのサイズ
  final double iconSize;

  const LiquidGlassIconButton({
    super.key,
    required this.icon,
    required this.isDarkMode,
    this.onTap,
    this.enabled = true,
    this.color,
    this.iconColor,
    this.size = 48,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? const Color(0xFF007AFF);

    return GestureDetector(
      onTap: enabled ? _handleTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: enabled
              ? buttonColor
              : (isDarkMode
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.08)),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            icon,
            size: iconSize,
            color: enabled
                ? (iconColor ?? Colors.white)
                : (isDarkMode
                    ? Colors.white.withValues(alpha: 0.3)
                    : Colors.black.withValues(alpha: 0.3)),
          ),
        ),
      ),
    );
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    onTap?.call();
  }
}
