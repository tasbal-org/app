/// Location Balloon Painter
///
/// ロケーション風船（国旗風船）のペインター
/// 風船本体に国旗パターンを表示
library;

import 'package:flutter/material.dart';
import 'package:tasbal/src/core/widgets/balloon/painters/base_balloon_painter.dart';
import 'package:tasbal/src/core/widgets/balloon/renderers/balloon_body_renderer.dart';
import 'package:tasbal/src/core/widgets/balloon/renderers/balloon_flag_renderer.dart';

/// ロケーション風船ペインター
///
/// 国旗パターンを風船本体に描画
class LocationBalloonPainter extends BaseBalloonPainter {
  /// 国旗コード
  final FlagCode flagCode;

  /// 国旗レンダラー
  final BalloonFlagRenderer _flagRenderer;

  LocationBalloonPainter({
    required super.balloon,
    required super.physicsState,
    required this.flagCode,
    super.debugMode,
    super.inflationState,
    BalloonFlagRenderer? flagRenderer,
  }) : _flagRenderer = flagRenderer ?? const BalloonFlagRenderer();

  @override
  void renderBody(Canvas canvas, Offset center, double radius) {
    // 膨らみを考慮した寸法計算
    final w = radius * bulge;
    final hTop = radius * BalloonBodyConstants.hTopRatio *
        (1 + (bulge - 1) * BalloonBodyConstants.bulgeTopExpansionFactor);
    final hBottom = radius * BalloonBodyConstants.hBottomRatio *
        (1 + (bulge - 1) * BalloonBodyConstants.bulgeBottomExpansionFactor);

    // ベジェ曲線で風船パスを作成
    final balloonPath = _createBalloonPath(center, w, hTop, hBottom);

    // 風船の境界ボックス
    final bounds = Rect.fromCenter(
      center: center,
      width: w * 3,
      height: hTop + hBottom,
    );

    // 国旗を風船形状にクリップして描画
    _flagRenderer.render(
      canvas: canvas,
      balloonPath: balloonPath,
      bounds: bounds,
      flagCode: flagCode,
    );

    // 光沢反射を追加
    _drawGlossyReflection(canvas, center, w, hTop);

    // 結び目
    _drawKnot(canvas, center, radius, hBottom);
  }

  /// 風船パスを作成
  Path _createBalloonPath(Offset center, double w, double hTop, double hBottom) {
    final path = Path();

    path.moveTo(center.dx, center.dy + hBottom);

    // 左側のカーブ
    path.cubicTo(
      center.dx - w * BalloonBodyConstants.widthControlPointRatio,
      center.dy + hBottom * 0.5,
      center.dx - w * BalloonBodyConstants.widthControlPointRatio,
      center.dy - hTop,
      center.dx,
      center.dy - hTop,
    );

    // 右側のカーブ
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

  /// 光沢反射を描画
  void _drawGlossyReflection(Canvas canvas, Offset center, double w, double hTop) {
    final reflectionCenter = Offset(
      center.dx - w * 0.45,
      center.dy - hTop * 0.5,
    );

    canvas.save();
    canvas.translate(reflectionCenter.dx, reflectionCenter.dy);
    canvas.rotate(3.14159 / 4);

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

  /// 結び目を描画
  void _drawKnot(Canvas canvas, Offset center, double radius, double hBottom) {
    final knotY = center.dy + hBottom - 2;
    final scale = radius / 55;

    // 影
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, knotY + 1 * scale),
        width: 12 * scale,
        height: 4 * scale,
      ),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.2)
        ..style = PaintingStyle.fill,
    );

    // 結び目（グレー基調）
    final knotRect = Rect.fromCenter(
      center: Offset(center.dx, knotY + 6 * scale),
      width: 20 * scale,
      height: 14 * scale,
    );

    final knotGradient = RadialGradient(
      center: const Alignment(-0.3, -0.2),
      radius: 1.0,
      colors: [Colors.grey.shade400, Colors.grey.shade700],
    );

    final knotPaint = Paint()
      ..shader = knotGradient.createShader(knotRect)
      ..style = PaintingStyle.fill;

    // 結び目形状
    final knotPath = Path()
      ..moveTo(center.dx - 3 * scale, knotY)
      ..cubicTo(
        center.dx - 8 * scale, knotY + 2 * scale,
        center.dx - 10 * scale, knotY + 10 * scale,
        center.dx - 4 * scale, knotY + 12 * scale,
      )
      ..cubicTo(
        center.dx, knotY + 14 * scale,
        center.dx, knotY + 14 * scale,
        center.dx + 4 * scale, knotY + 12 * scale,
      )
      ..cubicTo(
        center.dx + 10 * scale, knotY + 10 * scale,
        center.dx + 8 * scale, knotY + 2 * scale,
        center.dx + 3 * scale, knotY,
      )
      ..close();

    canvas.drawPath(knotPath, knotPaint);

    // しわ
    final creasePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final leftCrease = Path()
      ..moveTo(center.dx - 2 * scale, knotY + 4 * scale)
      ..quadraticBezierTo(
        center.dx - 5 * scale, knotY + 8 * scale,
        center.dx - 3 * scale, knotY + 10 * scale,
      );
    canvas.drawPath(leftCrease, creasePaint);

    final rightCrease = Path()
      ..moveTo(center.dx + 2 * scale, knotY + 4 * scale)
      ..quadraticBezierTo(
        center.dx + 5 * scale, knotY + 8 * scale,
        center.dx + 3 * scale, knotY + 10 * scale,
      );
    canvas.drawPath(rightCrease, creasePaint);
  }
}
