/// Breath Balloon Painter
///
/// 深呼吸風船のペインター
/// 呼吸に合わせて膨らむ特殊エフェクト
library;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tasbal/src/core/widgets/balloon/painters/base_balloon_painter.dart';
import 'package:tasbal/src/core/widgets/balloon/renderers/balloon_body_renderer.dart';

/// 呼吸フェーズ
enum BreathPhase {
  /// 吸う（膨らむ）
  inhale,

  /// 止める（保持）
  hold,

  /// 吐く（縮む）
  exhale,

  /// 休憩
  rest,
}

/// 深呼吸風船ペインター
///
/// 呼吸のリズムに合わせてサイズとエフェクトが変化
class BreathBalloonPainter extends BaseBalloonPainter {
  /// 現在の呼吸フェーズ
  final BreathPhase breathPhase;

  /// 呼吸の進捗（0.0 ～ 1.0）
  final double breathProgress;

  /// 呼吸に応じたスケール倍率
  final double breathScale;

  /// パルスエフェクトの強度
  final double pulseIntensity;

  BreathBalloonPainter({
    required super.balloon,
    required super.physicsState,
    this.breathPhase = BreathPhase.rest,
    this.breathProgress = 0.0,
    this.breathScale = 1.0,
    this.pulseIntensity = 0.0,
    super.debugMode,
    super.inflationState,
  });

  @override
  void renderBody(Canvas canvas, Offset center, double radius) {
    // 呼吸スケールを適用
    final effectiveRadius = radius * breathScale;

    // 呼吸フェーズに応じた色調整
    final effectiveColor = _adjustColorForBreathPhase(balloon.color);

    // 膨らみを考慮した寸法計算
    final w = effectiveRadius * bulge;
    final hTop = effectiveRadius * BalloonBodyConstants.hTopRatio *
        (1 + (bulge - 1) * BalloonBodyConstants.bulgeTopExpansionFactor);
    final hBottom = effectiveRadius * BalloonBodyConstants.hBottomRatio *
        (1 + (bulge - 1) * BalloonBodyConstants.bulgeBottomExpansionFactor);

    // 風船本体を描画
    final balloonPath = _createBalloonPath(center, w, hTop, hBottom);
    _drawGradientFill(canvas, balloonPath, center, w, hTop, hBottom, effectiveColor);

    // パルスエフェクト（吸気時）
    if (pulseIntensity > 0) {
      _drawPulseEffect(canvas, center, effectiveRadius, pulseIntensity);
    }

    // 呼吸ガイドリング
    _drawBreathGuideRing(canvas, center, effectiveRadius);

    // 光沢反射
    _drawGlossyReflection(canvas, center, w, hTop);

    // 結び目
    bodyRenderer.render(
      canvas: canvas,
      position: center,
      radius: effectiveRadius,
      color: effectiveColor,
      bulge: bulge,
      showKnot: true,
    );

    // 呼吸インジケーター
    _drawBreathIndicator(canvas, center, effectiveRadius);
  }

  /// 呼吸フェーズに応じて色を調整
  Color _adjustColorForBreathPhase(Color baseColor) {
    final hsl = HSLColor.fromColor(baseColor);

    switch (breathPhase) {
      case BreathPhase.inhale:
        // 吸気時：少し明るく
        return hsl.withLightness((hsl.lightness + 0.1).clamp(0.0, 1.0)).toColor();
      case BreathPhase.hold:
        // 保持時：彩度を上げる
        return hsl.withSaturation((hsl.saturation + 0.1).clamp(0.0, 1.0)).toColor();
      case BreathPhase.exhale:
        // 呼気時：少し暗く
        return hsl.withLightness((hsl.lightness - 0.05).clamp(0.0, 1.0)).toColor();
      case BreathPhase.rest:
        return baseColor;
    }
  }

  /// 風船パスを作成
  Path _createBalloonPath(Offset center, double w, double hTop, double hBottom) {
    final path = Path();

    path.moveTo(center.dx, center.dy + hBottom);

    path.cubicTo(
      center.dx - w * BalloonBodyConstants.widthControlPointRatio,
      center.dy + hBottom * 0.5,
      center.dx - w * BalloonBodyConstants.widthControlPointRatio,
      center.dy - hTop,
      center.dx,
      center.dy - hTop,
    );

    path.cubicTo(
      center.dx + w * BalloonBodyConstants.widthControlPointRatio,
      center.dy - hTop,
      center.dx + w * BalloonBodyConstants.widthControlPointRatio,
      center.dy + hBottom * 0.5,
      center.dx,
      center.dy + hBottom,
    );

    path.close();
    return path;
  }

