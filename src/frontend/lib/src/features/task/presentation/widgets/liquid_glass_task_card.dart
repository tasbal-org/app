/// Widget: LiquidGlassTaskCard
///
/// Liquid Glass効果を使用したタスクカード
/// タスク一覧で使用する美しいガラス効果のカード
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Liquid Glass効果のタスクカード
class LiquidGlassTaskCard extends StatelessWidget {
  /// タスクID
  final String id;

  /// タスクタイトル
  final String title;

  /// メモ（オプション）
  final String? memo;

  /// 完了状態
  final bool isCompleted;

  /// ピン留め状態
  final bool isPinned;

  /// ダークモードかどうか
  final bool isDarkMode;

  /// 完了切替時のコールバック
  final ValueChanged<bool>? onCompletionChanged;

  /// タップ時のコールバック
  final VoidCallback? onTap;

  const LiquidGlassTaskCard({
    super.key,
    required this.id,
    required this.title,
    this.memo,
    this.isCompleted = false,
    this.isPinned = false,
    this.isDarkMode = false,
    this.onCompletionChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap?.call();
        },
        child: Container(
          decoration: BoxDecoration(
            // 不透明な背景色（文字を読みやすく）
            color: _getBackgroundColor(),
            borderRadius: BorderRadius.circular(14),
            // 軽い影でカード感を出す
            boxShadow: [
              BoxShadow(
                color: isDarkMode
                    ? Colors.black.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // チェックボックス
              _buildCheckbox(),
              const SizedBox(width: 12),

              // タイトルとメモ
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: _getTextColor(),
                        decoration:
                            isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    if (memo != null && memo!.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        memo!,
                        style: TextStyle(
                          fontSize: 12,
                          color: _getSubtitleColor(),
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // ピン留めアイコン
              if (isPinned) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.push_pin,
                  size: 16,
                  color: _getIconColor(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// 背景色を取得（不透明）
  Color _getBackgroundColor() {
    if (isCompleted) {
      return isDarkMode
          ? const Color(0xFF2A2A3E) // ダークモード完了：暗い紫がかったグレー
          : const Color(0xFFF5F5F8); // ライトモード完了：薄いグレー
    }
    return isDarkMode
        ? const Color(0xFF363650) // ダークモード：紫がかった暗いグレー
        : Colors.white; // ライトモード：白
  }

  /// チェックボックスウィジェット
  Widget _buildCheckbox() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onCompletionChanged?.call(!isCompleted);
      },
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isCompleted
                ? (isDarkMode ? Colors.green.shade300 : Colors.green.shade600)
                : (isDarkMode
                    ? Colors.white.withValues(alpha: 0.4)
                    : Colors.black.withValues(alpha: 0.3)),
            width: 2,
          ),
          color: isCompleted
              ? (isDarkMode ? Colors.green.shade300 : Colors.green.shade600)
              : Colors.transparent,
        ),
        child: isCompleted
            ? Icon(
                Icons.check,
                size: 16,
                color: isDarkMode ? Colors.black : Colors.white,
              )
            : null,
      ),
    );
  }

  /// テキストカラーを取得
  Color _getTextColor() {
    if (isCompleted) {
      return isDarkMode
          ? Colors.white.withValues(alpha: 0.4)
          : Colors.black.withValues(alpha: 0.4);
    }
    return isDarkMode ? Colors.white : Colors.black87;
  }

  /// サブタイトルカラーを取得
  Color _getSubtitleColor() {
    if (isCompleted) {
      return isDarkMode
          ? Colors.white.withValues(alpha: 0.3)
          : Colors.black.withValues(alpha: 0.3);
    }
    return isDarkMode
        ? Colors.white.withValues(alpha: 0.6)
        : Colors.black.withValues(alpha: 0.5);
  }

  /// アイコンカラーを取得
  Color _getIconColor() {
    return isDarkMode
        ? Colors.white.withValues(alpha: 0.5)
        : Colors.black.withValues(alpha: 0.4);
  }
}
