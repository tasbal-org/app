/// Widget: LiquidGlassTagChip
///
/// Liquid Glassスタイルのタグチップ
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// タグチップウィジェット
class LiquidGlassTagChip extends StatelessWidget {
  /// タグのラベル
  final String label;

  /// ダークモードかどうか
  final bool isDarkMode;

  /// 削除タップ時のコールバック（nullの場合は削除ボタン非表示）
  final VoidCallback? onDelete;

  /// チップの色
  final Color? color;

  const LiquidGlassTagChip({
    super.key,
    required this.label,
    required this.isDarkMode,
    this.onDelete,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? const Color(0xFF007AFF);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDarkMode
            ? chipColor.withValues(alpha: 0.3)
            : chipColor.withValues(alpha: 0.15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDarkMode
                  ? Colors.white.withValues(alpha: 0.9)
                  : chipColor,
            ),
          ),
          if (onDelete != null) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                onDelete?.call();
              },
              child: Icon(
                Icons.close,
                size: 14,
                color: isDarkMode
                    ? Colors.white.withValues(alpha: 0.6)
                    : chipColor.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
