/// Auth: AccountSelectionScreen
///
/// アカウント案内画面（A1）
/// オンボーディング完了後に表示される認証案内画面
/// スキップ可能で、アカウントの意味を静かに伝える
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasbal/src/core/widgets/balloon/balloon_background.dart';

/// アカウント選択画面（A1）
///
/// オンボーディング完了後に表示
/// - アカウント作成
/// - ログイン
/// - スキップ（ゲストとして続行）
class AccountSelectionScreen extends StatelessWidget {
  const AccountSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BalloonBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // タイトル
              const Text(
                'このままでも使えます',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 32),

              // 説明
              const Text(
                '記録を引き継いだり\n別の端末でも使うには\nアカウントが必要になります',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.8,
                ),
              ),

              const SizedBox(height: 48),

              // メリット（箇条書き）
              const _BenefitsList(),

              const Spacer(),

              // Primary: アカウントを作る
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: サインアップ画面へ遷移
                    context.push('/auth/signup');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'アカウントを作る',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Secondary: ログインする
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: ログイン画面へ遷移
                    context.push('/auth/login');
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'ログインする',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Tertiary: あとで（いまはこのまま）
              TextButton(
                onPressed: () {
                  // ゲストとしてタスク画面へ
                  context.go('/task');
                },
                child: const Text(
                  'あとで（いまはこのまま）',
                  style: TextStyle(fontSize: 14),
                ),
              ),

              const SizedBox(height: 24),

              // 補足リンク
              TextButton(
                onPressed: () {
                  _showWhyAccountDialog(context);
                },
                child: const Text(
                  'なぜアカウントが必要？',
                  style: TextStyle(
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  /// 「なぜアカウントが必要？」ダイアログを表示
  void _showWhyAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('アカウントについて'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'アカウントは必須ではありません。',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text('アカウントを作成すると：'),
              SizedBox(height: 8),
              Text('• 端末を変えても続きから使える'),
              Text('• データを失いにくくなる'),
              Text('• 公開風船に参加できる（任意）'),
              SizedBox(height: 16),
              Text(
                'いつでも設定画面から作成できます。',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }
}

/// メリット一覧ウィジェット
class _BenefitsList extends StatelessWidget {
  const _BenefitsList();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BenefitItem(
            icon: Icons.devices,
            text: '端末を変えても続きから使える',
          ),
          const SizedBox(height: 12),
          _BenefitItem(
            icon: Icons.cloud_done,
            text: 'データを失いにくくなる',
          ),
          const SizedBox(height: 12),
          _BenefitItem(
            icon: Icons.people_outline,
            text: '公開風船に参加できる（任意）',
          ),
        ],
      ),
    );
  }
}

/// メリット項目ウィジェット
class _BenefitItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _BenefitItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
