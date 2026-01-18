/// Widget: MultipleFreeSoloAutocomplete
///
/// MUI Autocomplete（freeSolo + multiple）を参考にした複数選択可能なAutocomplete
/// 既存の選択肢から選ぶか、新しい値を自由に入力できる
/// 複数の値を選択可能で、選択済みの値はChipとして表示
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Multiple FreeSolo Autocomplete コンポーネント
///
/// MUIのAutocomplete freeSolo + multipleモードを参考にした実装
/// - 既存の選択肢から選択可能
/// - 選択肢にない新しい値も自由に入力可能
/// - 複数の値を選択可能
/// - 選択済みの値はChipとして表示
/// - 右側にクリアボタンとドロップダウンボタン
/// - ダークモード対応
class MultipleFreeSoloAutocomplete extends StatefulWidget {
  /// 選択肢のリスト
  final List<String> options;

  /// 現在選択されている値のリスト
  final List<String> selectedValues;

  /// 値が変更されたときのコールバック
  final ValueChanged<List<String>> onChanged;

  /// ヒントテキスト
  final String? hintText;

  /// ラベルテキスト
  final String? labelText;

  /// ダークモードかどうか
  final bool isDarkMode;

  /// ボーダーの半径
  final double borderRadius;

  /// 選択肢に「新規作成」オプションを表示するかどうか
  final bool showCreateOption;

  /// 新規作成時のラベルフォーマッタ
  final String Function(String value)? createOptionLabel;

  /// 最大選択数（nullの場合は無制限）
  final int? maxSelections;

  /// オプションリストの最大高さ
  final double maxOptionsHeight;

  const MultipleFreeSoloAutocomplete({
    super.key,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    this.hintText,
    this.labelText,
    this.isDarkMode = false,
    this.borderRadius = 12,
    this.showCreateOption = true,
    this.createOptionLabel,
    this.maxSelections,
    this.maxOptionsHeight = 200,
  });

  @override
  State<MultipleFreeSoloAutocomplete> createState() =>
      _MultipleFreeSoloAutocompleteState();
}

