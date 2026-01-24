/// Widget: TaskEditForm
///
/// タスク編集用のフォームウィジェット
/// タイトル、メモ、期限、タグを編集可能
/// 新規作成・編集両方で使用可能
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tasbal/src/core/widgets/dialog/dialog.dart';
import 'package:tasbal/src/core/widgets/form/liquid_glass_date_picker_row.dart';
import 'package:tasbal/src/features/task/presentation/widgets/form/tag_autocomplete_field.dart';

/// タスク編集フォームのデータ
class TaskFormData {
  final String title;
  final String? memo;
  final DateTime? dueAt;
  final List<String> tags;
  final bool isPinned;

  const TaskFormData({
    required this.title,
    this.memo,
    this.dueAt,
    this.tags = const [],
    this.isPinned = false,
  });

  TaskFormData copyWith({
    String? title,
    String? memo,
    DateTime? dueAt,
    List<String>? tags,
    bool? isPinned,
    bool clearMemo = false,
    bool clearDueAt = false,
  }) {
    return TaskFormData(
      title: title ?? this.title,
      memo: clearMemo ? null : (memo ?? this.memo),
      dueAt: clearDueAt ? null : (dueAt ?? this.dueAt),
      tags: tags ?? this.tags,
      isPinned: isPinned ?? this.isPinned,
    );
  }
}

/// タスク編集フォーム
///
/// 汎用的なタスク編集フォーム
/// BottomSheetやダイアログ内で使用可能
class TaskEditForm extends StatefulWidget {
  /// 初期データ（編集時に使用）
  final TaskFormData? initialData;

  /// 利用可能なタグ一覧（オートコンプリート用）
  final List<String> availableTags;

  /// 保存ボタン押下時のコールバック
  final void Function(TaskFormData data)? onSave;

  /// キャンセルボタン押下時のコールバック
  final VoidCallback? onCancel;

  /// 削除ボタン押下時のコールバック（nullの場合は削除ボタン非表示）
  final VoidCallback? onDelete;

  /// ピン留め変更時のコールバック
  final ValueChanged<bool>? onPinChanged;

  /// ダークモードかどうか
  final bool isDarkMode;

  /// 保存ボタンのラベル
  final String saveLabel;

  /// タイトルのラベル
  final String formTitle;

  /// 削除確認のタイトル
  final String? deleteConfirmTitle;

  const TaskEditForm({
    super.key,
    this.initialData,
    this.availableTags = const [],
    this.onSave,
    this.onCancel,
    this.onDelete,
    this.onPinChanged,
    this.isDarkMode = false,
    this.saveLabel = '保存',
    this.formTitle = 'タスクを編集',
    this.deleteConfirmTitle,
  });

  @override
  State<TaskEditForm> createState() => _TaskEditFormState();
}

class _TaskEditFormState extends State<TaskEditForm> {
  late TextEditingController _titleController;
  late TextEditingController _memoController;
  late DateTime? _selectedDueAt;
  late List<String> _tags;
  late bool _isPinned;

  @override
  void initState() {
    super.initState();
    final data = widget.initialData;
    _titleController = TextEditingController(text: data?.title ?? '');
    _memoController = TextEditingController(text: data?.memo ?? '');
    _selectedDueAt = data?.dueAt;
    _tags = List<String>.from(data?.tags ?? []);
    _isPinned = data?.isPinned ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  // カラー定義
  Color get _textColor => widget.isDarkMode ? Colors.white : Colors.black87;

  Color get _subtitleColor => widget.isDarkMode
      ? Colors.white.withValues(alpha: 0.6)
      : Colors.black.withValues(alpha: 0.5);

  Color get _inputBackgroundColor => widget.isDarkMode
      ? Colors.white.withValues(alpha: 0.08)
      : Colors.black.withValues(alpha: 0.04);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        _buildTitleField(),
        const SizedBox(height: 12),
        _buildMemoField(),
        const SizedBox(height: 12),
        _buildDueDateField(),
        const SizedBox(height: 12),
        _buildTagsField(),
        const SizedBox(height: 16),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.formTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: _textColor,
          ),
        ),
        Row(
          children: [
            // ピン留めボタン
            IconButton(
              onPressed: () {
                setState(() => _isPinned = !_isPinned);
                HapticFeedback.lightImpact();
              },
              icon: Icon(
                _isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                color: _isPinned
                    ? (widget.isDarkMode
                        ? Colors.amber.shade300
                        : Colors.amber.shade700)
                    : _subtitleColor,
              ),
              tooltip: _isPinned ? 'ピン留め解除' : 'ピン留め',
            ),
            // 削除ボタン（onDeleteが設定されている場合のみ表示）
            if (widget.onDelete != null)
              IconButton(
                onPressed: _showDeleteConfirmation,
                icon: Icon(
                  Icons.delete_outline,
                  color: widget.isDarkMode
                      ? Colors.red.shade300
                      : Colors.red.shade600,
                ),
                tooltip: '削除',
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildTitleField() {
    return TextField(
      controller: _titleController,
      style: TextStyle(color: _textColor, fontSize: 16),
      decoration: InputDecoration(
        labelText: 'タイトル',
        labelStyle: TextStyle(color: _subtitleColor),
        filled: true,
        fillColor: _inputBackgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildMemoField() {
    return TextField(
      controller: _memoController,
      style: TextStyle(color: _textColor, fontSize: 14),
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'メモ',
        labelStyle: TextStyle(color: _subtitleColor),
        filled: true,
        fillColor: _inputBackgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildDueDateField() {
    return InkWell(
      onTap: _selectDueDate,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _inputBackgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.schedule, color: _subtitleColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _selectedDueAt != null
                    ? _formatDateTime(_selectedDueAt!)
                    : '期限なし',
                style: TextStyle(
                  color: _selectedDueAt != null ? _textColor : _subtitleColor,
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
                child: Icon(Icons.close, color: _subtitleColor, size: 20),
              ),
          ],
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

  Widget _buildTagsField() {
    return TagAutocompleteField(
      availableTags: widget.availableTags,
      selectedTags: _tags,
      onTagsChanged: (newTags) {
        setState(() => _tags = newTags);
      },
      isDarkMode: widget.isDarkMode,
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: widget.onCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: _subtitleColor,
              side: BorderSide(color: _subtitleColor.withValues(alpha: 0.3)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('キャンセル'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _saveChanges,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  widget.isDarkMode ? Colors.blue.shade600 : Colors.blue.shade500,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(widget.saveLabel),
          ),
        ),
      ],
    );
  }

  void _saveChanges() {
    final newTitle = _titleController.text.trim();
    if (newTitle.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('タイトルを入力してください')),
      );
      return;
    }

    final newMemo = _memoController.text.trim();

    // ピン留め状態が変わった場合
    final initialPinned = widget.initialData?.isPinned ?? false;
    if (_isPinned != initialPinned) {
      widget.onPinChanged?.call(_isPinned);
    }

    final data = TaskFormData(
      title: newTitle,
      memo: newMemo.isEmpty ? null : newMemo,
      dueAt: _selectedDueAt,
      tags: _tags,
      isPinned: _isPinned,
    );

    widget.onSave?.call(data);
    HapticFeedback.mediumImpact();
  }

  Future<void> _showDeleteConfirmation() async {
    final title = widget.deleteConfirmTitle ?? widget.initialData?.title ?? '';

    final result = await showDeleteConfirmDialog(
      context: context,
      itemName: title,
    );

    if (result == true) {
      HapticFeedback.mediumImpact();
      widget.onDelete?.call();
    }
  }
}
