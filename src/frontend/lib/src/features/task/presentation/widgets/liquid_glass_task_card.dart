/// Widget: LiquidGlassTaskCard
///
/// Liquid Glass効果を使用したタスクカード
/// タスク一覧で使用する美しいガラス効果のカード
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_liquid_glass_plus/buttons/liquid_glass_switch.dart';
import 'package:flutter_liquid_glass_plus/flutter_liquid_glass.dart';
import 'package:tasbal/src/core/widgets/dialog/dialog.dart';
import 'package:tasbal/src/core/widgets/form/form.dart';
import 'package:tasbal/src/core/widgets/modal/modal.dart';
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

  /// 編集時のコールバック
  final void Function(String title, String? memo, DateTime? dueAt, List<String> tags)? onEdit;

  /// 利用可能なタグ一覧（オートコンプリート用）
  final List<String> availableTags;

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
    this.onEdit,
    this.availableTags = const [],
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
          onEdit: onEdit,
          availableTags: availableTags,
        ),
      ),
    );
  }

  /// 削除確認ダイアログを表示
  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    HapticFeedback.mediumImpact();
    final result = await showDeleteConfirmDialog(
      context: context,
      itemName: title,
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
  final void Function(String title, String? memo, DateTime? dueAt, List<String> tags)? onEdit;
  final List<String> availableTags;

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
    this.onEdit,
    this.availableTags = const [],
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
        _showEditDialog(context);
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
    if (daysDiff <= 7) return '$daysDiff日後';
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

  /// 編集ダイアログを表示
  void _showEditDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TaskEditSheet(
        title: title,
        memo: memo,
        dueAt: dueAt,
        tags: tags,
        isPinned: isPinned,
        isDarkMode: isDarkMode,
        availableTags: availableTags,
        onSave: (newTitle, newMemo, newDueAt, newTags) {
          onEdit?.call(newTitle, newMemo, newDueAt, newTags);
        },
        onPinChanged: onPinChanged,
        onDelete: onDelete,
      ),
    );
  }
}

/// タスク編集シート
class _TaskEditSheet extends StatefulWidget {
  final String title;
  final String? memo;
  final DateTime? dueAt;
  final List<String> tags;
  final bool isPinned;
  final bool isDarkMode;
  final List<String> availableTags;
  final void Function(String title, String? memo, DateTime? dueAt, List<String> tags) onSave;
  final ValueChanged<bool>? onPinChanged;
  final VoidCallback? onDelete;

  const _TaskEditSheet({
    required this.title,
    this.memo,
    this.dueAt,
    required this.tags,
    required this.isPinned,
    required this.isDarkMode,
    this.availableTags = const [],
    required this.onSave,
    this.onPinChanged,
    this.onDelete,
  });

  @override
  State<_TaskEditSheet> createState() => _TaskEditSheetState();
}

class _TaskEditSheetState extends State<_TaskEditSheet> {
  late TextEditingController _titleController;
  late TextEditingController _memoController;
  late DateTime? _selectedDueAt;
  late List<String> _tags;
  late bool _isPinned;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _memoController = TextEditingController(text: widget.memo ?? '');
    _selectedDueAt = widget.dueAt;
    _tags = List<String>.from(widget.tags);
    _isPinned = widget.isPinned;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  bool get _isValid => _titleController.text.trim().isNotEmpty;

  void _save() {
    if (!_isValid) return;

    final newTitle = _titleController.text.trim();
    final newMemo = _memoController.text.trim();

    // ピン留め状態が変わった場合
    if (_isPinned != widget.isPinned) {
      widget.onPinChanged?.call(_isPinned);
    }

    widget.onSave(
      newTitle,
      newMemo.isEmpty ? null : newMemo,
      _selectedDueAt,
      _tags,
    );
    Navigator.pop(context);
  }

