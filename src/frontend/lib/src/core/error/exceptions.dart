/// Core Error: Exceptions
///
/// Data層で発生する例外クラス群
/// 外部システム（API、ローカルストレージ等）との通信時に発生するエラーを表現
/// これらの例外はRepository層でFailureに変換される
library;

/// サーバーAPI呼び出し時に発生する例外
///
/// HTTP通信エラー、API応答エラー等を表現
/// statusCodeにはHTTPステータスコード（400, 500等）が格納される
class ServerException implements Exception {
  /// エラーメッセージ
  final String message;

  /// HTTPステータスコード（任意）
  final int? statusCode;

  ServerException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'ServerException: $message (status: $statusCode)';
}

/// 認証・認可エラー時に発生する例外
///
/// トークン期限切れ、権限不足等を表現
/// HTTP 401, 403エラーに対応
class UnauthorizedException implements Exception {
  /// エラーメッセージ
  final String message;

  UnauthorizedException({this.message = '認証が必要です'});

  @override
  String toString() => 'UnauthorizedException: $message';
}

/// ローカルストレージ（Hive等）操作時に発生する例外
///
/// データ読み書き失敗、シリアライズエラー等を表現
class CacheException implements Exception {
  /// エラーメッセージ
  final String message;

  CacheException({required this.message});

  @override
  String toString() => 'CacheException: $message';
}

/// ネットワーク接続エラー時に発生する例外
///
/// インターネット未接続、タイムアウト等を表現
class NetworkException implements Exception {
  /// エラーメッセージ
  final String message;

  NetworkException({this.message = 'ネットワークエラーが発生しました'});

  @override
  String toString() => 'NetworkException: $message';
}
