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

  /// 選択済みの値を候補リストから除外するかどうか
  final bool excludeSelectedFromOptions;

  /// ボーダーを表示するかどうか（falseの場合は背景色のみ）
  final bool showBorder;

  /// フォーカス時のボーダー色
  final Color? focusedBorderColor;

  /// オプションリストにスクロールバーを表示するかどうか
  final bool showOptionsScrollbar;

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
    this.maxOptionsHeight = 150,
    this.excludeSelectedFromOptions = true,
    this.showBorder = false,
    this.focusedBorderColor,
    this.showOptionsScrollbar = true,
  });

  @override
  State<MultipleFreeSoloAutocomplete> createState() =>
      _MultipleFreeSoloAutocompleteState();
}

class _MultipleFreeSoloAutocompleteState
    extends State<MultipleFreeSoloAutocomplete> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<String> _filteredOptions = [];
  int _highlightedIndex = -1;
  double _fieldWidth = 200;
  double _fieldHeight = 0;
  Offset _fieldPosition = Offset.zero;
  bool _showAbove = true;
  double _availableHeight = 150;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChanged);
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _removeOverlay();
    _focusNode.removeListener(_onFocusChanged);
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MultipleFreeSoloAutocomplete oldWidget) {
    super.didUpdateWidget(oldWidget);
    // selectedValuesやoptionsが変更されたら即座にオーバーレイを更新
    if (oldWidget.selectedValues != widget.selectedValues ||
        oldWidget.options != widget.options) {
      _updateFilteredOptions();
      if (_focusNode.hasFocus) {
        // 次のフレームでオーバーレイを更新
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _focusNode.hasFocus) {
            _updateOverlay();
          }
        });
      }
    }
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      _updateFilteredOptions();
      _showOverlay();
    } else {
      _removeOverlay();
    }
    setState(() {});
  }

  void _onTextChanged() {
    _updateFilteredOptions();
    _updateOverlay();
  }

  void _updateFilteredOptions() {
    final input = _controller.text.toLowerCase().trim();
    List<String> baseOptions = widget.excludeSelectedFromOptions
        ? widget.options
            .where((option) => !widget.selectedValues.contains(option))
            .toList()
        : widget.options
            .where((option) => !widget.selectedValues.contains(option))
            .toList();

    List<String> filtered;
    if (input.isEmpty) {
      filtered = baseOptions;
    } else {
      filtered = baseOptions
          .where((option) => option.toLowerCase().contains(input))
          .toList();
    }

    // freeSolo: 入力値が選択肢に完全一致しない場合、新規作成オプションを追加
    if (widget.showCreateOption &&
        input.isNotEmpty &&
        !widget.options.any((o) => o.toLowerCase() == input) &&
        !widget.selectedValues.any((v) => v.toLowerCase() == input)) {
      filtered = [...filtered, _controller.text.trim()];
    }

    _filteredOptions = filtered;
    _highlightedIndex = _filteredOptions.isNotEmpty ? 0 : -1;
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
    setState(() {});
  }

  /// 値を削除
  void _removeValue(String value) {
    final newValues = widget.selectedValues.where((v) => v != value).toList();
    widget.onChanged(newValues);
    HapticFeedback.lightImpact();
    setState(() {});
  }

  /// 全ての値をクリア
  void _clearAll() {
    if (widget.selectedValues.isNotEmpty) {
      widget.onChanged([]);
      HapticFeedback.lightImpact();
      setState(() {});
    }
  }

  void _showOverlay() {
    _removeOverlay();
    if (_filteredOptions.isEmpty) return;

    // RenderBoxからサイズと位置を取得
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null && renderBox.hasSize) {
      _fieldWidth = renderBox.size.width;
      _fieldHeight = renderBox.size.height;
      _fieldPosition = renderBox.localToGlobal(Offset.zero);

      // 画面サイズを取得
      final screenHeight = MediaQuery.of(context).size.height;
      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      final safeAreaTop = MediaQuery.of(context).padding.top;

      // フィールドの上下の利用可能なスペースを計算
      final spaceAbove = _fieldPosition.dy - safeAreaTop;
      final spaceBelow = screenHeight - keyboardHeight - _fieldPosition.dy - _fieldHeight;

      // 上下どちらに表示するか決定（より広い方に表示）
      _showAbove = spaceAbove > spaceBelow;

      // 利用可能な高さを計算（マージン20px確保）
      final maxSpace = (_showAbove ? spaceAbove : spaceBelow) - 20;
      _availableHeight = maxSpace.clamp(80.0, widget.maxOptionsHeight);
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => _buildOverlay(),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _updateOverlay() {
    if (_overlayEntry != null) {
      if (_filteredOptions.isEmpty) {
        _removeOverlay();
      } else {
        _overlayEntry!.markNeedsBuild();
      }
    } else if (_focusNode.hasFocus && _filteredOptions.isNotEmpty) {
      _showOverlay();
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Widget _buildOverlay() {
    final inputText = _controller.text.trim();
    final isNewValue = widget.showCreateOption &&
        inputText.isNotEmpty &&
        !widget.options.any((o) => o.toLowerCase() == inputText.toLowerCase()) &&
        !widget.selectedValues
            .any((v) => v.toLowerCase() == inputText.toLowerCase());

    // 候補リストの実際の高さを計算（各アイテム約44px + パディング16px）
    const itemHeight = 44.0;
    const paddingHeight = 16.0;
    final estimatedHeight = (_filteredOptions.length * itemHeight + paddingHeight)
        .clamp(0.0, _availableHeight);

    // 上に表示する場合は負のオフセット、下に表示する場合は正のオフセット
    final offset = _showAbove
        ? Offset(0, -(estimatedHeight + 8))
        : Offset(0, _fieldHeight + 8);

    return Positioned(
      width: _fieldWidth,
      child: CompositedTransformFollower(
        link: _layerLink,
        showWhenUnlinked: false,
        offset: offset,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: widget.isDarkMode ? const Color(0xFF3A3A50) : Colors.white,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: _availableHeight),
            child: _buildOptionsList(isNewValue, inputText),
          ),
        ),
      ),
    );
  }

  /// オプションリストを構築（スクロールバーの有無で分岐）
  Widget _buildOptionsList(bool isNewValue, String inputText) {
    final listView = ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      shrinkWrap: true,
      itemCount: _filteredOptions.length,
      itemBuilder: (context, index) {
        final option = _filteredOptions[index];
        final isHighlighted = _highlightedIndex == index;
        final isCreateOption = isNewValue && option == inputText;

        return InkWell(
          onTap: () {
            _addValue(option);
            _focusNode.requestFocus();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
    );

    // スクロールバーの表示/非表示を切り替え
    if (widget.showOptionsScrollbar) {
      return Scrollbar(
        thumbVisibility: true,
        radius: const Radius.circular(4),
        child: listView,
      );
    }
    return listView;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: InputDecorator(
        isFocused: _focusNode.hasFocus,
        isEmpty: widget.selectedValues.isEmpty && _controller.text.isEmpty,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(
            color: _subtitleColor,
            fontSize: 14,
          ),
          floatingLabelStyle: TextStyle(
            color: _focusNode.hasFocus
                ? (widget.focusedBorderColor ?? Colors.blue)
                : _subtitleColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          filled: true,
          fillColor: widget.isDarkMode
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.04),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: widget.showBorder
                ? BorderSide(color: _borderColor)
                : BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: widget.showBorder
                ? BorderSide(color: _borderColor)
                : BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: widget.showBorder
                ? BorderSide(
                    color: widget.focusedBorderColor ?? Colors.blue,
                    width: 2,
                  )
                : BorderSide.none,
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // クリアボタン（選択がある場合のみ表示、ない場合も同じ幅を確保）
              SizedBox(
                width: 36,
                height: 36,
                child: widget.selectedValues.isNotEmpty
                    ? GestureDetector(
                        onTap: _clearAll,
                        child: Center(
                          child: Icon(
                            Icons.close,
                            size: 20,
                            color: _iconColor,
                          ),
                        ),
                      )
                    : null,
              ),
              // ドロップダウンアイコン（常に右端に固定）
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  _focusNode.hasFocus
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down,
                  size: 24,
                  color: _iconColor,
                ),
              ),
            ],
          ),
        ),
        child: GestureDetector(
          onTap: () => _focusNode.requestFocus(),
          behavior: HitTestBehavior.opaque,
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // 選択済みの値をChipとして表示
              ...widget.selectedValues.map((value) => _buildChip(value)),
              // 入力フィールド
              IntrinsicWidth(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 60),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    style: TextStyle(color: _textColor, fontSize: 14),
                    decoration: InputDecoration(
                      // ラベルがフロートしている時（フォーカス時）のみヒントを表示
                      // ラベルがフィールド内にある時は被るので表示しない
                      hintText: _focusNode.hasFocus &&
                              widget.selectedValues.isEmpty &&
                              _controller.text.isEmpty
                          ? (widget.hintText ?? '入力または選択')
                          : null,
                      hintStyle: TextStyle(
                        color: _subtitleColor.withValues(alpha: 0.5),
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
                      // 送信後もフォーカスを維持
                      _focusNode.requestFocus();
                    },
                  ),
                ),
              ),
            ],
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

