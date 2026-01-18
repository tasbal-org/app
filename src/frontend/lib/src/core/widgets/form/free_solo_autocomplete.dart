/// Widget: FreeSoloAutocomplete
///
/// MUI Autocomplete（freeSoloモード）を参考にした自由入力可能なAutocomplete
/// 既存の選択肢から選ぶか、新しい値を自由に入力できる
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// FreeSolo Autocomplete コンポーネント
///
/// MUIのAutocomplete freeSoloモードを参考にした実装
/// - 既存の選択肢から選択可能
/// - 選択肢にない新しい値も自由に入力可能
/// - 入力に応じてフィルタリング
/// - ダークモード対応
class FreeSoloAutocomplete extends StatefulWidget {
  /// 選択肢のリスト
  final List<String> options;

  /// 値が選択/入力されたときのコールバック
  final ValueChanged<String> onSelected;

  /// ヒントテキスト
  final String? hintText;

  /// ラベルテキスト
  final String? labelText;

  /// 初期値
  final String? initialValue;

  /// ダークモードかどうか
  final bool isDarkMode;

  /// 自動フォーカス
  final bool autofocus;

  /// テキストフィールドのコントローラー（外部から制御する場合）
  final TextEditingController? controller;

  /// フォーカスノード（外部から制御する場合）
  final FocusNode? focusNode;

  /// 入力フィールドのスタイル
  final TextStyle? textStyle;

  /// ボーダーの半径
  final double borderRadius;

  /// 選択肢に「新規作成」オプションを表示するかどうか
  final bool showCreateOption;

  /// 新規作成時のラベルフォーマッタ
  final String Function(String value)? createOptionLabel;

  const FreeSoloAutocomplete({
    super.key,
    required this.options,
    required this.onSelected,
    this.hintText,
    this.labelText,
    this.initialValue,
    this.isDarkMode = false,
    this.autofocus = false,
    this.controller,
    this.focusNode,
    this.textStyle,
    this.borderRadius = 10,
    this.showCreateOption = true,
    this.createOptionLabel,
  });

  @override
  State<FreeSoloAutocomplete> createState() => _FreeSoloAutocompleteState();
}

class _FreeSoloAutocompleteState extends State<FreeSoloAutocomplete> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isOwnController = false;
  bool _isOwnFocusNode = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController(text: widget.initialValue);
      _isOwnController = true;
    }

    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
      _isOwnFocusNode = true;
    }
  }

  @override
  void dispose() {
    if (_isOwnController) {
      _controller.dispose();
    }
    if (_isOwnFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  /// 入力値に基づいてフィルタリングされた選択肢を取得
  List<String> _getFilteredOptions(String inputValue) {
    final input = inputValue.toLowerCase().trim();
    if (input.isEmpty) {
      return widget.options;
    }

    return widget.options
        .where((option) => option.toLowerCase().contains(input))
        .toList();
  }

  /// 新規作成オプションのラベルを取得
  String _getCreateOptionLabel(String value) {
    if (widget.createOptionLabel != null) {
      return widget.createOptionLabel!(value);
    }
    return '「$value」を作成';
  }

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<String>(
      textEditingController: _controller,
      focusNode: _focusNode,
      optionsBuilder: (textEditingValue) {
        final filtered = _getFilteredOptions(textEditingValue.text);
        final inputText = textEditingValue.text.trim();

        // freeSolo: 入力値が選択肢に完全一致しない場合、新規作成オプションを追加
        if (widget.showCreateOption &&
            inputText.isNotEmpty &&
            !widget.options
                .any((o) => o.toLowerCase() == inputText.toLowerCase())) {
          return [...filtered, inputText];
        }

        return filtered;
      },
      displayStringForOption: (option) => option,
      onSelected: (selection) {
        HapticFeedback.selectionClick();
        widget.onSelected(selection);
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          autofocus: widget.autofocus,
          style: widget.textStyle ??
              TextStyle(
                color: widget.isDarkMode ? Colors.white : Colors.black87,
              ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            labelText: widget.labelText,
            hintStyle: TextStyle(
              color: widget.isDarkMode
                  ? Colors.white.withValues(alpha: 0.4)
                  : Colors.black.withValues(alpha: 0.4),
            ),
            labelStyle: TextStyle(
              color: widget.isDarkMode
                  ? Colors.white.withValues(alpha: 0.6)
                  : Colors.black.withValues(alpha: 0.6),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                color: widget.isDarkMode
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.1),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                color: widget.isDarkMode
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(
                color: Color(0xFF007AFF),
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              widget.onSelected(value.trim());
            }
            onFieldSubmitted();
          },
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        final inputText = _controller.text.trim();
        final isNewValue = widget.showCreateOption &&
            inputText.isNotEmpty &&
            !widget.options
                .any((o) => o.toLowerCase() == inputText.toLowerCase());

        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            color: widget.isDarkMode
                ? const Color(0xFF2C2C2E)
                : Colors.white,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  final isCreateOption = isNewValue && option == inputText;

                  return InkWell(
                    onTap: () => onSelected(option),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: index < options.length - 1
                            ? Border(
                                bottom: BorderSide(
                                  color: widget.isDarkMode
                                      ? Colors.white.withValues(alpha: 0.1)
                                      : Colors.black.withValues(alpha: 0.05),
                                ),
                              )
                            : null,
                      ),
                      child: Row(
                        children: [
                          if (isCreateOption) ...[
                            Icon(
                              Icons.add,
                              size: 18,
                              color: const Color(0xFF007AFF),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _getCreateOptionLabel(option),
                              style: TextStyle(
                                color: const Color(0xFF007AFF),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ] else ...[
                            Icon(
                              Icons.label_outline,
                              size: 18,
                              color: widget.isDarkMode
                                  ? Colors.white.withValues(alpha: 0.5)
                                  : Colors.black.withValues(alpha: 0.4),
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
      },
    );
  }

  /// 検索テキストをハイライト表示
  Widget _buildHighlightedText(String text, String query) {
    if (query.isEmpty) {
      return Text(
        text,
        style: TextStyle(
          color: widget.isDarkMode ? Colors.white : Colors.black87,
        ),
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final startIndex = lowerText.indexOf(lowerQuery);

    if (startIndex == -1) {
      return Text(
        text,
        style: TextStyle(
          color: widget.isDarkMode ? Colors.white : Colors.black87,
        ),
      );
    }

    final endIndex = startIndex + query.length;
    final beforeMatch = text.substring(0, startIndex);
    final match = text.substring(startIndex, endIndex);
    final afterMatch = text.substring(endIndex);

    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: widget.isDarkMode ? Colors.white : Colors.black87,
        ),
        children: [
          TextSpan(text: beforeMatch),
          TextSpan(
            text: match,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF007AFF),
            ),
          ),
          TextSpan(text: afterMatch),
        ],
      ),
    );
  }
}
