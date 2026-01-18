/// Widget: LiquidGlassInlineTagField
///
/// Liquid Glassスタイルのインラインタグ入力フィールド
/// ダイアログを使わずに直接タグを入力・選択できる
library;

import 'package:flutter/material.dart';
import 'package:tasbal/src/core/widgets/form/multiple_free_solo_autocomplete.dart';

/// インラインタグ入力フィールド
///
/// ダイアログを使用せず、直接タグを入力・選択できるウィジェット
/// - MultipleFreeSoloAutocompleteを内部で使用
/// - コンパクトなデザイン
/// - タスク作成シート内で使用
class LiquidGlassInlineTagField extends StatelessWidget {
  /// 選択済みタグリスト
  final List<String> tags;

  /// 利用可能なタグリスト（サジェスト用）
  final List<String> availableTags;

  /// タグ変更時のコールバック
  final ValueChanged<List<String>> onTagsChanged;

  /// ダークモードかどうか
  final bool isDarkMode;

  /// ラベルテキスト
  final String? labelText;

  /// ヒントテキスト
  final String? hintText;

  const LiquidGlassInlineTagField({
    super.key,
    required this.tags,
    required this.availableTags,
    required this.onTagsChanged,
    required this.isDarkMode,
    this.labelText,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      child: MultipleFreeSoloAutocomplete(
        options: availableTags,
        selectedValues: tags,
        onChanged: onTagsChanged,
        labelText: labelText ?? 'タグ',
        hintText: hintText ?? 'タグを入力または選択',
        isDarkMode: isDarkMode,
        borderRadius: 10,
        maxOptionsHeight: 150,
        showCreateOption: true,
        createOptionLabel: (value) => '「$value」を作成',
      ),
    );
  }
}
