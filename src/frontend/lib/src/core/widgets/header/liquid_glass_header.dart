/// Widget: LiquidGlassHeader
///
/// Liquid Glass効果を使用したヘッダー
/// アプリのトップバーにLiquid Glass効果を適用
library;

import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

/// Liquid Glass効果のヘッダー
///
/// ヘッダー全体にLiquid Glass効果を適用
class LiquidGlassHeader extends StatelessWidget implements PreferredSizeWidget {
  /// タイトル
  final String title;

  /// ダークモードかどうか
  final bool isDarkMode;

  /// 右側のアクションウィジェット
  final List<Widget>? actions;

  /// 左側のリーディングウィジェット
  final Widget? leading;

  const LiquidGlassHeader({
    super.key,
    required this.title,
    this.isDarkMode = false,
    this.actions,
    this.leading,
  });

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return LiquidGlassLayer(
      settings: LiquidGlassSettings(
        thickness: isDarkMode ? 8 : 12,
        glassColor: isDarkMode
            ? const Color(0x25FFFFFF)
            : const Color(0x40FFFFFF),
        lightIntensity: isDarkMode ? 0.6 : 1.0,
        saturation: 1.1,
        blur: isDarkMode ? 12.0 : 16.0,
      ),
      child: LiquidGlass(
        // 下部のみ角丸、上部は角丸なし（画面端まで覆う）
        shape: LiquidRoundedSuperellipse(borderRadius: 32),
        child: Padding(
          // SafeArea分のパディングを上部に追加
          padding: EdgeInsets.only(top: topPadding),
          child: SizedBox(
            height: 56,
            child: Row(
              children: [
                // リーディングウィジェット
                if (leading != null) ...[
                  const SizedBox(width: 8),
                  leading!,
                ],

                // タイトル
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: leading != null ? 8 : 20,
                      right: 8,
                    ),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),

                // アクションウィジェット
                if (actions != null)
                  ...actions!.map((action) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: action,
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
