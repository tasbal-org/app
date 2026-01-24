/// Widget: SettingsSection
///
/// 設定セクション用ウィジェット
/// coreのリストコンポーネントを設定画面用にre-export
library;

import 'package:flutter/material.dart';
import 'package:flutter_liquid_glass_plus/buttons/liquid_glass_switch.dart';
import 'package:tasbal/src/core/widgets/list/list.dart';

// coreコンポーネントを設定画面用にre-export
export 'package:tasbal/src/core/widgets/list/list.dart';

/// 設定セクションヘッダー（後方互換性のため）
typedef SettingsSectionHeader = ListSectionHeader;

/// 設定セクションコンテナ（後方互換性のため）
typedef SettingsSectionContainer = LiquidGlassListSection;

/// 設定アイテム（後方互換性のため）
typedef SettingsItem = ListItem;

/// 設定選択アイテム（後方互換性のため）
typedef SettingsSelectItem = ListSelectItem;

/// 設定スイッチアイテム（LGSwitch使用）
class SettingsSwitchItem extends StatelessWidget {
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

  const SettingsSwitchItem({
    super.key,
    required this.title,
    this.subtitle,
    this.leadingIcon,
    required this.value,
    required this.onChanged,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListSwitchItem(
      title: title,
      subtitle: subtitle,
      leadingIcon: leadingIcon,
      value: value,
      onChanged: onChanged,
      isDarkMode: isDarkMode,
      switchBuilder: (value, onChanged) => LGSwitch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).colorScheme.primary,
        useOwnLayer: true,
      ),
    );
  }
}
