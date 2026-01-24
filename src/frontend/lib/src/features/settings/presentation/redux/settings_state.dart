/// Settings Redux: State
///
/// 設定機能のRedux状態
library;

import 'package:equatable/equatable.dart';
import 'package:tasbal/src/features/settings/domain/entities/user_preferences.dart';

/// 設定状態
///
/// 設定画面の状態を管理
class SettingsState extends Equatable {
  /// ユーザー設定
  final UserPreferences preferences;

  /// 読み込み中フラグ
  final bool isLoading;

  /// 保存中フラグ
  final bool isSaving;

  /// エラーメッセージ
  final String? errorMessage;

  const SettingsState({
    required this.preferences,
    this.isLoading = false,
    this.isSaving = false,
    this.errorMessage,
  });

  /// 初期状態
  factory SettingsState.initial() {
    return SettingsState(
      preferences: UserPreferences.initial(),
    );
  }

  /// ダークモードかどうか（システム設定を考慮）
  ///
  /// [platformBrightness] システムのBrightness
  bool isDarkMode(bool platformIsDark) {
    switch (preferences.themeMode) {
      case ThemeMode.system:
        return platformIsDark;
      case ThemeMode.light:
        return false;
      case ThemeMode.dark:
        return true;
    }
  }

  @override
  List<Object?> get props => [
        preferences,
        isLoading,
        isSaving,
        errorMessage,
      ];

  /// コピーwith
  SettingsState copyWith({
    UserPreferences? preferences,
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SettingsState(
      preferences: preferences ?? this.preferences,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