  Future<void> _confirmDelete() async {
    final result = await showDeleteConfirmDialog(
      context: context,
      itemName: widget.title,
    );
    if (result == true && mounted) {
      Navigator.pop(context);
      widget.onDelete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LiquidGlassModal(
      title: 'タスクを編集',
      isDarkMode: widget.isDarkMode,
      onCancel: () => Navigator.pop(context),
      onDone: _save,
      doneEnabled: _isValid,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    final textColor = widget.isDarkMode ? Colors.white : Colors.black87;
    final subtitleColor = widget.isDarkMode
        ? Colors.white.withValues(alpha: 0.6)
        : Colors.black.withValues(alpha: 0.5);
    final inputBgColor = widget.isDarkMode
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.04);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // タイトル入力
          TextField(
            controller: _titleController,
            style: TextStyle(color: textColor, fontSize: 16),
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: 'タイトル',
              labelStyle: TextStyle(color: subtitleColor),
              filled: true,
              fillColor: inputBgColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // メモ入力
          TextField(
            controller: _memoController,
            style: TextStyle(color: textColor, fontSize: 14),
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'メモ',
              labelStyle: TextStyle(color: subtitleColor),
              filled: true,
              fillColor: inputBgColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // 期限設定
          InkWell(
            onTap: _selectDueDate,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: inputBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.schedule, color: subtitleColor, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _selectedDueAt != null
                          ? _formatDateTime(_selectedDueAt!)
                          : '期限なし',
                      style: TextStyle(
                        color: _selectedDueAt != null ? textColor : subtitleColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  if (_selectedDueAt != null)
                    GestureDetector(
                      onTap: () {
                        setState(() => _selectedDueAt = null);
                        HapticFeedback.lightImpact();
                      },
                      child: Icon(Icons.close, color: subtitleColor, size: 20),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // タグ設定
          TagAutocompleteField(
            availableTags: widget.availableTags,
            selectedTags: _tags,
            onTagsChanged: (newTags) {
              setState(() => _tags = newTags);
            },
            isDarkMode: widget.isDarkMode,
          ),
          const SizedBox(height: 16),
          // ピン留めスイッチ
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: inputBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.push_pin,
                  color: subtitleColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'ピン留め',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                    ),
                  ),
                ),
                LGSwitch(
                  value: _isPinned,
                  onChanged: (value) {
                    setState(() => _isPinned = value);
                    HapticFeedback.lightImpact();
                  },
                  activeColor: Colors.amber,
                  useOwnLayer: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // 削除ボタン
          if (widget.onDelete != null) ...[
            _buildDeleteButton(),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: LGButton(
          icon: Icons.delete_outline,
          onTap: _confirmDelete,
          width: 48,
          height: 48,
          iconSize: 24,
          iconColor: Colors.white,
          shape: const LiquidOval(),
          settings: const LiquidGlassSettings(
            thickness: 0,
            glassColor: Color(0xFFFF3B30),
            lightIntensity: 0,
            blur: 0,
          ),
          useOwnLayer: true,
          glowColor: const Color.fromARGB(20, 255, 255, 255),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final now = DateTime.now();
    final isToday =
        dt.year == now.year && dt.month == now.month && dt.day == now.day;
    final isTomorrow = dt.year == now.year &&
        dt.month == now.month &&
        dt.day == now.day + 1;

    String dateStr;
    if (isToday) {
      dateStr = '今日';
    } else if (isTomorrow) {
      dateStr = '明日';
    } else {
      dateStr = '${dt.year}/${dt.month}/${dt.day}';
    }

    final timeStr =
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    return '$dateStr $timeStr';
  }

  Future<void> _selectDueDate() async {
    final picked = await showLiquidGlassDateTimePicker(
      context: context,
      isDarkMode: widget.isDarkMode,
      initialDate: _selectedDueAt,
    );
    if (picked != null) {
      setState(() => _selectedDueAt = picked);
      HapticFeedback.selectionClick();
    }
  }
}
