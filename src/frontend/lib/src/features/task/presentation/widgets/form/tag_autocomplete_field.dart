/// Widget: TagAutocompleteField
///
/// タグ入力専用のAutocompleteフィールド
/// MultipleFreeSoloAutocompleteのタグ用ラッパー
library;

import 'package:flutter/material.dart';
import 'package:tasbal/src/core/widgets/form/multiple_free_solo_autocomplete.dart';

/// タグ入力フィールド（freeSolo + multiple対応）
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

  const TagAutocompleteField({
    super.key,
    required this.availableTags,
    required this.selectedTags,
    required this.onTagsChanged,
    this.labelText,
    this.hintText,
    this.isDarkMode = false,
    this.borderRadius = 12,
    this.maxOptionsHeight = 200,
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
    );
  }
}
