/// Redux: App State
///
/// アプリケーション全体の状態を表現するルートState
/// 各機能のStateを統合して管理
library;

import 'package:equatable/equatable.dart';

/// アプリケーション全体の状態
///
/// 各機能（Auth、Task、Balloon等）のStateを保持
/// イミュータブルな設計により、状態変更の追跡を容易にする
class AppState extends Equatable {
  /// グローバルローディング状態
  ///
  /// 画面全体を覆うスピナーの表示/非表示を制御
  final bool isLoading;

  // TODO: 各機能のStateを追加
  // final AuthState authState;
  // final TaskState taskState;
  // final BalloonState balloonState;

  /// コンストラクタ
  const AppState({
    required this.isLoading,
  });

  /// 初期状態を生成
  ///
  /// アプリケーション起動時の初期値を返す
  factory AppState.initial() {
    return const AppState(
      isLoading: false,
    );
  }

  /// 状態のコピーを作成（一部のフィールドを更新）
  ///
  /// イミュータブルな更新を実現
  AppState copyWith({
    bool? isLoading,
  }) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        // TODO: 各機能のStateを追加
      ];
}
