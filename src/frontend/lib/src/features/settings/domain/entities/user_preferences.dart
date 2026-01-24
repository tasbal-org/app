/// Settings Domain: User Preferences Entity
///
/// ユーザー設定エンティティ
/// 設定画面で管理される各種設定を表現
library;

import 'package:equatable/equatable.dart';

/// 描画品質
enum RenderQuality {
  /// 自動（端末状態に応じて切り替え）
  auto,

  /// 通常品質
  normal,

  /// 低品質（省電力）
  low,
}

/// テーマモード
enum ThemeMode {
  /// システム設定に従う
  system,

  /// ライトモード
  light,

  /// ダークモード
  dark,
}

/// ユーザー設定エンティティ
///
/// 設定画面で管理されるすべての設定値を保持
class UserPreferences extends Equatable {
  /// 国コード（ISO 3166-1 alpha-2）
  /// 例: 'JP', 'US', null（未設定）
  final String? countryCode;

  /// 描画品質
  final RenderQuality renderQuality;

  /// 省電力時に自動でLow品質にするか
  final bool autoLowPowerMode;

  /// テーマモード
  final ThemeMode themeMode;

  /// 通知設定（将来用）
  final bool notificationsEnabled;

  const UserPreferences({
    this.countryCode,
    this.renderQuality = RenderQuality.auto,
    this.autoLowPowerMode = true,
    this.themeMode = ThemeMode.system,
    this.notificationsEnabled = false,
  });

  /// 初期設定
  factory UserPreferences.initial() => const UserPreferences();

  /// 国が設定されているか
  bool get hasCountry => countryCode != null && countryCode!.isNotEmpty;

  /// 国名を取得（表示用）
  String get countryDisplayName {
    if (countryCode == null) return '未設定';
    return _countryNames[countryCode] ?? countryCode!;
  }

  /// 描画品質の表示名
  String get renderQualityDisplayName {
    switch (renderQuality) {
      case RenderQuality.auto:
        return '自動';
      case RenderQuality.normal:
        return 'Normal';
      case RenderQuality.low:
        return 'Low';
    }
  }

  /// テーマモードの表示名
  String get themeModeDisplayName {
    switch (themeMode) {
      case ThemeMode.system:
        return 'システム設定';
      case ThemeMode.light:
        return 'ライト';
      case ThemeMode.dark:
        return 'ダーク';
    }
  }

  @override
  List<Object?> get props => [
        countryCode,
        renderQuality,
        autoLowPowerMode,
        themeMode,
        notificationsEnabled,
      ];

  /// コピーwith
  UserPreferences copyWith({
    String? countryCode,
    RenderQuality? renderQuality,
    bool? autoLowPowerMode,
    ThemeMode? themeMode,
    bool? notificationsEnabled,
    bool clearCountryCode = false,
  }) {
    return UserPreferences(
      countryCode: clearCountryCode ? null : (countryCode ?? this.countryCode),
      renderQuality: renderQuality ?? this.renderQuality,
      autoLowPowerMode: autoLowPowerMode ?? this.autoLowPowerMode,
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  /// 国コードと国名のマッピング（主要国のみ）
  static const Map<String, String> _countryNames = {
    'JP': '日本',
    'US': 'アメリカ',
    'GB': 'イギリス',
    'DE': 'ドイツ',
    'FR': 'フランス',
    'IT': 'イタリア',
    'ES': 'スペイン',
    'CN': '中国',
    'KR': '韓国',
    'TW': '台湾',
    'AU': 'オーストラリア',
    'CA': 'カナダ',
    'BR': 'ブラジル',
    'IN': 'インド',
    'RU': 'ロシア',
  };

  /// 利用可能な国リスト
  static List<MapEntry<String, String>> get availableCountries {
    return _countryNames.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
  }
}
