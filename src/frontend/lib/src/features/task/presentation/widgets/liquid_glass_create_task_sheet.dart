/// Widget: LiquidGlassCreateTaskSheet
///
/// Liquid Glass効果を使用したタスク作成ボトムシート
/// 下からスライドして表示され、横幅いっぱいに広がる
/// 複数タスクの一括登録に対応
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:tasbal/src/core/widgets/button/button.dart';
import 'package:tasbal/src/core/widgets/chip/chip.dart';
import 'package:tasbal/src/core/widgets/form/form.dart';
import 'package:tasbal/src/core/widgets/sheet/sheet.dart';

// TaskInputをre-export（後方互換性のため）
export 'package:tasbal/src/core/widgets/form/task_input.dart';

/// タスク作成ボトムシートを表示
///
/// 下からスライドして表示されるモーダルシート
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
    barrierColor: Colors.black.withValues(alpha: 0.3),
    // スライドアニメーション中も角丸を維持
    clipBehavior: Clip.antiAlias,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(28),
        topRight: Radius.circular(28),
      ),
    ),
    builder: (context) => LiquidGlassCreateTaskSheet(
      isDarkMode: isDarkMode,
      onTasksCreated: onTasksCreated,
      existingTags: existingTags,
    ),
  );
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

/// Liquid Glass効果のタスク作成シート
class LiquidGlassCreateTaskSheet extends StatefulWidget {
  /// ダークモードかどうか
  final bool isDarkMode;

  /// タスク一括作成時のコールバック
  final void Function(List<TaskInput> tasks) onTasksCreated;

  /// 既存のタグリスト（Autocomplete用サジェスト）
  final List<String> existingTags;

  const LiquidGlassCreateTaskSheet({
    super.key,
    required this.isDarkMode,
    required this.onTasksCreated,
    this.existingTags = const [],
  });

  @override
  State<LiquidGlassCreateTaskSheet> createState() =>
      _LiquidGlassCreateTaskSheetState();
}

class _LiquidGlassCreateTaskSheetState
    extends State<LiquidGlassCreateTaskSheet> {
  final List<_TaskRow> _taskRows = [];
  int? _expandedRowIndex;

  @override
  void initState() {
    super.initState();
    // 初期状態で1行追加
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

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.9,
      ),
      // 角丸はshowModalBottomSheetのshapeで適用済み
      child: LiquidGlass.withOwnLayer(
        settings: LiquidGlassSettings(
          thickness: widget.isDarkMode ? 12 : 18,
          glassColor: widget.isDarkMode
              ? const Color(0x80000000)
              : const Color(0xB0FFFFFF),
          lightIntensity: widget.isDarkMode ? 0.3 : 0.7,
          saturation: 0.8,
          blur: widget.isDarkMode ? 35.0 : 40.0,
        ),
        shape: LiquidRoundedSuperellipse(borderRadius: 0),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ドラッグハンドル
              LiquidGlassDragHandle(isDarkMode: widget.isDarkMode),
              // ヘッダー
              LiquidGlassSheetHeader(
                title: 'タスクを追加',
                isDarkMode: widget.isDarkMode,
                badgeCount: _validTaskCount,
                onAdd: () => _addNewRow(requestFocus: true),
                addTooltip: 'タスクを追加',
              ),
              // タスク入力リスト（スクロール可能）
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ..._taskRows.asMap().entries.map((entry) {
                        return _buildTaskRow(entry.key, entry.value);
                      }),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              // アクションボタン
              LiquidGlassActionRow(
                primaryLabel:
                    _validTaskCount > 1 ? '$_validTaskCount件追加' : '追加',
                isDarkMode: widget.isDarkMode,
                primaryEnabled: _hasValidTasks,
                onPrimaryTap: _createTasks,
                onSecondaryTap: () => Navigator.of(context).pop(),
              ),
              // SafeArea分の余白
              SizedBox(height: bottomSafeArea > 0 ? bottomSafeArea : 16),
            ],
          ),
        ),
      ),
    );
  }

  /// タスク入力行
  Widget _buildTaskRow(int index, _TaskRow row) {
    final isExpanded = _expandedRowIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: widget.isDarkMode
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.04),
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
                      // 次の行があればそちらにフォーカス、なければ新規行追加
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
              // タグ設定
              LiquidGlassTagRow(
                tags: row.tags,
                isDarkMode: widget.isDarkMode,
                onAddTap: () => _showAddTagDialog(index),
                onTagRemove: (tagIndex) {
                  setState(() {
                    row.tags.removeAt(tagIndex);
                  });
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 全タスク行から既存タグを収集
  List<String> _getAllExistingTags() {
    final tags = <String>{};
    // ウィジェットから渡された既存タグを追加
    tags.addAll(widget.existingTags);
    // 現在のタスク行から入力されたタグも追加
    for (final row in _taskRows) {
      tags.addAll(row.tags);
    }
    return tags.toList()..sort();
  }

  /// タグ追加ダイアログを表示
  void _showAddTagDialog(int rowIndex) {
    final allTags = _getAllExistingTags();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
              widget.isDarkMode ? const Color(0xFF2C2C2E) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'タグを追加',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: widget.isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          content: SizedBox(
            width: 280,
            child: FreeSoloAutocomplete(
              options: allTags,
              isDarkMode: widget.isDarkMode,
              autofocus: true,
              hintText: 'タグ名を入力または選択',
              showCreateOption: true,
              createOptionLabel: (value) => '「$value」を新規作成',
              onSelected: (value) {
                if (value.trim().isNotEmpty) {
                  setState(() {
                    // 重複チェック
                    if (!_taskRows[rowIndex].tags.contains(value.trim())) {
                      _taskRows[rowIndex].tags.add(value.trim());
                    }
                  });
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'キャンセル',
                style: TextStyle(
                  color: widget.isDarkMode
                      ? Colors.white.withValues(alpha: 0.6)
                      : Colors.black.withValues(alpha: 0.5),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
