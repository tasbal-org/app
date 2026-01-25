/// Widget: LiquidGlassCreateTaskSheet
///
/// タスク作成用のモーダルシート
/// 複数タスクの一括登録に対応
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_liquid_glass_plus/flutter_liquid_glass.dart';
import 'package:tasbal/src/core/widgets/form/form.dart';
import 'package:tasbal/src/core/widgets/modal/modal.dart';
import 'package:tasbal/src/features/task/presentation/widgets/form/form.dart';

// TaskInputをre-export（後方互換性のため）
export 'package:tasbal/src/features/task/presentation/widgets/form/task_input.dart';

/// タスク作成モーダルを表示
///
/// [context] BuildContext
/// [isDarkMode] ダークモードかどうか
/// [onTasksCreated] タスク一括作成時のコールバック
/// [existingTags] 既存のタグリスト（Autocomplete用サジェスト）
Future<void> showCreateTaskSheet({
  required BuildContext context,
  required bool isDarkMode,
  required void Function(List<TaskInput> tasks) onTasksCreated,
  List<String> existingTags = const [],
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    builder: (context) => _CreateTaskSheetContent(
      isDarkMode: isDarkMode,
      onTasksCreated: onTasksCreated,
      existingTags: existingTags,
    ),
  );
}

/// タスク作成シートの内部コンテンツ
class _CreateTaskSheetContent extends StatefulWidget {
  final bool isDarkMode;
  final void Function(List<TaskInput> tasks) onTasksCreated;
  final List<String> existingTags;

  const _CreateTaskSheetContent({
    required this.isDarkMode,
    required this.onTasksCreated,
    this.existingTags = const [],
  });

  @override
  State<_CreateTaskSheetContent> createState() =>
      _CreateTaskSheetContentState();
}

class _CreateTaskSheetContentState extends State<_CreateTaskSheetContent> {
  final List<_TaskRow> _taskRows = [];
  int? _expandedRowIndex;

  @override
  void initState() {
    super.initState();
    _addNewRow(requestFocus: true);
  }

  @override
  void dispose() {
    for (final row in _taskRows) {
      row.dispose();
    }
    super.dispose();
  }

