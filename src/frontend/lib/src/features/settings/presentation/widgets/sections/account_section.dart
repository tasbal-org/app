/// Widget: AccountSection
///
/// 設定画面のアカウントセクション
library;

import 'package:flutter/material.dart';
import 'package:tasbal/src/features/settings/presentation/widgets/settings_section.dart';

/// アカウントセクション
class AccountSection extends StatelessWidget {
  /// ダークモードかどうか
  final bool isDarkMode;

  /// Apple連携タップ時のコールバック
  final VoidCallback? onLinkWithApple;

  /// Google連携タップ時のコールバック
  final VoidCallback? onLinkWithGoogle;

  const AccountSection({
    super.key,
    required this.isDarkMode,
    this.onLinkWithApple,
    this.onLinkWithGoogle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeader(
          title: 'アカウント',
          icon: Icons.person_outline,
          isDarkMode: isDarkMode,
        ),
        SettingsSectionContainer(
          isDarkMode: isDarkMode,
          children: [
            SettingsItem(
              title: '現在の状態',
              subtitle: 'ゲスト',
              leadingIcon: Icons.badge_outlined,
              isDarkMode: isDarkMode,
              onTap: null,
            ),
            SettingsItem(
              title: 'Appleで連携',
              leadingIcon: Icons.apple,
              isDarkMode: isDarkMode,
              onTap: onLinkWithApple,
            ),
            SettingsItem(
              title: 'Googleで連携',
              leadingIcon: Icons.g_mobiledata,
              isDarkMode: isDarkMode,
              onTap: onLinkWithGoogle,
            ),
          ],
        ),
      ],
    );
  }
}
