/// Widget: LiquidGlassListSection
///
/// Liquid Glass効果を使用したリストセクションコンテナ
library;

import 'package:flutter/material.dart';
import 'package:flutter_liquid_glass_plus/flutter_liquid_glass.dart';

/// Liquid Glassリストセクションコンテナ
class LiquidGlassListSection extends StatelessWidget {
  /// 子ウィジェット
  final List<Widget> children;

  /// ダークモードかどうか
  final bool isDarkMode;

  /// 区切り線のインデント
  final double dividerIndent;

  /// 角丸の半径
  final double borderRadius;

  const LiquidGlassListSection({
    super.key,
    required this.children,
    this.isDarkMode = false,
    this.dividerIndent = 16,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: LGCard(
        padding: EdgeInsets.zero,
        useOwnLayer: true,
        settings: LiquidGlassSettings(
          thickness: isDarkMode ? 8 : 14,
          glassColor: isDarkMode
              ? const Color(0x40FFFFFF)
              : const Color(0x70FFFFFF),
          lightIntensity: isDarkMode ? 0.5 : 1.2,
          saturation: 1.0,
          blur: isDarkMode ? 12.0 : 24.0,
        ),
        shape: LiquidRoundedSuperellipse(borderRadius: borderRadius),
        child: Column(
          children: _buildChildrenWithDividers(),
        ),
      ),
    );
  }

  List<Widget> _buildChildrenWithDividers() {
    final result = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(Divider(
          height: 1,
          thickness: 0.5,
          indent: dividerIndent,
          endIndent: dividerIndent,
          color: isDarkMode
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.08),
        ));
      }
    }
    return result;
  }
}
