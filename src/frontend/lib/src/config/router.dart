/// Config: Router
///
/// go_routerを使用したルーティング設定
/// アプリケーション全体の画面遷移を管理
library;

import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasbal/src/core/di/injection.dart';
import 'package:tasbal/src/enums/device_platform.dart';
import 'package:tasbal/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:tasbal/src/features/auth/domain/use_cases/guest_auth_use_case.dart';
import 'package:tasbal/src/features/auth/domain/use_cases/register_device_use_case.dart';
import 'package:tasbal/src/features/auth/presentation/screens/account_selection_screen.dart';
import 'package:tasbal/src/features/balloon/presentation/screens/balloon_inflation_test_screen.dart';
import 'package:tasbal/src/features/balloon/presentation/screens/balloon_test_screen.dart';
import 'package:tasbal/src/features/balloon/presentation/screens/balloon_types_test_screen.dart';
import 'package:tasbal/src/features/onboarding/domain/use_cases/check_onboarding_use_case.dart';
import 'package:tasbal/src/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:tasbal/src/features/task/presentation/screens/home_screen.dart' as task;
import 'package:tasbal/src/core/widgets/shell/app_shell.dart';

/// ルーターインスタンス
///
/// アプリケーション全体で使用するGoRouterの設定
/// 各画面へのパスと遷移ロジックを定義
final GoRouter router = GoRouter(
  initialLocation: '/app-shell-test', // AppShellテスト画面を最初に表示
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
    // オンボーディング画面
    // ============================================================
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),

    // ============================================================
    // 認証画面群
    // ============================================================
    GoRoute(
      path: '/auth/account-selection',
      name: 'account-selection',
      builder: (context, state) => const AccountSelectionScreen(),
    ),

    // TODO: サインアップ画面
    // GoRoute(
    //   path: '/auth/signup',
    //   name: 'signup',
    //   builder: (context, state) => const SignupScreen(),
    // ),

    // TODO: ログイン画面
    // GoRoute(
    //   path: '/auth/login',
    //   name: 'login',
    //   builder: (context, state) => const LoginScreen(),
    // ),

    // ============================================================
    // メイン画面（タブ構造）
    // ============================================================
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const task.HomeScreen(),
    ),

    // ============================================================
    // AppShellテスト画面（デバッグ用）
    // ============================================================
    GoRoute(
      path: '/app-shell-test',
      name: 'app-shell-test',
      builder: (context, state) => const AppShell(),
    ),

    // ============================================================
    // 風船テスト画面（デバッグ用）
    // ============================================================
    GoRoute(
      path: '/balloon-test',
      name: 'balloon-test',
      builder: (context, state) => const BalloonTestScreen(),
    ),

    // ============================================================
    // 風船膨らみテスト画面（デバッグ用）
    // ============================================================
    GoRoute(
      path: '/balloon-inflation-test',
      name: 'balloon-inflation-test',
      builder: (context, state) => const BalloonInflationTestScreen(),
    ),

    // ============================================================
    // 風船タイプテスト画面（デバッグ用）
    // ============================================================
    GoRoute(
      path: '/balloon-types-test',
      name: 'balloon-types-test',
      builder: (context, state) => const BalloonTypesTestScreen(),
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
/// 初回起動判定を行い、適切な画面に遷移
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  /// 初期化処理
  ///
  /// アプリ起動時の初期化フロー
  /// 1. オンボーディング完了チェック
  /// 2. デバイス登録チェック・実行
  /// 3. ゲスト認証チェック・実行
  /// 4. 適切な画面へ遷移
  Future<void> _initialize() async {
    try {
      // 最小表示時間を確保（スプラッシュ表示）
      await Future.delayed(const Duration(milliseconds: 800));

      // 1. オンボーディング完了チェック
      final checkOnboardingUseCase = sl<CheckOnboardingUseCase>();
      final onboardingResult = await checkOnboardingUseCase();

      final hasCompletedOnboarding = onboardingResult.fold(
        (failure) {
          debugPrint('オンボーディング状態の取得に失敗: ${failure.message}');
          return false; // エラー時は未完了として扱う
        },
        (completed) => completed,
      );

      if (!mounted) return;

      // オンボーディング未完了の場合はオンボーディングへ
      if (!hasCompletedOnboarding) {
        context.go('/onboarding');
        return;
      }

      // 2. デバイス登録チェック・実行
      final registerDeviceUseCase = sl<RegisterDeviceUseCase>();
      final guestAuthUseCase = sl<GuestAuthUseCase>();

      // デバイス登録状態を確認（保存されているデバイス情報を取得）
      final authRepository = sl<AuthRepository>();
      final savedDeviceResult = await authRepository.getSavedDevice();

      String? deviceKey;

      final hasSavedDevice = savedDeviceResult.fold(
        (failure) => false,
        (device) {
          if (device != null) {
            deviceKey = device.deviceKey;
            return true;
          }
          return false;
        },
      );

      // デバイス未登録の場合は登録
      if (!hasSavedDevice) {
        final devicePlatform = Platform.isIOS
            ? DevicePlatform.IOS
            : Platform.isAndroid
                ? DevicePlatform.Android
                : DevicePlatform.Web;

        final deviceName = '${devicePlatform.displayName}デバイス';

        final registerResult = await registerDeviceUseCase(
          deviceName: deviceName,
          pushToken: null, // TODO: プッシュ通知トークンの取得
        );

        registerResult.fold(
          (failure) {
            debugPrint('デバイス登録に失敗: ${failure.message}');
            // 登録失敗時もホームへ（ゲスト機能のみで使用可能）
          },
          (device) {
            deviceKey = device.deviceKey;
            debugPrint('デバイス登録成功: ${device.deviceKey}');
          },
        );
      }

      // 3. ゲスト認証チェック・実行
      if (deviceKey != null) {
        // 保存されているトークンを確認
        final savedTokenResult = await authRepository.getSavedToken();

        final hasValidToken = savedTokenResult.fold(
          (failure) => false,
          (token) => token?.isValid ?? false,
        );

        // トークンがない、または無効な場合はゲスト認証
        if (!hasValidToken) {
          final guestAuthResult = await guestAuthUseCase(
            deviceKey: deviceKey!,
          );

          guestAuthResult.fold(
            (failure) {
              debugPrint('ゲスト認証に失敗: ${failure.message}');
            },
            (result) {
              debugPrint('ゲスト認証成功: ${result.user.handle}');
            },
          );
        }
      }

      if (!mounted) return;

      // 4. ホーム画面へ遷移
      context.go('/home');
    } catch (e) {
      debugPrint('初期化エラー: $e');
      if (!mounted) return;
      // エラー時もホームへ遷移（アプリを使用可能にする）
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: アプリアイコンを表示
            Text(
              'Tasbal',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            CircularProgressIndicator(),
          ],
        ),
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
