/// Widget: LocationSection
///
/// 設定画面のロケーションセクション
library;

import 'package:flutter/material.dart';
import 'package:tasbal/src/core/widgets/picker/picker.dart';
import 'package:tasbal/src/features/settings/domain/entities/user_preferences.dart';
import 'package:tasbal/src/features/settings/presentation/widgets/settings_section.dart';

/// ロケーションセクション
class LocationSection extends StatelessWidget {
  /// 現在の設定
  final UserPreferences preferences;

  /// ダークモードかどうか
  final bool isDarkMode;

  /// 国コード変更時のコールバック
  final ValueChanged<String?> onCountryCodeChanged;

  /// 位置情報から提案タップ時のコールバック
  final VoidCallback? onSuggestFromLocation;

  const LocationSection({
    super.key,
    required this.preferences,
    required this.isDarkMode,
    required this.onCountryCodeChanged,
    this.onSuggestFromLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeader(
          title: 'ロケーション',
          icon: Icons.location_on_outlined,
          isDarkMode: isDarkMode,
        ),
        SettingsSectionContainer(
          isDarkMode: isDarkMode,
          children: [
            SettingsSelectItem(
              title: '国',
              currentValue: preferences.countryDisplayName,
              leadingIcon: Icons.flag_outlined,
              isDarkMode: isDarkMode,
              onTap: () => _showCountryPicker(context),
            ),
            SettingsItem(
              title: '現在地から提案',
              leadingIcon: Icons.my_location_outlined,
              isDarkMode: isDarkMode,
              onTap: onSuggestFromLocation,
            ),
          ],
        ),
      ],
    );
  }

  void _showCountryPicker(BuildContext context) async {
    final options = [
      const WheelPickerOption<String?>(value: null, label: '未設定'),
      ...UserPreferences.availableCountries.map(
        (e) => WheelPickerOption<String?>(value: e.key, label: e.value),
      ),
    ];

    final result = await showLiquidGlassWheelPicker<String?>(
      context: context,
      title: '国を選択',
      options: options,
      initialValue: preferences.countryCode,
      isDarkMode: isDarkMode,
    );

    if (result != null || result != preferences.countryCode) {
      onCountryCodeChanged(result);
    }
  }
}
