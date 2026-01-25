/// Widget: LiquidGlassActionRow
///
/// Liquid Glassスタイルのアクションボタン行
library;

import 'package:flutter/material.dart';
import 'liquid_glass_icon_button.dart';
import 'liquid_glass_primary_button.dart';
import 'liquid_glass_secondary_button.dart';

/// アクションボタン行ウィジェット（キャンセル + [中央ボタン] + 確定）
class LiquidGlassActionRow extends StatelessWidget {
  /// 確定ボタンのラベル
  final String primaryLabel;

  /// キャンセルボタンのラベル
  final String secondaryLabel;

  /// ダークモードかどうか
  final bool isDarkMode;

  /// 確定ボタンタップ時のコールバック
  final VoidCallback? onPrimaryTap;

  /// キャンセルボタンタップ時のコールバック
  final VoidCallback? onSecondaryTap;

  /// 中央ボタンタップ時のコールバック（nullの場合は中央ボタン非表示）
  final VoidCallback? onCenterTap;

  /// 中央ボタンのアイコン
  final IconData centerIcon;

  /// 確定ボタンが有効かどうか
  final bool primaryEnabled;

  /// 水平パディング
  final double horizontalPadding;

  /// 垂直パディング
  final double verticalPadding;

  /// ボタン間のスペース
  final double spacing;

  const LiquidGlassActionRow({
    super.key,
    required this.primaryLabel,
    required this.isDarkMode,
    this.secondaryLabel = 'キャンセル',
    this.onPrimaryTap,
    this.onSecondaryTap,
    this.onCenterTap,
    this.centerIcon = Icons.add,
    this.primaryEnabled = true,
    this.horizontalPadding = 20,
    this.verticalPadding = 12,
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Row(
        children: [
          Expanded(
            child: LiquidGlassSecondaryButton(
              label: secondaryLabel,
              isDarkMode: isDarkMode,
              onTap: onSecondaryTap,
            ),
          ),
          if (onCenterTap != null) ...[
            SizedBox(width: spacing),
            LiquidGlassIconButton(
              icon: centerIcon,
              isDarkMode: isDarkMode,
              onTap: onCenterTap,
            ),
          ],
          SizedBox(width: spacing),
          Expanded(
            child: LiquidGlassPrimaryButton(
              label: primaryLabel,
              isDarkMode: isDarkMode,
              onTap: onPrimaryTap,
              enabled: primaryEnabled,
            ),
          ),
        ],
      ),
    );
  }
}
