/// Balloon Test Screen
///
/// 風船の動作確認用テスト画面
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasbal/src/core/widgets/balloon/balloon_background.dart';

/// 風船テスト画面
///
/// 風船の動きを確認するためのシンプルな画面
class BalloonTestScreen extends StatefulWidget {
  const BalloonTestScreen({super.key});

  @override
  State<BalloonTestScreen> createState() => _BalloonTestScreenState();
}

class _BalloonTestScreenState extends State<BalloonTestScreen> {
  /// ダークモードフラグ
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
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
                  // ダークモード切り替えボタン
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _isDarkMode = !_isDarkMode;
                      });
                    },
                    icon: Icon(
                      _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    ),
                    label: Text(_isDarkMode ? 'ライトモード' : 'ダークモード'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isDarkMode ? Colors.amber : Colors.indigo,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/balloon-inflation-test'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text('膨らみ・破裂テスト'),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context.go('/balloon-types-test'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                    ),
                    child: const Text('風船タイプテスト'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/home'),
                    child: const Text('ホームへ'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
