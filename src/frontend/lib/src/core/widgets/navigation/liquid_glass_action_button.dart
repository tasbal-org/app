/// Widget: LiquidGlassActionButton
///
/// Liquid Glass効果を使用した独立したアクションボタン
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

/// 独立したアクションボタン（グルーピングなし）
class LiquidGlassActionButton extends StatelessWidget {
  /// ダークモードかどうか
  final bool isDarkMode;

  /// タップ時のコールバック
  final VoidCallback? onTap;

  /// ボタン内のコンテンツ
  final Widget child;

  /// ボタンのサイズ（デフォルト64）
  final double size;

  const LiquidGlassActionButton({
    super.key,
    required this.isDarkMode,
    this.onTap,
    required this.child,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap?.call();
      },
      child: LiquidStretch(
        child: LiquidGlass.withOwnLayer(
          settings: LiquidGlassSettings(
            thickness: isDarkMode ? 8 : 12,
            glassColor: isDarkMode
                ? const Color(0x25FFFFFF)
                : const Color(0x40FFFFFF),
            lightIntensity: isDarkMode ? 0.6 : 1.0,
            saturation: 1.1,
            blur: isDarkMode ? 12.0 : 16.0,
          ),
          // 正円にするためにborder-radiusをサイズの半分に
          shape: LiquidRoundedSuperellipse(borderRadius: size / 2),
          child: SizedBox(
            width: size,
            height: size,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
