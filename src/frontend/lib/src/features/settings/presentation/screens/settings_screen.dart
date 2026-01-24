/// Settings Screen
///
/// 設定画面
/// 設計書に基づく1画面完結型の設定UI
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tasbal/src/core/di/injection.dart';
import 'package:tasbal/src/features/settings/domain/entities/user_preferences.dart'
    as prefs;
import 'package:tasbal/src/features/settings/domain/use_cases/get_preferences_use_case.dart';
import 'package:tasbal/src/features/settings/domain/use_cases/update_preferences_use_case.dart';
import 'package:tasbal/src/features/settings/presentation/redux/settings_actions.dart';
import 'package:tasbal/src/features/settings/presentation/redux/settings_thunks.dart';
import 'package:tasbal/src/features/settings/presentation/widgets/sections/sections.dart';
import 'package:tasbal/src/redux/app_state.dart';

/// 設定画面コンテンツ（AppShell内で使用）
class SettingsScreenContent extends StatefulWidget {
  /// ダークモード
  final bool isDarkMode;

  const SettingsScreenContent({
    super.key,
    this.isDarkMode = false,
  });

  @override
  State<SettingsScreenContent> createState() => _SettingsScreenContentState();
}

class _SettingsScreenContentState extends State<SettingsScreenContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSettings();
    });
  }

  void _loadSettings() {
    final store = StoreProvider.of<AppState>(context, listen: false);

    if (kDebugMode) {
      store.dispatch(
          LoadSettingsSuccessAction(prefs.UserPreferences.initial()));
      return;
    }

    final useCase = sl<GetPreferencesUseCase>();
    store.dispatch(loadSettingsThunk(useCase: useCase));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, prefs.UserPreferences>(
      converter: (store) => store.state.settingsState.preferences,
      builder: (context, preferences) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ロケーション
            LocationSection(
              preferences: preferences,
              isDarkMode: widget.isDarkMode,
              onCountryCodeChanged: _updateCountryCode,
              onSuggestFromLocation: _suggestFromLocation,
            ),

            // 表示
            DisplaySection(
              preferences: preferences,
              isDarkMode: widget.isDarkMode,
              onThemeModeChanged: _updateThemeMode,
              onRenderQualityChanged: _updateRenderQuality,
              onAutoLowPowerModeChanged: _updateAutoLowPowerMode,
            ),

            // 深呼吸
            BreathingSection(isDarkMode: widget.isDarkMode),

            // アカウント
            AccountSection(
              isDarkMode: widget.isDarkMode,
              onLinkWithApple: _linkWithApple,
              onLinkWithGoogle: _linkWithGoogle,
            ),

            // その他
            OtherSection(
              isDarkMode: widget.isDarkMode,
              onReport: _showReport,
              onHelp: _showHelp,
              onTerms: _showTerms,
              onPrivacy: _showPrivacy,
            ),

            // バージョン情報
            _buildVersionInfo(),
          ],
        );
      },
    );
  }

  Widget _buildVersionInfo() {
    return Column(
      children: [
        const SizedBox(height: 24),
        Center(
          child: Text(
            'Tasbal v1.0.0',
            style: TextStyle(
              fontSize: 12,
              color: widget.isDarkMode
                  ? Colors.white.withValues(alpha: 0.4)
                  : Colors.black.withValues(alpha: 0.3),
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  // ============================================================
  // 更新アクション
  // ============================================================

  void _updateCountryCode(String? countryCode) {
    final store = StoreProvider.of<AppState>(context, listen: false);

    if (kDebugMode) {
      store.dispatch(UpdateCountryCodeAction(countryCode));
      return;
    }

    final useCase = sl<UpdatePreferencesUseCase>();
    store.dispatch(updateCountryCodeThunk(
      useCase: useCase,
      countryCode: countryCode,
    ));
  }

  void _updateThemeMode(prefs.ThemeMode mode) {
    final store = StoreProvider.of<AppState>(context, listen: false);

    if (kDebugMode) {
      store.dispatch(UpdateThemeModeAction(mode));
      return;
    }

    final useCase = sl<UpdatePreferencesUseCase>();
    store.dispatch(updateThemeModeThunk(
      useCase: useCase,
      mode: mode,
    ));
  }

  void _updateRenderQuality(prefs.RenderQuality quality) {
    final store = StoreProvider.of<AppState>(context, listen: false);

    if (kDebugMode) {
      store.dispatch(UpdateRenderQualityAction(quality));
      return;
    }

    final useCase = sl<UpdatePreferencesUseCase>();
    store.dispatch(updateRenderQualityThunk(
      useCase: useCase,
      quality: quality,
    ));
  }

  void _updateAutoLowPowerMode(bool enabled) {
    final store = StoreProvider.of<AppState>(context, listen: false);

    if (kDebugMode) {
      store.dispatch(UpdateAutoLowPowerModeAction(enabled));
      return;
    }

    final useCase = sl<UpdatePreferencesUseCase>();
    store.dispatch(updateAutoLowPowerModeThunk(
      useCase: useCase,
      enabled: enabled,
    ));
  }

  // ============================================================
  // 未実装アクション
  // ============================================================

  void _suggestFromLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('位置情報機能は未実装です')),
    );
  }

  void _linkWithApple() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Apple連携は未実装です')),
    );
  }

  void _linkWithGoogle() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google連携は未実装です')),
    );
  }

  void _showReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('通報機能は未実装です')),
    );
  }

  void _showHelp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ヘルプは未実装です')),
    );
  }

  void _showTerms() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('利用規約は未実装です')),
    );
  }

  void _showPrivacy() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('プライバシーポリシーは未実装です')),
    );
  }
}