/// タグ入力専用のAutocompleteフィールド
///
/// MultipleFreeSoloAutocompleteをタグ入力用にラップしたウィジェット
/// - 既存のタグから選択可能
/// - 新しいタグも自由に入力可能
/// - 複数タグの選択・削除が可能
/// - ダークモード対応
class TagAutocompleteField extends StatelessWidget {
  /// 選択可能なタグ一覧
  final List<String> availableTags;

  /// 現在選択されているタグ
  final List<String> selectedTags;

  /// タグが変更されたときのコールバック
  final ValueChanged<List<String>> onTagsChanged;

  /// ラベルテキスト
  final String? labelText;

  /// ヒントテキスト
  final String? hintText;

  /// ダークモードかどうか
  final bool isDarkMode;

  /// ボーダーの半径
  final double borderRadius;

  /// 最大高さ（タグ候補リスト）
  final double maxOptionsHeight;

  /// ボーダーを表示するかどうか（falseの場合は背景色のみ）
  final bool showBorder;

  /// フォーカス時のボーダー色
  final Color? focusedBorderColor;

  /// オプションリストにスクロールバーを表示するかどうか
  final bool showOptionsScrollbar;

  const TagAutocompleteField({
    super.key,
    required this.availableTags,
    required this.selectedTags,
    required this.onTagsChanged,
    this.labelText,
    this.hintText,
    this.isDarkMode = false,
    this.borderRadius = 12,
    this.maxOptionsHeight = 150,
    this.showBorder = false,
    this.focusedBorderColor,
    this.showOptionsScrollbar = true,
  });

  @override
  Widget build(BuildContext context) {
    return MultipleFreeSoloAutocomplete(
      options: availableTags,
      selectedValues: selectedTags,
      onChanged: onTagsChanged,
      labelText: labelText ?? 'タグ',
      hintText: hintText ?? '入力または選択',
      isDarkMode: isDarkMode,
      borderRadius: borderRadius,
      maxOptionsHeight: maxOptionsHeight,
      showCreateOption: true,
      createOptionLabel: (value) => '「$value」を作成',
      excludeSelectedFromOptions: true,
      showBorder: showBorder,
      focusedBorderColor: focusedBorderColor,
      showOptionsScrollbar: showOptionsScrollbar,
    );
  }
}
