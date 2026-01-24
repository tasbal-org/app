/// Widget: LiquidGlassListPicker
///
/// リスト選択ピッカー
/// アイコン付きリストから選択するボトムシート
library;

import 'package:flutter/material.dart';
import 'package:tasbal/src/core/widgets/sheet/sheet.dart';

/// リスト選択肢
class ListPickerOption<T> {
  /// 値
  final T value;

  /// 表示ラベル
  final String label;

  /// サブタイトル（オプション）
  final String? subtitle;

  /// アイコン（オプション）
  final IconData? icon;

  const ListPickerOption({
    required this.value,
    required this.label,
    this.subtitle,
    this.icon,
  });
}

/// リスト選択ピッカーを表示
///
/// [T] 選択値の型
/// [context] BuildContext
/// [title] ピッカーのタイトル
/// [options] 選択肢リスト
/// [initialValue] 初期選択値
/// [isDarkMode] ダークモードかどうか
/// [height] ピッカーの高さ（デフォルト: 320）
Future<T?> showLiquidGlassListPicker<T>({
  required BuildContext context,
  required String title,
  required List<ListPickerOption<T>> options,
  required T initialValue,
  required bool isDarkMode,
  double height = 320,
}) async {
  T tempSelected = initialValue;

  final result = await showLiquidGlassBottomSheet<T>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setModalState) => LiquidGlassBottomSheet(
        isDarkMode: isDarkMode,
        height: height,
        child: Column(
          children: [
            LiquidGlassPickerHeader(
              title: title,
              isDarkMode: isDarkMode,
              onCancel: () => Navigator.pop(context),
              onDone: () => Navigator.pop(context, tempSelected),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options[index];
                  final isSelected = option.value == tempSelected;

                  return ListTile(
                    leading: option.icon != null ? Icon(option.icon) : null,
                    title: Text(option.label),
                    subtitle:
                        option.subtitle != null ? Text(option.subtitle!) : null,
                    selected: isSelected,
                    onTap: () {
                      setModalState(() {
                        tempSelected = option.value;
                      });
                    },
                    trailing: isSelected
                        ? Icon(
                            Icons.check,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    ),
  );

  return result;
}
