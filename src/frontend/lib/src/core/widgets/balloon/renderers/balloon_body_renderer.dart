/// Balloon Body Renderer
///
/// 風船本体の描画を担当
/// ベジェ曲線による卵型形状、グラデーション、光沢反射
library;

import 'dart:math';

import 'package:flutter/material.dart';

/// 風船本体の形状定数
class BalloonBodyConstants {
  /// 上部の高さ比率（radius * hTopRatio）
  static const double hTopRatio = 1.27;

  /// 下部の高さ比率（radius * hBottomRatio）
  static const double hBottomRatio = 1.45;

  /// 横幅の制御点倍率
  static const double widthControlPointRatio = 1.5;

  const BalloonBodyConstants._();
}

/// 風船本体の描画クラス
///
/// 卵型の風船本体、グラデーション、光沢反射、結び目を描画
class BalloonBodyRenderer {
  const BalloonBodyRenderer();

  /// 風船本体を描画
  void render({
    required Canvas canvas,
    required Offset position,
    required double radius,
    required Color color,
    bool showKnot = true,
  }) {
    final w = radius;
    final hTop = radius * BalloonBodyConstants.hTopRatio;
    final hBottom = radius * BalloonBodyConstants.hBottomRatio;

    // ベジェ曲線で卵型の風船を描画
    final balloonPath = _createBalloonPath(position, w, hTop, hBottom);

    // グラデーション塗りつぶし
    _drawGradientFill(canvas, balloonPath, position, w, hTop, hBottom, color);

    // 光沢反射
    _drawGlossyReflection(canvas, position, radius, hTop);

    // 結び目
    if (showKnot) {
      _drawKnot(canvas, position, radius, hBottom, color);
    }
  }

  /// 風船のパスを作成
  Path _createBalloonPath(Offset position, double w, double hTop, double hBottom) {
    final path = Path();

    // 下の中心から開始
    path.moveTo(position.dx, position.dy + hBottom);

    // 左側のカーブ（下→上）
    path.cubicTo(
      position.dx - w * BalloonBodyConstants.widthControlPointRatio,
      position.dy + hBottom * 0.5,
      position.dx - w * BalloonBodyConstants.widthControlPointRatio,
      position.dy - hTop,
      position.dx,
      position.dy - hTop,
    );

    // 右側のカーブ（上→下）
    path.cubicTo(
      position.dx + w * BalloonBodyConstants.widthControlPointRatio,
      position.dy - hTop,
      position.dx + w * BalloonBodyConstants.widthControlPointRatio,
      position.dy + hBottom * 0.5,
      position.dx,
      position.dy + hBottom,
    );

    path.close();
    return path;
  }

  /// グラデーション塗りつぶし
  void _drawGradientFill(
    Canvas canvas,
    Path path,
    Offset position,
    double w,
    double hTop,
    double hBottom,
    Color color,
  ) {
    final totalHeight = hTop + hBottom;
    final gradientRect = Rect.fromCenter(
      center: position,
      width: w * 3,
      height: totalHeight,
    );

    final highlightColor = _lightenColor(color, 0.3);
    final baseColor = color;
    final darkerColor = _darkenColor(color, 0.15);
    final darkestColor = _darkenColor(color, 0.3);

    final gradient = RadialGradient(
      center: const Alignment(-0.35, -0.35),
      radius: 1.0,
      colors: [highlightColor, baseColor, darkerColor, darkestColor],
      stops: const [0.0, 0.2, 0.7, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(gradientRect)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  /// 光沢反射を描画
  void _drawGlossyReflection(Canvas canvas, Offset position, double radius, double hTop) {
    final reflectionCenter = Offset(
      position.dx - radius * 0.45,
      position.dy - hTop * 0.5,
    );

    canvas.save();
    canvas.translate(reflectionCenter.dx, reflectionCenter.dy);
    canvas.rotate(pi / 4);

    final reflectionPath = Path();
    reflectionPath.addOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: radius * 0.35,
        height: radius * 0.7,
      ),
    );

    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    canvas.drawPath(reflectionPath, paint);
    canvas.restore();
  }

  /// 結び目を描画
  void _drawKnot(Canvas canvas, Offset position, double radius, double hBottom, Color color) {
    final knotY = position.dy + hBottom - 2;
    final scale = radius / 55;

    // 影
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(position.dx, knotY + 1 * scale),
        width: 12 * scale,
        height: 4 * scale,
      ),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.2)
        ..style = PaintingStyle.fill,
    );

    // グラデーション
    final knotRect = Rect.fromCenter(
      center: Offset(position.dx, knotY + 6 * scale),
      width: 20 * scale,
      height: 14 * scale,
    );

    final knotGradient = RadialGradient(
      center: const Alignment(-0.3, -0.2),
      radius: 1.0,
      colors: [color, _darkenColor(color, 0.25)],
    );

    final knotPaint = Paint()
      ..shader = knotGradient.createShader(knotRect)
      ..style = PaintingStyle.fill;

    // 有機的な結び目形状
    final knotPath = Path();
    knotPath.moveTo(position.dx - 3 * scale, knotY);
    knotPath.cubicTo(
      position.dx - 8 * scale, knotY + 2 * scale,
      position.dx - 10 * scale, knotY + 10 * scale,
      position.dx - 4 * scale, knotY + 12 * scale,
    );
    knotPath.cubicTo(
      position.dx, knotY + 14 * scale,
      position.dx, knotY + 14 * scale,
      position.dx + 4 * scale, knotY + 12 * scale,
    );
    knotPath.cubicTo(
      position.dx + 10 * scale, knotY + 10 * scale,
      position.dx + 8 * scale, knotY + 2 * scale,
      position.dx + 3 * scale, knotY,
    );
    knotPath.close();
    canvas.drawPath(knotPath, knotPaint);

    // しわ/折り目
    final creasePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final leftCrease = Path()
      ..moveTo(position.dx - 2 * scale, knotY + 4 * scale)
      ..quadraticBezierTo(
        position.dx - 5 * scale, knotY + 8 * scale,
        position.dx - 3 * scale, knotY + 10 * scale,
      );
    canvas.drawPath(leftCrease, creasePaint);

    final rightCrease = Path()
      ..moveTo(position.dx + 2 * scale, knotY + 4 * scale)
      ..quadraticBezierTo(
        position.dx + 5 * scale, knotY + 8 * scale,
        position.dx + 3 * scale, knotY + 10 * scale,
      );
    canvas.drawPath(rightCrease, creasePaint);
  }

  /// 色を明るくする
  Color _lightenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  /// 色を暗くする
  Color _darkenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }
}
