/// Widget: OtherSection
///
/// 設定画面のその他セクション
library;

import 'package:flutter/material.dart';
import 'package:tasbal/src/features/settings/presentation/widgets/settings_section.dart';

/// その他セクション
class OtherSection extends StatelessWidget {
  /// ダークモードかどうか
  final bool isDarkMode;

  /// 通報タップ時のコールバック
  final VoidCallback? onReport;

  /// ヘルプタップ時のコールバック
  final VoidCallback? onHelp;

  /// 利用規約タップ時のコールバック
  final VoidCallback? onTerms;

  /// プライバシーポリシータップ時のコールバック
  final VoidCallback? onPrivacy;

  const OtherSection({
    super.key,
    required this.isDarkMode,
    this.onReport,
    this.onHelp,
    this.onTerms,
    this.onPrivacy,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeader(
          title: 'その他',
          icon: Icons.more_horiz,
          isDarkMode: isDarkMode,
        ),
        SettingsSectionContainer(
          isDarkMode: isDarkMode,
          children: [
            SettingsItem(
              title: '通報',
              leadingIcon: Icons.report_outlined,
              isDarkMode: isDarkMode,
              onTap: onReport,
            ),
            SettingsItem(
              title: 'ヘルプ',
              leadingIcon: Icons.help_outline,
              isDarkMode: isDarkMode,
              onTap: onHelp,
            ),
            SettingsItem(
              title: '利用規約',
              leadingIcon: Icons.description_outlined,
              isDarkMode: isDarkMode,
              onTap: onTerms,
            ),
            SettingsItem(
              title: 'プライバシーポリシー',
              leadingIcon: Icons.privacy_tip_outlined,
              isDarkMode: isDarkMode,
              onTap: onPrivacy,
            ),
          ],
        ),
      ],
    );
  }
}
