import 'package:qrino_admin/src/core/constants/api_constants.dart';

class Environment {
	static const String _env = String.fromEnvironment('ENV', defaultValue: 'prod');

	static bool get isDev => _env == 'dev';
	static bool get isProd => _env == 'prod';

	// 環境ごとの設定
	static String get baseUrl {
		return isDev
			? ApiConstants.devBaseUrl
			: ApiConstants.baseUrl;
	}

	// ログレベルの設定（例：開発環境では詳細ログ）
	static bool get enableDetailedLogging => isDev;
}