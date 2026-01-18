/// Widget: LiquidGlassSecondaryButton
///
/// Liquid Glassスタイルのセカンダリボタン
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// セカンダリボタンウィジェット
class LiquidGlassSecondaryButton extends StatelessWidget {
  /// ボタンのラベル
  final String label;

  /// ダークモードかどうか
  final bool isDarkMode;

  /// タップ時のコールバック
  final VoidCallback? onTap;

  /// 垂直パディング
  final double verticalPadding;

  /// ボーダーの半径
  final double borderRadius;

  const LiquidGlassSecondaryButton({
    super.key,
    required this.label,
    required this.isDarkMode,
    this.onTap,
    this.verticalPadding = 14,
    this.borderRadius = 14,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        decoration: BoxDecoration(
          color: isDarkMode
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDarkMode
                  ? Colors.white.withValues(alpha: 0.8)
                  : Colors.black.withValues(alpha: 0.6),
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap() {
    HapticFeedback.selectionClick();
    onTap?.call();
  }
}
