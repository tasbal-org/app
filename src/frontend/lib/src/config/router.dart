/// Config: Router
///
/// go_routerを使用したルーティング設定
/// アプリケーション全体の画面遷移を管理
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// ルーターインスタンス
///
/// アプリケーション全体で使用するGoRouterの設定
/// 各画面へのパスと遷移ロジックを定義
final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    // ============================================================
    // スプラッシュ画面（初回起動時）
    // ============================================================
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),

    // ============================================================
    // メイン画面（タブ構造）
    // ============================================================
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),

    // TODO: 各機能の画面ルートを追加
    // - タスク詳細画面
    // - 風船作成画面
    // - 設定画面
    // 等
  ],
  errorBuilder: (context, state) => ErrorScreen(error: state.error),
);

// ============================================================
// 仮の画面ウィジェット（後で実装）
// ============================================================

/// スプラッシュ画面
///
/// アプリケーション起動時に表示される初期画面
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

/// ホーム画面（3タブ構造のメイン画面）
///
/// タスク / 風船 / 設定 の3タブを持つ
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasbal'),
      ),
      body: const Center(
        child: Text('ホーム画面（仮実装）'),
      ),
    );
  }
}

/// エラー画面
///
/// ルーティングエラー時に表示
class ErrorScreen extends StatelessWidget {
  /// エラー情報
  final Exception? error;

  const ErrorScreen({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('エラー'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              error?.toString() ?? 'ページが見つかりません',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
