/// Config: Environment
///
/// 環境変数と環境依存の設定を管理
/// 開発環境と本番環境の切り替えを提供
library;

import 'package:tasbal/src/core/constants/api_constants.dart';

/// 環境設定クラス
///
/// コンパイル時の環境変数（--dart-define）を読み取り
/// 開発環境と本番環境で異なる設定を提供
class Environment {
  /// プライベートコンストラクタ（インスタンス化を防ぐ）
  Environment._();

  /// 環境名（dev, prod）
  ///
  /// --dart-define=ENV=dev でビルド時に指定
  /// デフォルトは prod
  static const String _env = String.fromEnvironment('ENV', defaultValue: 'prod');

  /// 開発環境かどうか
  static bool get isDev => _env == 'dev';

  /// 本番環境かどうか
  static bool get isProd => _env == 'prod';

  /// ベースURL（環境に応じて切り替わる）
  static String get baseUrl =>
      isDev ? ApiConstants.devBaseUrl : ApiConstants.baseUrl;

  /// 開発環境のベースURL
  static String get devBaseUrl => ApiConstants.devBaseUrl;

  /// APIバージョン
  static String get apiVersion => ApiConstants.apiVersion;

  /// 環境名を取得
  static String get environmentName => _env;
}
