/// Balloon String Renderer
///
/// 風船の紐の描画を担当
/// Catmull-Rom スプライン曲線で滑らかな紐を描画
library;

import 'package:flutter/material.dart';

/// 紐の描画定数
class BalloonStringConstants {
  /// 紐の色
  static const Color stringColor = Color(0xFFCCCCCC);

  /// 紐の太さ
  static const double strokeWidth = 1.5;

  /// 紐と結び目の接続点の色
  static const Color knotColor = Color(0xFFBBBBBB);

  /// 紐と結び目の接続点の半径
  static const double knotRadius = 2.0;

  const BalloonStringConstants._();
}

/// 紐の描画クラス
///
/// 物理演算で計算されたセグメントを滑らかな曲線で描画
class BalloonStringRenderer {
  const BalloonStringRenderer();

  /// 紐を描画
  ///
  /// [segments] 紐のセグメント座標リスト
  /// [color] 紐の色（デフォルト: シルバー）
  /// [showEndKnot] 終端に小さな結び目を表示するか
  void render({
    required Canvas canvas,
    required List<Offset> segments,
    Color? color,
    bool showEndKnot = true,
  }) {
    if (segments.length < 2) return;

    final paint = Paint()
      ..color = color ?? BalloonStringConstants.stringColor
      ..strokeWidth = BalloonStringConstants.strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = _createStringPath(segments);
    canvas.drawPath(path, paint);

    // 終端の小さな結び目
    if (showEndKnot && segments.isNotEmpty) {
      _drawEndKnot(canvas, segments.last);
    }
  }

  /// 紐のパスを作成（Catmull-Rom スプライン曲線）
  Path _createStringPath(List<Offset> segments) {
    final path = Path();
    path.moveTo(segments[0].dx, segments[0].dy);

    for (int i = 0; i < segments.length - 1; i++) {
      final p0 = i > 0 ? segments[i - 1] : segments[i];
      final p1 = segments[i];
      final p2 = segments[i + 1];
      final p3 = i < segments.length - 2 ? segments[i + 2] : segments[i + 1];

      // 制御点を計算
      final controlPoint1 = Offset(
        p1.dx + (p2.dx - p0.dx) / 6,
        p1.dy + (p2.dy - p0.dy) / 6,
      );
      final controlPoint2 = Offset(
        p2.dx - (p3.dx - p1.dx) / 6,
        p2.dy - (p3.dy - p1.dy) / 6,
      );

      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        p2.dx,
        p2.dy,
      );
    }

    return path;
  }

  /// 終端の小さな結び目を描画
  void _drawEndKnot(Canvas canvas, Offset position) {
    canvas.drawCircle(
      position,
      BalloonStringConstants.knotRadius,
      Paint()
        ..color = BalloonStringConstants.knotColor
        ..style = PaintingStyle.fill,
    );
  }
}
