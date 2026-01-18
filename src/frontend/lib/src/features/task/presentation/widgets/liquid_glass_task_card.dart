/// Widget: LiquidGlassTaskCard
///
/// Liquid Glass効果を使用したタスクカード
/// タスク一覧で使用する美しいガラス効果のカード
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tasbal/src/core/widgets/swipe/swipe.dart';

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

  /// タグリスト（オプション）
  final List<String> tags;

  /// 期限（オプション）
  final DateTime? dueAt;

  /// 完了切替時のコールバック
  final ValueChanged<bool>? onCompletionChanged;

  /// ピン留め切替時のコールバック
  final ValueChanged<bool>? onPinChanged;

  /// 削除時のコールバック
  final VoidCallback? onDelete;

  /// 非表示時のコールバック
  final VoidCallback? onHide;

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
    this.tags = const [],
    this.dueAt,
    this.onCompletionChanged,
    this.onPinChanged,
    this.onDelete,
    this.onHide,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SwipeableCard(
        leftAction: SwipeAction(
          icon: isPinned ? Icons.push_pin_outlined : Icons.push_pin,
          label: isPinned ? '解除' : 'ピン留め',
          backgroundColor: isDarkMode ? const Color(0xFF7A5C00) : Colors.amber.shade600,
          onTap: () {
            HapticFeedback.mediumImpact();
            onPinChanged?.call(!isPinned);
          },
        ),
        rightActions: [
          SwipeAction(
            icon: Icons.inventory_2_outlined,
            label: '非表示',
            backgroundColor: isDarkMode ? Colors.blue.shade900 : Colors.blue.shade500,
            onTap: () {
              HapticFeedback.mediumImpact();
              onHide?.call();
            },
          ),
          SwipeAction(
            icon: Icons.delete_outline,
            label: '削除',
            backgroundColor: isDarkMode ? Colors.red.shade900 : Colors.red.shade500,
            onTap: () async {
              final shouldDelete = await _showDeleteConfirmation(context);
              if (shouldDelete) {
                onDelete?.call();
              }
            },
          ),
        ],
        child: _TaskCardContent(
          title: title,
          memo: memo,
          isCompleted: isCompleted,
          isPinned: isPinned,
          isDarkMode: isDarkMode,
          tags: tags,
          dueAt: dueAt,
          onCompletionChanged: onCompletionChanged,
          onPinChanged: onPinChanged,
          onDelete: onDelete,
          onTap: onTap,
        ),
      ),
    );
  }

  /// 削除確認ダイアログを表示
  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('タスクを削除'),
        content: Text('「$title」を削除しますか？\nこの操作は取り消せません。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              Navigator.pop(context, true);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('削除'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

/// タスクカードのコンテンツ
class _TaskCardContent extends StatelessWidget {
  final String title;
  final String? memo;
  final bool isCompleted;
  final bool isPinned;
  final bool isDarkMode;
  final List<String> tags;
  final DateTime? dueAt;
  final ValueChanged<bool>? onCompletionChanged;
  final ValueChanged<bool>? onPinChanged;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const _TaskCardContent({
    required this.title,
    this.memo,
    required this.isCompleted,
    required this.isPinned,
    required this.isDarkMode,
    required this.tags,
    this.dueAt,
    this.onCompletionChanged,
    this.onPinChanged,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap?.call();
      },
      onLongPress: () {
        HapticFeedback.mediumImpact();
        _showContextMenu(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(14),
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
            _buildCheckbox(),
            const SizedBox(width: 12),
            Expanded(child: _buildContent()),
            if (isPinned) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.push_pin,
                size: 16,
                color: _iconColor,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 背景色
  Color get _backgroundColor {
    if (isCompleted) {
      return isDarkMode ? const Color(0xFF2A2A3E) : const Color(0xFFF5F5F8);
    }
    return isDarkMode ? const Color(0xFF363650) : Colors.white;
  }

  /// テキストカラー
  Color get _textColor {
    if (isCompleted) {
      return isDarkMode
          ? Colors.white.withValues(alpha: 0.4)
          : Colors.black.withValues(alpha: 0.4);
    }
    return isDarkMode ? Colors.white : Colors.black87;
  }

  /// サブタイトルカラー
  Color get _subtitleColor {
    if (isCompleted) {
      return isDarkMode
          ? Colors.white.withValues(alpha: 0.3)
          : Colors.black.withValues(alpha: 0.3);
    }
    return isDarkMode
        ? Colors.white.withValues(alpha: 0.6)
        : Colors.black.withValues(alpha: 0.5);
  }

  /// アイコンカラー
  Color get _iconColor {
    return isDarkMode
        ? Colors.white.withValues(alpha: 0.5)
        : Colors.black.withValues(alpha: 0.4);
  }

  /// チェックボックス
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

  /// コンテンツ
  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: _textColor,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        if (memo != null && memo!.isNotEmpty) ...[
          const SizedBox(height: 3),
          Text(
            memo!,
            style: TextStyle(
              fontSize: 12,
              color: _subtitleColor,
              decoration: isCompleted ? TextDecoration.lineThrough : null,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (tags.isNotEmpty || dueAt != null) ...[
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              if (dueAt != null) _buildDueChip(),
              ...tags.map((tag) => _buildTagChip(tag)),
            ],
          ),
        ],
      ],
    );
  }

  /// 期限チップ
  Widget _buildDueChip() {
    final now = DateTime.now();
    final isOverdue = dueAt!.isBefore(now);
    final isDueSoon = !isOverdue && dueAt!.difference(now).inHours <= 24;

    final today = DateTime(now.year, now.month, now.day);
    final dueDate = DateTime(dueAt!.year, dueAt!.month, dueAt!.day);
    final daysDiff = dueDate.difference(today).inDays;

    final dueText = _getDueText(daysDiff);
    final (chipColor, textColor) = _getDueColors(isOverdue, isDueSoon);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.schedule, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            dueText,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  /// 期限テキスト取得
  String _getDueText(int daysDiff) {
    if (daysDiff == 0) return '今日';
    if (daysDiff == 1) return '明日';
    if (daysDiff == -1) return '昨日';
    if (daysDiff < 0) return '${-daysDiff}日前';
    if (daysDiff <= 7) return '${daysDiff}日後';
    return '${dueAt!.month}/${dueAt!.day}';
  }

  /// 期限の色取得
  (Color, Color) _getDueColors(bool isOverdue, bool isDueSoon) {
    if (isCompleted) {
      return (
        isDarkMode
            ? Colors.grey.withValues(alpha: 0.3)
            : Colors.grey.withValues(alpha: 0.2),
        _subtitleColor,
      );
    }
    if (isOverdue) {
      return (
        isDarkMode ? Colors.red.shade900.withValues(alpha: 0.5) : Colors.red.shade50,
        isDarkMode ? Colors.red.shade300 : Colors.red.shade700,
      );
    }
    if (isDueSoon) {
      return (
        isDarkMode ? Colors.orange.shade900.withValues(alpha: 0.5) : Colors.orange.shade50,
        isDarkMode ? Colors.orange.shade300 : Colors.orange.shade700,
      );
    }
    return (
      isDarkMode ? Colors.blue.shade900.withValues(alpha: 0.4) : Colors.blue.shade50,
      isDarkMode ? Colors.blue.shade300 : Colors.blue.shade700,
    );
  }

  /// タグチップ
  Widget _buildTagChip(String tag) {
    final chipColor = isDarkMode
        ? Colors.white.withValues(alpha: 0.12)
        : Colors.black.withValues(alpha: 0.06);
    final textColor = isCompleted
        ? _subtitleColor
        : (isDarkMode
            ? Colors.white.withValues(alpha: 0.7)
            : Colors.black.withValues(alpha: 0.6));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        tag,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }

  /// コンテキストメニュー
  void _showContextMenu(BuildContext context) {
    final menuTextColor = isDarkMode ? Colors.white : Colors.black87;
    final menuBackgroundColor = isDarkMode ? const Color(0xFF2A2A3E) : Colors.white;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: menuBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHandle(),
              _buildMenuTitle(menuTextColor),
              const Divider(height: 1),
              _buildPinMenuItem(context, menuTextColor),
              _buildDeleteMenuItem(context),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.white.withValues(alpha: 0.3)
            : Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildMenuTitle(Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildPinMenuItem(BuildContext context, Color textColor) {
    return ListTile(
      leading: Icon(
        isPinned ? Icons.push_pin_outlined : Icons.push_pin,
        color: textColor,
      ),
      title: Text(
        isPinned ? 'ピン留め解除' : 'ピン留め',
        style: TextStyle(color: textColor),
      ),
      onTap: () {
        Navigator.pop(context);
        HapticFeedback.lightImpact();
        onPinChanged?.call(!isPinned);
      },
    );
  }

  Widget _buildDeleteMenuItem(BuildContext context) {
    final deleteColor = isDarkMode ? Colors.red.shade300 : Colors.red.shade600;
    return ListTile(
      leading: Icon(Icons.delete_outline, color: deleteColor),
      title: Text('削除', style: TextStyle(color: deleteColor)),
      onTap: () {
        Navigator.pop(context);
        _showDeleteConfirmation(context);
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('タスクを削除'),
        content: Text('「$title」を削除しますか？\nこの操作は取り消せません。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              HapticFeedback.mediumImpact();
              onDelete?.call();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }
}
