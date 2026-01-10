/// Core Constants: Status
///
/// Redux状態管理で使用する操作ステータス
/// 非同期処理の状態を表現する
library;

/// 操作ステータス列挙型
///
/// Redux stateで非同期操作の状態を管理するために使用
enum Status {
  /// 初期状態（未実行）
  initial,

  /// ローディング中（処理実行中）
  loading,

  /// 成功（処理完了）
  success,

  /// エラー（処理失敗）
  error,
}