  /// グラデーション塗りつぶし
  void _drawGradientFill(
    Canvas canvas,
    Path path,
    Offset center,
    double w,
    double hTop,
    double hBottom,
    Color color,
  ) {
    final totalHeight = hTop + hBottom;
    final gradientRect = Rect.fromCenter(
      center: center,
      width: w * 3,
      height: totalHeight,
    );

    final hsl = HSLColor.fromColor(color);
    final highlightColor = hsl.withLightness((hsl.lightness + 0.3).clamp(0.0, 1.0)).toColor();
    final darkerColor = hsl.withLightness((hsl.lightness - 0.15).clamp(0.0, 1.0)).toColor();
    final darkestColor = hsl.withLightness((hsl.lightness - 0.3).clamp(0.0, 1.0)).toColor();

    final gradient = RadialGradient(
      center: const Alignment(-0.35, -0.35),
      radius: 1.0,
      colors: [highlightColor, color, darkerColor, darkestColor],
      stops: const [0.0, 0.2, 0.7, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(gradientRect)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  /// パルスエフェクト
  void _drawPulseEffect(Canvas canvas, Offset center, double radius, double intensity) {
    final pulseRadius = radius * (1.2 + intensity * 0.3);

    final pulsePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3 * intensity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawCircle(center, pulseRadius, pulsePaint);

    // 内側のパルス
    final innerPulseRadius = radius * (1.1 + intensity * 0.2);
    final innerPulsePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5 * intensity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, innerPulseRadius, innerPulsePaint);
  }

  /// 呼吸ガイドリング
  void _drawBreathGuideRing(Canvas canvas, Offset center, double radius) {
    final guideRadius = radius * 1.5;

    // 外側のガイドリング
    final guidePaint = Paint()
      ..color = _getPhaseColor().withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, guideRadius, guidePaint);

    // 進捗アーク
    if (breathProgress > 0) {
      final progressPaint = Paint()
        ..color = _getPhaseColor().withValues(alpha: 0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: guideRadius),
        -pi / 2,
        2 * pi * breathProgress,
        false,
        progressPaint,
      );
    }
  }

  /// 呼吸インジケーター
  void _drawBreathIndicator(Canvas canvas, Offset center, double radius) {
    final indicatorY = center.dy + radius * 1.8;

    // フェーズテキスト
    final phaseText = _getPhaseText();
    final textPainter = TextPainter(
      text: TextSpan(
        text: phaseText,
        style: TextStyle(
          color: _getPhaseColor(),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, indicatorY),
    );
  }

  /// 光沢反射
  void _drawGlossyReflection(Canvas canvas, Offset center, double w, double hTop) {
    final reflectionCenter = Offset(
      center.dx - w * 0.45,
      center.dy - hTop * 0.5,
    );

    canvas.save();
    canvas.translate(reflectionCenter.dx, reflectionCenter.dy);
    canvas.rotate(pi / 4);

    final reflectionPath = Path();
    reflectionPath.addOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: w * 0.35,
        height: w * 0.7,
      ),
    );

    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    canvas.drawPath(reflectionPath, paint);
    canvas.restore();
  }

  /// フェーズに応じた色を取得
  Color _getPhaseColor() {
    switch (breathPhase) {
      case BreathPhase.inhale:
        return Colors.cyan;
      case BreathPhase.hold:
        return Colors.amber;
      case BreathPhase.exhale:
        return Colors.teal;
      case BreathPhase.rest:
        return Colors.grey;
    }
  }

  /// フェーズテキストを取得
  String _getPhaseText() {
    switch (breathPhase) {
      case BreathPhase.inhale:
        return '吸う';
      case BreathPhase.hold:
        return '止める';
      case BreathPhase.exhale:
        return '吐く';
      case BreathPhase.rest:
        return '休憩';
    }
  }

  @override
  bool shouldRepaint(covariant BreathBalloonPainter oldDelegate) {
    return super.shouldRepaint(oldDelegate) ||
        oldDelegate.breathPhase != breathPhase ||
        oldDelegate.breathProgress != breathProgress ||
        oldDelegate.breathScale != breathScale ||
        oldDelegate.pulseIntensity != pulseIntensity;
  }
}
