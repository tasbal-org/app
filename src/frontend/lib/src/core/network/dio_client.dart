/// Core Network: Dio Client
///
/// DioベースのHTTPクライアント
/// 認証ヘッダー、インターセプター、エラーハンドリング等を設定
library;

import 'package:dio/dio.dart';
import 'package:tasbal/src/core/constants/api_constants.dart';
import 'package:tasbal/src/core/error/exceptions.dart';

/// HTTPクライアントクラス
///
/// Dioインスタンスをラップし、共通設定を適用
/// シングルトンではなく、DIコンテナで管理される
class DioClient {
  /// Dioインスタンス
  late final Dio _dio;

  /// Dioインスタンスへのアクセッサ
  Dio get instance => _dio;

  /// コンストラクタ
  ///
  /// ベースURL、タイムアウト、インターセプターを設定
  DioClient({String? baseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? ApiConstants.baseUrl + ApiConstants.apiVersion,
        connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeout),
        receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json',
        },
      ),
    );

    // インターセプターを追加
    _dio.interceptors.add(_createInterceptor());
  }

  /// インターセプター作成
  ///
  /// リクエスト/レスポンス/エラーの各フェーズで処理を挿入
  InterceptorsWrapper _createInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        // リクエスト送信前の処理
        // ログ出力等をここで行う
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // レスポンス受信時の処理
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        // エラー時の処理
        // 401エラー時の自動トークンリフレッシュ等をここで実装
        return handler.next(e);
      },
    );
  }

  /// DioExceptionをアプリケーション例外に変換
  ///
  /// HTTP通信エラーを適切な例外クラスにマッピング
  Exception handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(message: 'タイムアウトしました');

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['error']?['message'] as String? ??
            'サーバーエラーが発生しました';

        if (statusCode == 401 || statusCode == 403) {
          return UnauthorizedException(message: message);
        }
        return ServerException(message: message, statusCode: statusCode);

      case DioExceptionType.cancel:
        return ServerException(message: 'リクエストがキャンセルされました');

      case DioExceptionType.connectionError:
        return NetworkException(message: 'ネットワーク接続に失敗しました');

      case DioExceptionType.unknown:
      default:
        return ServerException(
          message: e.message ?? '不明なエラーが発生しました',
        );
    }
  }
}
