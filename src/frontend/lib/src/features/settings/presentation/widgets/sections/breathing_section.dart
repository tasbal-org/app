/// Widget: BreathingSection
///
/// 設定画面の深呼吸セクション
library;

import 'package:flutter/material.dart';
import 'package:tasbal/src/features/settings/presentation/widgets/settings_section.dart';

/// 深呼吸セクション
class BreathingSection extends StatelessWidget {
  /// ダークモードかどうか
  final bool isDarkMode;

  const BreathingSection({
    super.key,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeader(
          title: '深呼吸',
          icon: Icons.air_outlined,
          isDarkMode: isDarkMode,
        ),
        SettingsSectionContainer(
          isDarkMode: isDarkMode,
          children: [
            SettingsItem(
              title: '深呼吸について',
              subtitle: 'タスクと同じように、深呼吸も一歩になります',
              leadingIcon: Icons.info_outline,
              isDarkMode: isDarkMode,
              onTap: null,
            ),
          ],
        ),
      ],
    );
  }
}
