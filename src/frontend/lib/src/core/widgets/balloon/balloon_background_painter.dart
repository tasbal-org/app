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
  /// tasbal.pngに基づく紫/ラベンダー系のグラデーション
  void _drawBackgroundGradient(Canvas canvas, Size size) {
    final gradient = isDarkMode
        ? const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E1E3C), // 上：濃紺/青紫
              Color(0xFF141428), // 下：より暗い紫
            ],
            stops: [0.0, 1.0],
          )
        : const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF0F0FF), // 上：薄いラベンダー白
              Color(0xFFE8E0F8), // 下：わずかに紫味
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
