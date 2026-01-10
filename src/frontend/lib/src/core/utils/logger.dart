/// Core Utils: Logger
///
/// アプリケーション全体で使用するロギングユーティリティ
/// loggingパッケージをラップして使いやすくする
library;

import 'package:logging/logging.dart';

/// ロガークラス
///
/// 名前付きロガーインスタンスを提供
/// レベル別のログ出力をサポート
class AppLogger {
  /// プライベートコンストラクタ（インスタンス化を防ぐ）
  AppLogger._();

  /// ロガーの初期化
  ///
  /// アプリケーション起動時に1度だけ呼び出す
  /// ログレベルと出力フォーマットを設定
  static void init({Level level = Level.INFO}) {
    Logger.root.level = level;
    Logger.root.onRecord.listen((record) {
      // ログフォーマット: [レベル] 時刻 - 名前: メッセージ
      print(
        '[${record.level.name}] ${record.time} - ${record.loggerName}: ${record.message}',
      );

      // エラーがある場合はスタックトレースも出力
      if (record.error != null) {
        print('Error: ${record.error}');
      }
      if (record.stackTrace != null) {
        print('StackTrace: ${record.stackTrace}');
      }
    });
  }

  /// 名前付きロガーを取得
  ///
  /// 機能やクラスごとに異なる名前でロガーを作成
  /// 例: AppLogger.getLogger('AuthRepository')
  static Logger getLogger(String name) {
    return Logger(name);
  }
}
