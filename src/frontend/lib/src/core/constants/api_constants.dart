/// Core Constants: API
///
/// API通信に関連する定数を一元管理
/// エンドポイント、タイムアウト、ヘッダー名等を定義
library;

/// API定数クラス
///
/// すべての定数はstaticで定義し、インスタンス化を防ぐ
class ApiConstants {
  /// プライベートコンストラクタ（インスタンス化を防ぐ）
  ApiConstants._();

  // ============================================================
  // Base URLs
  // ============================================================

  /// 本番環境のベースURL
  static const String baseUrl = 'https://api.tasbal.app';

  /// 開発環境のベースURL
  static const String devBaseUrl = 'http://localhost:3000';

  // ============================================================
  // API Version
  // ============================================================

  /// APIバージョン（すべてのエンドポイントに付与される）
  static const String apiVersion = '/api/v1';

  // ============================================================
  // Timeout設定
  // ============================================================

  /// 接続タイムアウト（ミリ秒）
  static const int connectTimeout = 30000; // 30秒

  /// 受信タイムアウト（ミリ秒）
  static const int receiveTimeout = 30000; // 30秒

  // ============================================================
  // Endpoints - 認証
  // ============================================================

  /// ゲスト認証（匿名ログイン）
  static const String guestAuthEndpoint = '/auth/guest';

  /// トークンリフレッシュ
  static const String refreshTokenEndpoint = '/auth/refresh';

  // ============================================================
  // Endpoints - デバイス
  // ============================================================

  /// デバイス登録（初回起動時）
  static const String devicesRegisterEndpoint = '/devices/register';

  // ============================================================
  // Endpoints - ユーザー
  // ============================================================

  /// 自分の情報取得
  static const String meEndpoint = '/me';

  /// ユーザー設定の取得・更新
  static const String meSettingsEndpoint = '/me/settings';

  /// 選択中の風船の取得・設定
  static const String meBalloonSelectionEndpoint = '/me/balloon-selection';

  // ============================================================
  // Endpoints - タスク
  // ============================================================

  /// タスク一覧取得・作成
  static const String tasksEndpoint = '/tasks';

  // ============================================================
  // Endpoints - 風船
  // ============================================================

  /// 風船の作成・取得
  static const String balloonsEndpoint = '/balloons';

  /// 公開風船一覧の取得
  static const String publicBalloonsEndpoint = '/balloons/public';

  // ============================================================
  // Endpoints - ゲリライベント
  // ============================================================

  /// 現在開催中のゲリライベント取得
  static const String activeGuerrillaEventsEndpoint = '/guerrilla-events/active';

  // ============================================================
  // HTTPヘッダー名
  // ============================================================

  /// 認証トークンヘッダー（Bearer トークン）
  static const String authorizationHeader = 'Authorization';

  /// デバイス識別キーヘッダー（ゲストユーザー含む）
  static const String deviceKeyHeader = 'X-Device-Key';

  /// 冪等性キーヘッダー（POST系操作の重複防止）
  static const String idempotencyKeyHeader = 'Idempotency-Key';
}
