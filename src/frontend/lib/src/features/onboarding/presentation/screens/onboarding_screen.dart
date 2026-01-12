/// Onboarding: OnboardingScreen
///
/// オンボーディング画面（5画面構成）
/// PageViewで画面をスワイプで切り替え
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasbal/src/core/di/injection.dart';
import 'package:tasbal/src/core/widgets/balloon/balloon_background.dart';
import 'package:tasbal/src/features/onboarding/domain/use_cases/complete_onboarding_use_case.dart';

/// オンボーディング画面
///
/// 初回起動時に表示される5画面構成のオンボーディング
/// スキップ可能、設定画面から再表示可能
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  /// ページコントローラー
  final PageController _pageController = PageController();

  /// 現在のページインデックス
  int _currentPage = 0;

  /// 総ページ数
  static const int _totalPages = 5;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// 次のページへ
  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  /// オンボーディング完了
  Future<void> _completeOnboarding() async {
    // オンボーディング完了フラグを保存
    final completeOnboardingUseCase = sl<CompleteOnboardingUseCase>();
    final result = await completeOnboardingUseCase();

    if (!mounted) return;

    // 保存成功・失敗に関わらずアカウント選択画面へ遷移
    // エラーが発生しても初回起動体験を妨げないため
    result.fold(
      (failure) {
        // ログ出力のみ（ユーザーには影響させない）
        debugPrint('オンボーディング完了フラグの保存に失敗: ${failure.message}');
      },
      (_) {
        debugPrint('オンボーディング完了フラグを保存しました');
      },
    );

    // アカウント選択画面へ遷移
    context.go('/auth/account-selection');
  }

  /// スキップ
  void _skip() {
    _completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return BalloonBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
        child: Column(
          children: [
            // スキップボタン（最終ページ以外）
            if (_currentPage < _totalPages - 1)
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _skip,
                  child: const Text('スキップ'),
                ),
              ),

            // ページビュー
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: const [
                  _OnboardingPage1(),
                  _OnboardingPage2(),
                  _OnboardingPage3(),
                  _OnboardingPage4(),
                  _OnboardingPage5(),
                ],
              ),
            ),

            // ページインジケーター
            _PageIndicator(
              currentPage: _currentPage,
              totalPages: _totalPages,
            ),

            // 次へボタン
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(
                    _currentPage == _totalPages - 1 ? '続ける' : '次へ',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

/// ページインジケーター
class _PageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const _PageIndicator({
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          totalPages,
          (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            width: 8.0,
            height: 8.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentPage == index
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
        ),
      ),
    );
  }
}

/// オンボーディング画面1: 価値観の共有
class _OnboardingPage1 extends StatelessWidget {
  const _OnboardingPage1();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '今日の一歩を\nここに残せます',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
          SizedBox(height: 32),
          Text(
            'それは\n気づかないところで\n少しずつ\n広がっていきます',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              height: 1.8,
            ),
          ),
          SizedBox(height: 48),
          Text(
            '立ち止まって\n深呼吸することも\n一歩になります',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

/// オンボーディング画面2: 一歩を書く
class _OnboardingPage2 extends StatelessWidget {
  const _OnboardingPage2();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'まずは\n今日の一歩を\n書いてみましょう',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
          SizedBox(height: 48),
          Text(
            '・机に向かう\n・5分だけ考える\n・今日は休む\n\nなんでも大丈夫です',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }
}

/// オンボーディング画面3: 完了・体験
class _OnboardingPage3 extends StatelessWidget {
  const _OnboardingPage3();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'ひとつ\nここに\n残りました',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
          SizedBox(height: 32),
          Text(
            '一歩が\n静かに\n動いています',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }
}

/// オンボーディング画面4: 意味づけ
class _OnboardingPage4 extends StatelessWidget {
  const _OnboardingPage4();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'ここでは\nみんなの一歩が\n重なっていきます',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
          SizedBox(height: 32),
          Text(
            '誰がどれだけやったかは\n表示されません\n\n見えるのは\n前に進んでいる\nということだけです',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              height: 1.8,
            ),
          ),
          SizedBox(height: 48),
          Text(
            '進みましょう',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

/// オンボーディング画面5: 通常利用へ
class _OnboardingPage5 extends StatelessWidget {
  const _OnboardingPage5();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'これで\n準備は終わりです',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
          SizedBox(height: 32),
          Text(
            'あとは\n今日の一歩を\n重ねていくだけです',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }
}