class _MultipleFreeSoloAutocompleteState
    extends State<MultipleFreeSoloAutocomplete> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // カラー定義
  Color get _textColor => widget.isDarkMode ? Colors.white : Colors.black87;

  Color get _subtitleColor => widget.isDarkMode
      ? Colors.white.withValues(alpha: 0.6)
      : Colors.black.withValues(alpha: 0.5);

  Color get _chipColor => widget.isDarkMode
      ? Colors.blue.withValues(alpha: 0.3)
      : Colors.blue.withValues(alpha: 0.1);

  Color get _chipTextColor =>
      widget.isDarkMode ? Colors.blue.shade200 : Colors.blue.shade700;

  Color get _borderColor => widget.isDarkMode
      ? Colors.white.withValues(alpha: 0.2)
      : Colors.black.withValues(alpha: 0.15);

  Color get _iconColor => widget.isDarkMode
      ? Colors.white.withValues(alpha: 0.5)
      : Colors.black.withValues(alpha: 0.4);

  /// 選択可能な選択肢（既に選択されているものを除く）
  List<String> get _selectableOptions {
    return widget.options
        .where((option) => !widget.selectedValues.contains(option))
        .toList();
  }

  /// 入力値に基づいてフィルタリングされた選択肢を取得
  Iterable<String> _getFilteredOptions(String inputValue) {
    final input = inputValue.toLowerCase().trim();
    List<String> filtered;

    if (input.isEmpty) {
      filtered = _selectableOptions;
    } else {
      filtered = _selectableOptions
          .where((option) => option.toLowerCase().contains(input))
          .toList();
    }

    // freeSolo: 入力値が選択肢に完全一致しない場合、新規作成オプションを追加
    if (widget.showCreateOption &&
        input.isNotEmpty &&
        !widget.options.any((o) => o.toLowerCase() == input) &&
        !widget.selectedValues.any((v) => v.toLowerCase() == input)) {
      return [...filtered, inputValue.trim()];
    }

    return filtered;
  }

  /// 新規作成オプションのラベルを取得
  String _getCreateOptionLabel(String value) {
    if (widget.createOptionLabel != null) {
      return widget.createOptionLabel!(value);
    }
    return '「$value」を作成';
  }

  /// 値を追加
  void _addValue(String value) {
    if (value.isEmpty) {
      return;
    }
    if (widget.selectedValues.contains(value)) {
      return;
    }
    if (widget.maxSelections != null &&
        widget.selectedValues.length >= widget.maxSelections!) {
      return;
    }

    final newValues = [...widget.selectedValues, value];
    widget.onChanged(newValues);
    _controller.clear();
    HapticFeedback.lightImpact();
  }

  /// 値を削除
  void _removeValue(String value) {
    final newValues = widget.selectedValues.where((v) => v != value).toList();
    widget.onChanged(newValues);
    HapticFeedback.lightImpact();
  }

  /// 全ての値をクリア
  void _clearAll() {
    if (widget.selectedValues.isNotEmpty) {
      widget.onChanged([]);
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<String>(
      textEditingController: _controller,
      focusNode: _focusNode,
      optionsBuilder: (textEditingValue) {
        return _getFilteredOptions(textEditingValue.text);
      },
      displayStringForOption: (option) => option,
      onSelected: (selection) {
        _addValue(selection);
        // 選択後もフォーカスを維持して連続入力可能に
        _focusNode.requestFocus();
      },
      fieldViewBuilder: _buildField,
      optionsViewBuilder: _buildOptionsView,
    );
  }

  Widget _buildField(
    BuildContext context,
    TextEditingController controller,
    FocusNode focusNode,
    VoidCallback onFieldSubmitted,
  ) {
    return GestureDetector(
      onTap: () => focusNode.requestFocus(),
      child: AnimatedBuilder(
        animation: focusNode,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              color: widget.isDarkMode
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(
                color: focusNode.hasFocus ? Colors.blue : _borderColor,
                width: focusNode.hasFocus ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // 左側: Chips + 入力フィールド
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ラベル
                      if (widget.labelText != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 12, top: 8),
                          child: Text(
                            widget.labelText!,
                            style: TextStyle(
                              color: focusNode.hasFocus
                                  ? Colors.blue
                                  : _subtitleColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      // Chips + 入力フィールド
                      Padding(
                        padding: EdgeInsets.only(
                          left: 8,
                          right: 4,
                          top: widget.labelText != null ? 4 : 8,
                          bottom: 8,
                        ),
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            // 選択済みの値をChipとして表示
                            ...widget.selectedValues
                                .map((value) => _buildChip(value)),
                            // 入力フィールド
                            IntrinsicWidth(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(minWidth: 60),
                                child: TextField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  style:
                                      TextStyle(color: _textColor, fontSize: 14),
                                  decoration: InputDecoration(
                                    hintText: widget.selectedValues.isEmpty
                                        ? (widget.hintText ?? '入力または選択')
                                        : null,
                                    hintStyle: TextStyle(
                                      color:
                                          _subtitleColor.withValues(alpha: 0.5),
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 8,
                                    ),
                                  ),
                                  onSubmitted: (value) {
                                    if (value.trim().isNotEmpty) {
                                      _addValue(value.trim());
                                    }
                                    onFieldSubmitted();
                                    // 送信後もフォーカスを維持
                                    focusNode.requestFocus();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // 右側: クリアボタン + ドロップダウンアイコン
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // クリアボタン（選択がある場合のみ表示）
                    if (widget.selectedValues.isNotEmpty)
                      GestureDetector(
                        onTap: _clearAll,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            Icons.close,
                            size: 20,
                            color: _iconColor,
                          ),
                        ),
                      ),
                    // ドロップダウンアイコン
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        focusNode.hasFocus
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        size: 24,
                        color: _iconColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOptionsView(
    BuildContext context,
    AutocompleteOnSelected<String> onSelected,
    Iterable<String> options,
  ) {
    if (options.isEmpty) {
      return const SizedBox.shrink();
    }

    final inputText = _controller.text.trim();
    final isNewValue = widget.showCreateOption &&
        inputText.isNotEmpty &&
        !widget.options.any((o) => o.toLowerCase() == inputText.toLowerCase()) &&
        !widget.selectedValues
            .any((v) => v.toLowerCase() == inputText.toLowerCase());

    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        color: widget.isDarkMode ? const Color(0xFF3A3A50) : Colors.white,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: widget.maxOptionsHeight),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options.elementAt(index);
              final isHighlighted =
                  AutocompleteHighlightedOption.of(context) == index;
              final isCreateOption = isNewValue && option == inputText;

              return InkWell(
                onTap: () => onSelected(option),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: isHighlighted
                      ? (widget.isDarkMode
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.black.withValues(alpha: 0.05))
                      : null,
                  child: Row(
                    children: [
                      if (isCreateOption) ...[
                        Icon(
                          Icons.add,
                          size: 18,
                          color: widget.isDarkMode
                              ? Colors.blue.shade300
                              : Colors.blue.shade600,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _getCreateOptionLabel(option),
                            style: TextStyle(
                              color: widget.isDarkMode
                                  ? Colors.blue.shade300
                                  : Colors.blue.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ] else ...[
                        Icon(
                          Icons.label_outline,
                          size: 18,
                          color: _subtitleColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildHighlightedText(option, inputText),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// Chip ウィジェット
  Widget _buildChip(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _chipColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: _chipTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => _removeValue(value),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: widget.isDarkMode
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                size: 14,
                color: _chipTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 検索テキストをハイライト表示
  Widget _buildHighlightedText(String text, String query) {
    if (query.isEmpty) {
      return Text(
        text,
        style: TextStyle(color: _textColor, fontSize: 14),
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final startIndex = lowerText.indexOf(lowerQuery);

    if (startIndex == -1) {
      return Text(
        text,
        style: TextStyle(color: _textColor, fontSize: 14),
      );
    }

    final endIndex = startIndex + query.length;
    final beforeMatch = text.substring(0, startIndex);
    final match = text.substring(startIndex, endIndex);
    final afterMatch = text.substring(endIndex);

    return RichText(
      text: TextSpan(
        style: TextStyle(color: _textColor, fontSize: 14),
        children: [
          TextSpan(text: beforeMatch),
          TextSpan(
            text: match,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: widget.isDarkMode
                  ? Colors.blue.shade300
                  : Colors.blue.shade600,
            ),
          ),
          TextSpan(text: afterMatch),
        ],
      ),
    );
  }
}
