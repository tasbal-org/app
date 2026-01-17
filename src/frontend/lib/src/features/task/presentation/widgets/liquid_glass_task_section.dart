/// Widget: LiquidGlassTaskSection
///
/// Liquid Glass効果を使用したタスクセクションヘッダー
library;

import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

/// Liquid Glass効果のセクションヘッダー
class LiquidGlassTaskSection extends StatelessWidget {
  /// セクションタイトル
  final String title;

  /// タスク数
  final int count;

  /// ダークモードかどうか
  final bool isDarkMode;

  /// アイコン（オプション）
  final IconData? icon;

  const LiquidGlassTaskSection({
    super.key,
    required this.title,
    this.count = 0,
    this.isDarkMode = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: LiquidGlass.withOwnLayer(
        settings: LiquidGlassSettings(
          thickness: isDarkMode ? 4 : 6,
          glassColor: isDarkMode
              ? const Color(0x15FFFFFF)
              : const Color(0x25FFFFFF),
          lightIntensity: isDarkMode ? 0.4 : 0.7,
          saturation: 1.0,
          blur: isDarkMode ? 8.0 : 10.0,
        ),
        shape: LiquidRoundedSuperellipse(borderRadius: 14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 18,
                  color: isDarkMode
                      ? Colors.white.withValues(alpha: 0.7)
                      : Colors.black.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode
                      ? Colors.white.withValues(alpha: 0.8)
                      : Colors.black.withValues(alpha: 0.7),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isDarkMode
                      ? Colors.white.withValues(alpha: 0.15)
                      : Colors.black.withValues(alpha: 0.1),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode
                        ? Colors.white.withValues(alpha: 0.7)
                        : Colors.black.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
