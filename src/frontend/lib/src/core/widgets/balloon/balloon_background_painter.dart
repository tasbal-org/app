/// Balloon Background Painter
///
/// タスバルの背景（ライト/ダークモード対応）を描画
library;

import 'package:flutter/material.dart';

/// 背景ペインター
///
/// 垂直グラデーションのみのシンプルな背景
class BalloonBackgroundPainter extends CustomPainter {
  /// ダークモード対応
  final bool isDarkMode;

  const BalloonBackgroundPainter({
    this.isDarkMode = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackgroundGradient(canvas, size);
  }

  /// 背景グラデーションを描画
  void _drawBackgroundGradient(Canvas canvas, Size size) {
    final gradient = isDarkMode
        ? const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A2028), // 上：やや明るめ（圧迫感を避ける）
              Color(0xFF0F141A), // 下：落ち着いた暗さ
            ],
            stops: [0.0, 1.0],
          )
        : const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF), // 上：より白寄り（安心・余白）
              Color(0xFFF6F8FA), // 下：わずかに色味を残す
            ],
            stops: [0.0, 1.0],
          );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant BalloonBackgroundPainter oldDelegate) {
    return oldDelegate.isDarkMode != isDarkMode;
  }
}