  void _addNewRow({bool requestFocus = false}) {
    final row = _TaskRow();
    row.titleController.addListener(() => setState(() {}));
    _taskRows.add(row);
    setState(() {});

    if (requestFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        row.titleFocusNode.requestFocus();
      });
    }
  }

  void _removeRow(int index) {
    if (_taskRows.length <= 1) return;
    _taskRows[index].dispose();
    setState(() {
      _taskRows.removeAt(index);
      if (_expandedRowIndex == index) {
        _expandedRowIndex = null;
      } else if (_expandedRowIndex != null && _expandedRowIndex! > index) {
        _expandedRowIndex = _expandedRowIndex! - 1;
      }
    });
  }

  bool get _hasValidTasks => _taskRows.any((row) => row.hasTitle);

  int get _validTaskCount => _taskRows.where((row) => row.hasTitle).length;

  void _createTasks() {
    if (!_hasValidTasks) return;

    HapticFeedback.lightImpact();
    final tasks = _taskRows
        .where((row) => row.hasTitle)
        .map((row) => row.toTaskInput())
        .toList();

    widget.onTasksCreated(tasks);
    Navigator.of(context).pop();
  }

  void _showDatePicker(int rowIndex) async {
    final row = _taskRows[rowIndex];

    final result = await showLiquidGlassDateTimePicker(
      context: context,
      isDarkMode: widget.isDarkMode,
      initialDate: row.dueAt,
    );

    if (result != null && mounted) {
      setState(() {
        row.dueAt = result;
      });
    }
  }

  void _clearDueAt(int rowIndex) {
    setState(() {
      _taskRows[rowIndex].dueAt = null;
    });
  }

  List<String> _getAllExistingTags() {
    final tags = <String>{};
    tags.addAll(widget.existingTags);
    for (final row in _taskRows) {
      tags.addAll(row.tags);
    }
    return tags.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    final title =
        _validTaskCount > 1 ? 'タスクを追加（$_validTaskCount件）' : 'タスクを追加';

    return LiquidGlassModal(
      title: title,
      isDarkMode: widget.isDarkMode,
      onCancel: () => Navigator.of(context).pop(),
      onDone: _createTasks,
      doneEnabled: _hasValidTasks,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // スクロール可能なタスクリスト
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ..._taskRows.asMap().entries.map((entry) {
                    return _buildTaskRow(entry.key, entry.value);
                  }),
                ],
              ),
            ),
          ),
          // 固定の行追加ボタン
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: _buildAddRowButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildAddRowButton() {
    return Container(
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
        icon: Icons.add,
        onTap: () => _addNewRow(requestFocus: true),
        width: 48,
        height: 48,
        iconSize: 24,
        iconColor: Colors.white,
        shape: const LiquidOval(),
        settings: const LiquidGlassSettings(
          thickness: 0,
          glassColor: Color(0xFF007AFF),
          lightIntensity: 0,
          blur: 0,
        ),
        useOwnLayer: true,
        glowColor: const Color.fromARGB(20, 255, 255, 255),
      ),
    );
  }

  Widget _buildTaskRow(int index, _TaskRow row) {
    final isExpanded = _expandedRowIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: widget.isDarkMode
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // メイン行（タイトル入力 + 削除ボタン）
            Row(
              children: [
                // タイトル入力
                Expanded(
                  child: TextField(
                    controller: row.titleController,
                    focusNode: row.titleFocusNode,
                    style: TextStyle(
                      fontSize: 16,
                      color: widget.isDarkMode ? Colors.white : Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: 'タスク ${index + 1}',
                      hintStyle: TextStyle(
                        color: widget.isDarkMode
                            ? Colors.white.withValues(alpha: 0.4)
                            : Colors.black.withValues(alpha: 0.4),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(
                        left: 16,
                        right: 8,
                        top: 14,
                        bottom: 14,
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) {
                      if (index < _taskRows.length - 1) {
                        _taskRows[index + 1].titleFocusNode.requestFocus();
                      } else {
                        _addNewRow(requestFocus: true);
                      }
                    },
                  ),
                ),
                // 展開ボタン
                GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _expandedRowIndex = isExpanded ? null : index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 20,
                      color: widget.isDarkMode
                          ? Colors.white.withValues(alpha: 0.5)
                          : Colors.black.withValues(alpha: 0.4),
                    ),
                  ),
                ),
                // 削除ボタン（2行以上ある場合のみ）
                if (_taskRows.length > 1)
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _removeRow(index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: widget.isDarkMode
                            ? Colors.white.withValues(alpha: 0.4)
                            : Colors.black.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
              ],
            ),
            // 展開時の詳細入力
            if (isExpanded) ...[
              Divider(
                height: 1,
                color: widget.isDarkMode
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.08),
              ),
              // メモ入力
              TextField(
                controller: row.memoController,
                style: TextStyle(
                  fontSize: 14,
                  color: widget.isDarkMode ? Colors.white : Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: 'メモ（任意）',
                  hintStyle: TextStyle(
                    color: widget.isDarkMode
                        ? Colors.white.withValues(alpha: 0.4)
                        : Colors.black.withValues(alpha: 0.4),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                maxLines: 2,
                minLines: 1,
              ),
              // 期限設定
              LiquidGlassDatePickerRow(
                value: row.dueAt,
                isDarkMode: widget.isDarkMode,
                onTap: () => _showDatePicker(index),
                onClear: () => _clearDueAt(index),
              ),
              // タグ設定（インライン入力）
              LiquidGlassInlineTagField(
                tags: row.tags,
                availableTags: _getAllExistingTags(),
                onTagsChanged: (newTags) {
                  setState(() {
                    row.tags = newTags;
                  });
                },
                isDarkMode: widget.isDarkMode,
              ),
            ],
          ],
        ),
      ),
    );
  }
}


/// 個別タスク入力行のデータ
class _TaskRow {
  final TextEditingController titleController;
  final TextEditingController memoController;
  final FocusNode titleFocusNode;
  DateTime? dueAt;
  List<String> tags;

  _TaskRow()
      : titleController = TextEditingController(),
        memoController = TextEditingController(),
        titleFocusNode = FocusNode(),
        dueAt = null,
        tags = [];

  void dispose() {
    titleController.dispose();
    memoController.dispose();
    titleFocusNode.dispose();
  }

  bool get hasTitle => titleController.text.trim().isNotEmpty;

  TaskInput toTaskInput() {
    return TaskInput(
      title: titleController.text.trim(),
      memo: memoController.text.trim().isEmpty
          ? null
          : memoController.text.trim(),
      dueAt: dueAt,
      tags: tags,
    );
  }
}

/// 後方互換性のためのエイリアス
@Deprecated('Use showCreateTaskSheet instead')
typedef LiquidGlassCreateTaskSheet = _CreateTaskSheetContent;
