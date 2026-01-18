/// Widget: LiquidGlassPrimaryButton
///
/// Liquid Glassスタイルのプライマリボタン
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// プライマリボタンウィジェット
class LiquidGlassPrimaryButton extends StatelessWidget {
  /// ボタンのラベル
  final String label;

  /// ダークモードかどうか
  final bool isDarkMode;

  /// タップ時のコールバック
  final VoidCallback? onTap;

  /// 有効かどうか
  final bool enabled;

  /// ボタンの色
  final Color? color;

  /// 垂直パディング
  final double verticalPadding;

  /// ボーダーの半径
  final double borderRadius;

  const LiquidGlassPrimaryButton({
    super.key,
    required this.label,
    required this.isDarkMode,
    this.onTap,
    this.enabled = true,
    this.color,
    this.verticalPadding = 14,
    this.borderRadius = 14,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? const Color(0xFF007AFF);

    return GestureDetector(
      onTap: enabled ? _handleTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        decoration: BoxDecoration(
          color: enabled
              ? buttonColor
              : (isDarkMode
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.08)),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: enabled
                  ? Colors.white
                  : (isDarkMode
                      ? Colors.white.withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: 0.3)),
            ),
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
