/// Widget: LiquidGlassSheetHeader
///
/// Liquid Glassスタイルのシートヘッダー
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ボトムシート用ヘッダー
class LiquidGlassSheetHeader extends StatelessWidget {
  /// タイトル
  final String title;

  /// ダークモードかどうか
  final bool isDarkMode;

  /// カウントバッジの値（nullの場合は非表示）
  final int? badgeCount;

  /// 追加ボタンのコールバック（nullの場合は非表示）
  final VoidCallback? onAdd;

  /// 追加ボタンのツールチップ
  final String addTooltip;

  /// 水平パディング
  final double horizontalPadding;

  /// 垂直パディング
  final double verticalPadding;

  const LiquidGlassSheetHeader({
    super.key,
    required this.title,
    required this.isDarkMode,
    this.badgeCount,
    this.onAdd,
    this.addTooltip = '追加',
    this.horizontalPadding = 20,
    this.verticalPadding = 8,
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
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const Spacer(),
          if (badgeCount != null && badgeCount! > 1) ...[
            _buildBadge(),
            const SizedBox(width: 12),
          ],
          if (onAdd != null) _buildAddButton(),
        ],
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDarkMode
            ? Colors.white.withValues(alpha: 0.15)
            : Colors.black.withValues(alpha: 0.08),
      ),
      child: Text(
        '$badgeCount件',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isDarkMode
              ? Colors.white.withValues(alpha: 0.8)
              : Colors.black.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Tooltip(
      message: addTooltip,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onAdd?.call();
        },
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDarkMode
                ? Colors.white.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.08),
          ),
          child: Icon(
            Icons.add,
            size: 20,
            color: isDarkMode
                ? Colors.white.withValues(alpha: 0.8)
                : Colors.black.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}
