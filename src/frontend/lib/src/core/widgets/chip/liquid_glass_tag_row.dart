/// Widget: LiquidGlassTagRow
///
/// Liquid Glassスタイルのタグ設定行
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'liquid_glass_tag_chip.dart';

/// タグ設定行ウィジェット
class LiquidGlassTagRow extends StatelessWidget {
  /// タグリスト
  final List<String> tags;

  /// ダークモードかどうか
  final bool isDarkMode;

  /// タグ追加タップ時のコールバック
  final VoidCallback onAddTap;

  /// タグ削除時のコールバック
  final void Function(int index)? onTagRemove;

  /// ラベルテキスト
  final String label;

  /// 追加ボタンのテキスト
  final String addButtonLabel;

  const LiquidGlassTagRow({
    super.key,
    required this.tags,
    required this.isDarkMode,
    required this.onAddTap,
    this.onTagRemove,
    this.label = 'タグ',
    this.addButtonLabel = '追加',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 8, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.label_outline,
                size: 16,
                color: isDarkMode
                    ? Colors.white.withValues(alpha: 0.5)
                    : Colors.black.withValues(alpha: 0.4),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: isDarkMode
                      ? Colors.white.withValues(alpha: 0.5)
                      : Colors.black.withValues(alpha: 0.4),
                ),
              ),
              const SizedBox(width: 8),
              _buildAddButton(),
            ],
          ),
          if (tags.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: tags.asMap().entries.map((entry) {
                return LiquidGlassTagChip(
                  label: entry.value,
                  isDarkMode: isDarkMode,
                  onDelete: onTagRemove != null
                      ? () => onTagRemove!(entry.key)
                      : null,
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return Tooltip(
      message: 'タグを追加',
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onAddTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isDarkMode
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.06),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add,
                size: 14,
                color: isDarkMode
                    ? Colors.white.withValues(alpha: 0.6)
                    : Colors.black.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 4),
              Text(
                addButtonLabel,
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode
                      ? Colors.white.withValues(alpha: 0.6)
                      : Colors.black.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
