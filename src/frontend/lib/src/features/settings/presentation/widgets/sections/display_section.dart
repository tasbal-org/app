/// Widget: DisplaySection
///
/// 設定画面の表示セクション
library;

import 'package:flutter/material.dart';
import 'package:tasbal/src/core/widgets/picker/picker.dart';
import 'package:tasbal/src/features/settings/domain/entities/user_preferences.dart'
    as prefs;
import 'package:tasbal/src/features/settings/presentation/widgets/settings_section.dart';

/// 表示セクション
class DisplaySection extends StatelessWidget {
  /// 現在の設定
  final prefs.UserPreferences preferences;

  /// ダークモードかどうか
  final bool isDarkMode;

  /// テーマモード変更時のコールバック
  final ValueChanged<prefs.ThemeMode> onThemeModeChanged;

  /// 描画品質変更時のコールバック
  final ValueChanged<prefs.RenderQuality> onRenderQualityChanged;

  /// 省電力モード変更時のコールバック
  final ValueChanged<bool> onAutoLowPowerModeChanged;

  const DisplaySection({
    super.key,
    required this.preferences,
    required this.isDarkMode,
    required this.onThemeModeChanged,
    required this.onRenderQualityChanged,
    required this.onAutoLowPowerModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeader(
          title: '表示',
          icon: Icons.palette_outlined,
          isDarkMode: isDarkMode,
        ),
        SettingsSectionContainer(
          isDarkMode: isDarkMode,
          children: [
            SettingsSelectItem(
              title: 'テーマ',
              currentValue: preferences.themeModeDisplayName,
              leadingIcon: Icons.brightness_6_outlined,
              isDarkMode: isDarkMode,
              onTap: () => _showThemeModePicker(context),
            ),
            SettingsSelectItem(
              title: '描画品質',
              currentValue: preferences.renderQualityDisplayName,
              leadingIcon: Icons.speed_outlined,
              isDarkMode: isDarkMode,
              onTap: () => _showRenderQualityPicker(context),
            ),
            SettingsSwitchItem(
              title: '省電力時は自動でLow',
              leadingIcon: Icons.battery_saver_outlined,
              value: preferences.autoLowPowerMode,
              isDarkMode: isDarkMode,
              onChanged: onAutoLowPowerModeChanged,
            ),
          ],
        ),
      ],
    );
  }

  void _showThemeModePicker(BuildContext context) async {
    final options = [
      ListPickerOption<prefs.ThemeMode>(
        value: prefs.ThemeMode.system,
        label: 'システム設定',
        icon: Icons.settings_suggest_outlined,
      ),
      ListPickerOption<prefs.ThemeMode>(
        value: prefs.ThemeMode.light,
        label: 'ライト',
        icon: Icons.light_mode_outlined,
      ),
      ListPickerOption<prefs.ThemeMode>(
        value: prefs.ThemeMode.dark,
        label: 'ダーク',
        icon: Icons.dark_mode_outlined,
      ),
    ];

    final result = await showLiquidGlassListPicker<prefs.ThemeMode>(
      context: context,
      title: 'テーマを選択',
      options: options,
      initialValue: preferences.themeMode,
      isDarkMode: isDarkMode,
    );

    if (result != null && result != preferences.themeMode) {
      onThemeModeChanged(result);
    }
  }

  void _showRenderQualityPicker(BuildContext context) async {
    final options = [
      ListPickerOption<prefs.RenderQuality>(
        value: prefs.RenderQuality.auto,
        label: '自動',
        subtitle: '端末状態に応じて自動切り替え',
        icon: Icons.auto_awesome_outlined,
      ),
      ListPickerOption<prefs.RenderQuality>(
        value: prefs.RenderQuality.normal,
        label: 'Normal',
        subtitle: '風船14個、ブラーON',
        icon: Icons.high_quality_outlined,
      ),
      ListPickerOption<prefs.RenderQuality>(
        value: prefs.RenderQuality.low,
        label: 'Low',
        subtitle: '風船10個、ブラーOFF',
        icon: Icons.battery_saver_outlined,
      ),
    ];

    final result = await showLiquidGlassListPicker<prefs.RenderQuality>(
      context: context,
      title: '描画品質を選択',
      options: options,
      initialValue: preferences.renderQuality,
      isDarkMode: isDarkMode,
      height: 380,
    );

    if (result != null && result != preferences.renderQuality) {
      onRenderQualityChanged(result);
    }
  }
}
