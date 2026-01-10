/// Redux: App Actions
///
/// アプリケーション全体で使用するグローバルアクション
/// ローディング状態の制御等
library;

/// グローバルローディング状態を設定するアクション
///
/// 画面全体を覆うスピナーの表示/非表示を制御
class SetLoadingAction {
  /// ローディング状態（true: 表示, false: 非表示）
  final bool isLoading;

  /// コンストラクタ
  const SetLoadingAction({required this.isLoading});
}
