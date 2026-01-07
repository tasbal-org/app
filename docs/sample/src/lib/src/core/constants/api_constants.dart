class ApiConstants {
	// ベースURL
	static const String baseUrl = 'https://api.yourapp.com';
	static const String devBaseUrl = 'https://localhost:7128/api/admin';

	// エンドポイント（環境非依存）
	static const String loginEndpoint = '/auth/login';
	static const String refreshEndpoint = '/auth/refresh';
	static const String logoutEndpoint = '/auth/logout';

	// クエリパラメータ
	static const String pageQuery = 'page';
	static const String limitQuery = 'limit';

	// ヘッダーキー
	static const String authHeader = 'Authorization';
	static const String apiKeyHeader = 'X-Api-Key';
	static const String webRequestHeader = 'X-Requested-With';

	// タイムアウト（環境ごとで異なる場合）
	static const int connectTimeout = 10000; // ミリ秒（本番）
	static const int devConnectTimeout = 15000; // ミリ秒（開発：長めに）
	static const int receiveTimeout = 10000;
	static const int devReceiveTimeout = 15000;
}