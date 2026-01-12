/// Balloon Test Screen
///
/// 風船の動作確認用テスト画面
library;

import 'package:flutter/material.dart';
import 'package:tasbal/src/core/widgets/balloon/balloon_background.dart';

/// 風船テスト画面
///
/// 風船の動きを確認するためのシンプルな画面
class BalloonTestScreen extends StatelessWidget {
  const BalloonTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BalloonBackground(
        quality: BalloonQuality.normal, // 14個の風船を表示
        debugMode: true,
        onBalloonTap: (balloon) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '風船タップ: ${balloon.type.displayName}\n'
                '進捗: ${(balloon.progressRatio * 100).toStringAsFixed(1)}%',
              ),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: Container(
          color: Colors.black.withValues(alpha: 0.3),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.touch_app,
                  size: 64,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                const Text(
                  '風船をタップしてみてください',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '風船が画面を漂っています',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('戻る'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
