/// Widget: ListItem
///
/// リストアイテム
/// タップ可能なリスト項目
library;

import 'package:flutter/material.dart';

/// リストアイテム（タップ可能）
class ListItem extends StatelessWidget {
  /// タイトル
  final String title;

  /// サブタイトル（オプション）
  final String? subtitle;

  /// 先頭アイコン
  final IconData? leadingIcon;

  /// 末尾ウィジェット（オプション）
  final Widget? trailing;

  /// タップコールバック
  final VoidCallback? onTap;

  /// ダークモードかどうか
  final bool isDarkMode;

  /// 危険なアクションかどうか（削除など）
  final bool isDanger;

  /// 水平パディング
  final double horizontalPadding;

  /// 垂直パディング
  final double verticalPadding;

  const ListItem({
    super.key,
    required this.title,
    this.subtitle,
    this.leadingIcon,
    this.trailing,
    this.onTap,
    this.isDarkMode = false,
    this.isDanger = false,
    this.horizontalPadding = 16,
    this.verticalPadding = 14,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDanger
        ? Colors.red
        : (isDarkMode
            ? Colors.white.withValues(alpha: 0.9)
            : Colors.black.withValues(alpha: 0.85));

    final subtitleColor = isDarkMode
        ? Colors.white.withValues(alpha: 0.5)
        : Colors.black.withValues(alpha: 0.45);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Row(
          children: [
            if (leadingIcon != null) ...[
              Icon(
                leadingIcon,
                size: 22,
                color: isDanger
                    ? Colors.red.withValues(alpha: 0.8)
                    : (isDarkMode
                        ? Colors.white.withValues(alpha: 0.7)
                        : Colors.black.withValues(alpha: 0.6)),
              ),
              const SizedBox(width: 14),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 13,
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null)
              trailing!
            else if (onTap != null)
              Icon(
                Icons.chevron_right,
                size: 20,
                color: isDarkMode
                    ? Colors.white.withValues(alpha: 0.4)
                    : Colors.black.withValues(alpha: 0.3),
              ),
          ],
        ),
      ),
    );
  }
}

/// スイッチ付きリストアイテム
class ListSwitchItem extends StatelessWidget {
  /// タイトル
  final String title;

  /// サブタイトル（オプション）
  final String? subtitle;

  /// 先頭アイコン
  final IconData? leadingIcon;

  /// 現在の値
  final bool value;

  /// 値変更コールバック
  final ValueChanged<bool> onChanged;

  /// ダークモードかどうか
  final bool isDarkMode;

  /// カスタムスイッチウィジェット（オプション）
  final Widget Function(bool value, ValueChanged<bool> onChanged)? switchBuilder;

  const ListSwitchItem({
    super.key,
    required this.title,
    this.subtitle,
    this.leadingIcon,
    required this.value,
    required this.onChanged,
    this.isDarkMode = false,
    this.switchBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ListItem(
      title: title,
      subtitle: subtitle,
      leadingIcon: leadingIcon,
      isDarkMode: isDarkMode,
      trailing: switchBuilder != null
          ? switchBuilder!(value, onChanged)
          : Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeTrackColor: Theme.of(context).colorScheme.primary,
            ),
      onTap: () => onChanged(!value),
    );
  }
}

/// 選択値付きリストアイテム
class ListSelectItem extends StatelessWidget {
  /// タイトル
  final String title;

  /// 現在の選択値
  final String currentValue;

  /// 先頭アイコン
  final IconData? leadingIcon;

  /// タップコールバック
  final VoidCallback? onTap;

  /// ダークモードかどうか
  final bool isDarkMode;

  const ListSelectItem({
    super.key,
    required this.title,
    required this.currentValue,
    this.leadingIcon,
    this.onTap,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListItem(
      title: title,
      leadingIcon: leadingIcon,
      isDarkMode: isDarkMode,
      onTap: onTap,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            currentValue,
            style: TextStyle(
              fontSize: 15,
              color: isDarkMode
                  ? Colors.white.withValues(alpha: 0.5)
                  : Colors.black.withValues(alpha: 0.45),
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.chevron_right,
            size: 20,
            color: isDarkMode
                ? Colors.white.withValues(alpha: 0.4)
                : Colors.black.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}
