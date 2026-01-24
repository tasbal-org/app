/// Widget: LiquidGlassWheelPicker
///
/// ホイール選択ピッカー
/// iOS風のホイールから選択するボトムシート
library;

import 'package:flutter/material.dart';
import 'package:tasbal/src/core/widgets/sheet/sheet.dart';

/// ホイール選択肢
class WheelPickerOption<T> {
  /// 値
  final T value;

  /// 表示ラベル
  final String label;

  const WheelPickerOption({
    required this.value,
    required this.label,
  });
}

/// ホイール選択ピッカーを表示
///
/// [T] 選択値の型
/// [context] BuildContext
/// [title] ピッカーのタイトル
/// [options] 選択肢リスト
/// [initialValue] 初期選択値
/// [isDarkMode] ダークモードかどうか
/// [height] ピッカーの高さ（デフォルト: 320）
/// [itemExtent] アイテムの高さ（デフォルト: 44）
Future<T?> showLiquidGlassWheelPicker<T>({
  required BuildContext context,
  required String title,
  required List<WheelPickerOption<T>> options,
  required T initialValue,
  required bool isDarkMode,
  double height = 320,
  double itemExtent = 44,
}) async {
  // 初期選択インデックス
  int initialIndex = options.indexWhere((o) => o.value == initialValue);
  if (initialIndex < 0) initialIndex = 0;

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
              child: ListWheelScrollView.useDelegate(
                controller: FixedExtentScrollController(
                  initialItem: initialIndex,
                ),
                itemExtent: itemExtent,
                diameterRatio: 1.5,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (index) {
                  setModalState(() {
                    tempSelected = options[index].value;
                  });
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: options.length,
                  builder: (context, index) {
                    final option = options[index];
                    final isSelected = option.value == tempSelected;

                    return Center(
                      child: Text(
                        option.label,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected
                              ? (isDarkMode ? Colors.white : Colors.black)
                              : (isDarkMode
                                  ? Colors.white.withValues(alpha: 0.5)
                                  : Colors.black.withValues(alpha: 0.4)),
                        ),
                      ),
                    );
                  },
                ),
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
