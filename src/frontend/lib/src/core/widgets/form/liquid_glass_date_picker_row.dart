/// Widget: LiquidGlassDatePickerRow
///
/// Liquid Glassスタイルの日付ピッカー行
library;

import 'package:flutter/material.dart';

/// 日付ピッカー行ウィジェット
class LiquidGlassDatePickerRow extends StatelessWidget {
  /// 選択された日時
  final DateTime? value;

  /// ダークモードかどうか
  final bool isDarkMode;

  /// 日付選択タップ時のコールバック
  final VoidCallback onTap;

  /// クリアタップ時のコールバック
  final VoidCallback? onClear;

  /// プレースホルダーテキスト
  final String placeholder;

  /// アイコン
  final IconData icon;

  const LiquidGlassDatePickerRow({
    super.key,
    this.value,
    required this.isDarkMode,
    required this.onTap,
    this.onClear,
    this.placeholder = '期限を設定',
    this.icon = Icons.calendar_today,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 8, bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: isDarkMode
                ? Colors.white.withValues(alpha: 0.5)
                : Colors.black.withValues(alpha: 0.4),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isDarkMode
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.06),
              ),
              child: Text(
                value != null ? _formatDateTime(value!) : placeholder,
                style: TextStyle(
                  fontSize: 13,
                  color: value != null
                      ? (isDarkMode ? Colors.white : Colors.black87)
                      : (isDarkMode
                          ? Colors.white.withValues(alpha: 0.5)
                          : Colors.black.withValues(alpha: 0.4)),
                ),
              ),
            ),
          ),
          if (value != null && onClear != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onClear,
              child: Icon(
                Icons.close,
                size: 16,
                color: isDarkMode
                    ? Colors.white.withValues(alpha: 0.4)
                    : Colors.black.withValues(alpha: 0.3),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 日時フォーマット
  String _formatDateTime(DateTime dt) {
    final now = DateTime.now();
    final isToday = dt.year == now.year &&
        dt.month == now.month &&
        dt.day == now.day;
    final isTomorrow = dt.year == now.year &&
        dt.month == now.month &&
        dt.day == now.day + 1;

    String dateStr;
    if (isToday) {
      dateStr = '今日';
    } else if (isTomorrow) {
      dateStr = '明日';
    } else {
      dateStr = '${dt.month}/${dt.day}';
    }

    final timeStr =
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    return '$dateStr $timeStr';
  }
}

/// 日付と時刻を選択するヘルパー関数
Future<DateTime?> showLiquidGlassDateTimePicker({
  required BuildContext context,
  required bool isDarkMode,
  DateTime? initialDate,
}) async {
  final now = DateTime.now();

  final date = await showDatePicker(
    context: context,
    initialDate: initialDate ?? now,
    firstDate: now,
    lastDate: now.add(const Duration(days: 365 * 5)),
    builder: (context, child) {
      return Theme(
        data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
        child: child!,
      );
    },
  );

  if (date != null && context.mounted) {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate ?? now),
      builder: (context, child) {
        return Theme(
          data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
          child: child!,
        );
      },
    );

    if (context.mounted) {
      if (time != null) {
        return DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
      } else {
        return DateTime(
          date.year,
          date.month,
          date.day,
          23,
          59,
        );
      }
    }
  }

  return null;
}
