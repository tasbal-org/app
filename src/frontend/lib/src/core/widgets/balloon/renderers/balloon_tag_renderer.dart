/// Balloon Tag Renderer
///
/// 風船のタグ（荷札）の描画を担当
/// 角丸カード型、グロメット穴、アイコン描画
library;

import 'dart:math';

import 'package:flutter/material.dart';

/// タグの描画定数
class BalloonTagConstants {
  /// タグの基本サイズ
  static const double baseSize = 28.0;

  /// タグの角丸半径
  static const double cornerRadius = 6.0;

  /// 穴のY位置
  static const double holeY = 5.0;

  /// 奥行き（影のオフセット）
  static const double depth = 3.0;

  /// 穴の外側半径
  static const double holeOuterRadius = 5.0;

  /// 穴の内側半径
  static const double holeInnerRadius = 3.0;

  const BalloonTagConstants._();
}

/// タグの描画クラス
///
/// 光沢のあるカード型タグとアイコンを描画
class BalloonTagRenderer {
  const BalloonTagRenderer();

  /// タグを描画
  ///
  /// [position] タグの位置（穴の中心座標）
  /// [rotation] 回転角度（ラジアン）
  /// [color] 風船の色
  /// [iconId] アイコンID（1-12）、nullの場合はアイコンなし
  void render({
    required Canvas canvas,
    required Offset position,
    required double rotation,
    required Color color,
    int? iconId,
  }) {
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(rotation);

    const tagW = BalloonTagConstants.baseSize;
    const tagH = BalloonTagConstants.baseSize;
    const tagRadius = BalloonTagConstants.cornerRadius;
    const holeY = BalloonTagConstants.holeY;
    const depth = BalloonTagConstants.depth;

    final tagX = -tagW / 2;
    const tagY = -holeY;

    // 色の準備
    final highlightColor = _lightenColor(color, 0.3);
    final boxColor = _lightenColor(color, 0.15);

    // 1. タグの厚み（影/奥行き）
    _drawRoundedRect(
      canvas,
      tagX + depth,
      tagY + depth,
      tagW,
      tagH,
      tagRadius,
      Paint()
        ..color = _darkenColor(color, 0.35)
        ..style = PaintingStyle.fill,
    );

    // 2. タグ本体（グラデーション）
    final tagRect = Rect.fromLTWH(tagX, tagY, tagW, tagH);
    final tagGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [highlightColor, boxColor, color],
      stops: const [0.0, 0.4, 1.0],
    );

    _drawRoundedRect(
      canvas,
      tagX,
      tagY,
      tagW,
      tagH,
      tagRadius,
      Paint()
        ..shader = tagGradient.createShader(tagRect)
        ..style = PaintingStyle.fill,
    );

    // 3. 内側のハイライト枠
    _drawRoundedRect(
      canvas,
      tagX + 2,
      tagY + 2,
      tagW - 4,
      tagH - 4,
      tagRadius - 1,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // 4. 光沢反射（左上の斜め）
    _drawGlossReflection(canvas, tagX, tagY, tagW, tagH, tagRadius);

    // 5. グロメット穴
    _drawGrommet(canvas);

    // 6. アイコン
    if (iconId != null) {
      final iconCenterX = tagX + tagW / 2;
      final iconCenterY = tagY + tagH / 2 + 2;
      const iconSize = BalloonTagConstants.baseSize * 0.4;
      _drawIcon(canvas, iconId, iconSize, Offset(iconCenterX, iconCenterY));
    }

    canvas.restore();
  }

  /// 角丸四角形を描画
  void _drawRoundedRect(
    Canvas canvas,
    double x,
    double y,
    double w,
    double h,
    double r,
    Paint paint,
  ) {
    final path = Path();
    path.moveTo(x + r, y);
    path.lineTo(x + w - r, y);
    path.quadraticBezierTo(x + w, y, x + w, y + r);
    path.lineTo(x + w, y + h - r);
    path.quadraticBezierTo(x + w, y + h, x + w - r, y + h);
    path.lineTo(x + r, y + h);
    path.quadraticBezierTo(x, y + h, x, y + h - r);
    path.lineTo(x, y + r);
    path.quadraticBezierTo(x, y, x + r, y);
    path.close();
    canvas.drawPath(path, paint);
  }

  /// 光沢反射を描画
  void _drawGlossReflection(
    Canvas canvas,
    double tagX,
    double tagY,
    double tagW,
    double tagH,
    double tagRadius,
  ) {
    canvas.save();

    final clipPath = Path();
    clipPath.moveTo(tagX + tagRadius, tagY);
    clipPath.lineTo(tagX + tagW - tagRadius, tagY);
    clipPath.quadraticBezierTo(tagX + tagW, tagY, tagX + tagW, tagY + tagRadius);
    clipPath.lineTo(tagX + tagW, tagY + tagH - tagRadius);
    clipPath.quadraticBezierTo(tagX + tagW, tagY + tagH, tagX + tagW - tagRadius, tagY + tagH);
    clipPath.lineTo(tagX + tagRadius, tagY + tagH);
    clipPath.quadraticBezierTo(tagX, tagY + tagH, tagX, tagY + tagH - tagRadius);
    clipPath.lineTo(tagX, tagY + tagRadius);
    clipPath.quadraticBezierTo(tagX, tagY, tagX + tagRadius, tagY);
    clipPath.close();
    canvas.clipPath(clipPath);

    final glossPath = Path()
      ..moveTo(tagX, tagY + tagH * 0.6)
      ..lineTo(tagX + tagW * 0.6, tagY)
      ..lineTo(tagX, tagY)
      ..close();

    canvas.drawPath(
      glossPath,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill,
    );

    canvas.restore();
  }

  /// グロメット穴を描画
  void _drawGrommet(Canvas canvas) {
    // 穴のリム（外側）
    canvas.drawCircle(
      Offset.zero,
      BalloonTagConstants.holeOuterRadius,
      Paint()
        ..color = const Color(0xFFE0E0E0)
        ..style = PaintingStyle.fill,
    );

    // 穴（内側 - 暗い）
    canvas.drawCircle(
      Offset.zero,
      BalloonTagConstants.holeInnerRadius,
      Paint()
        ..color = const Color(0xFF666666)
        ..style = PaintingStyle.fill,
    );

    // 穴のハイライトリング
    canvas.drawCircle(
      Offset.zero,
      BalloonTagConstants.holeOuterRadius,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
  }

  /// アイコンを描画
  void _drawIcon(Canvas canvas, int iconId, double size, Offset center) {
    final iconPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill
      ..strokeWidth = size * 0.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final halfSize = size / 2;

    canvas.save();
    canvas.translate(center.dx, center.dy);

    switch (iconId) {
      case 1: // 円
        canvas.drawCircle(Offset.zero, halfSize, iconPaint);
        break;
      case 2: // 四角
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: size, height: size),
          iconPaint,
        );
        break;
      case 3: // 三角
        final path = Path()
          ..moveTo(0, -halfSize)
          ..lineTo(halfSize, halfSize)
          ..lineTo(-halfSize, halfSize)
          ..close();
        canvas.drawPath(path, iconPaint);
        break;
      case 4: // 星
        _drawStarIcon(canvas, iconPaint, halfSize);
        break;
      case 5: // ハート
        _drawHeartIcon(canvas, iconPaint, halfSize);
        break;
      case 6: // ダイヤ
        final path = Path()
          ..moveTo(0, -halfSize)
          ..lineTo(halfSize, 0)
          ..lineTo(0, halfSize)
          ..lineTo(-halfSize, 0)
          ..close();
        canvas.drawPath(path, iconPaint);
        break;
      case 7: // 六角形
        _drawHexagonIcon(canvas, iconPaint, halfSize);
        break;
      case 8: // クロス
        iconPaint.style = PaintingStyle.stroke;
        canvas.drawLine(Offset(-halfSize, 0), Offset(halfSize, 0), iconPaint);
        canvas.drawLine(Offset(0, -halfSize), Offset(0, halfSize), iconPaint);
        break;
      case 9: // 波
        iconPaint.style = PaintingStyle.stroke;
        final wavePath = Path()
          ..moveTo(-halfSize, 0)
          ..cubicTo(-halfSize * 0.5, -halfSize * 0.8, -halfSize * 0.5, halfSize * 0.8, 0, 0)
          ..cubicTo(halfSize * 0.5, -halfSize * 0.8, halfSize * 0.5, halfSize * 0.8, halfSize, 0);
        canvas.drawPath(wavePath, iconPaint);
        break;
      case 10: // ドット
        canvas.drawCircle(Offset.zero, halfSize * 0.4, iconPaint);
        break;
      case 11: // リング
        final ringPath = Path()
          ..addOval(Rect.fromCircle(center: Offset.zero, radius: halfSize))
          ..addOval(Rect.fromCircle(center: Offset.zero, radius: halfSize * 0.6));
        ringPath.fillType = PathFillType.evenOdd;
        canvas.drawPath(ringPath, iconPaint);
        break;
      case 12: // 花
        _drawFlowerIcon(canvas, iconPaint, halfSize);
        break;
      default:
        canvas.drawCircle(Offset.zero, halfSize, iconPaint);
    }

    canvas.restore();
  }

  /// 星アイコン
  void _drawStarIcon(Canvas canvas, Paint paint, double radius) {
    final path = Path();
    for (var i = 0; i < 5; i++) {
      final angle = -pi / 2 + (2 * pi / 5) * i;
      final x = cos(angle) * radius;
      final y = sin(angle) * radius;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      final innerAngle = angle + pi / 5;
      final innerX = cos(innerAngle) * radius * 0.5;
      final innerY = sin(innerAngle) * radius * 0.5;
      path.lineTo(innerX, innerY);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  /// ハートアイコン
  void _drawHeartIcon(Canvas canvas, Paint paint, double radius) {
    final path = Path();
    path.moveTo(0, radius * 0.7);
    path.cubicTo(radius, 0, radius, -radius, 0, -radius * 0.6);
    path.cubicTo(-radius, -radius, -radius, 0, 0, radius * 0.7);
    path.close();
    canvas.drawPath(path, paint);
  }

  /// 六角形アイコン
  void _drawHexagonIcon(Canvas canvas, Paint paint, double radius) {
    final path = Path();
    for (var i = 0; i < 6; i++) {
      final angle = (pi / 3) * i - pi / 2;
      final x = cos(angle) * radius;
      final y = sin(angle) * radius;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  /// 花アイコン
  void _drawFlowerIcon(Canvas canvas, Paint paint, double radius) {
    for (var i = 0; i < 5; i++) {
      final angle = (pi * 2 * i) / 5;
      final cx = cos(angle) * radius * 0.5;
      final cy = sin(angle) * radius * 0.5;
      canvas.drawCircle(Offset(cx, cy), radius * 0.4, paint);
    }
    canvas.drawCircle(Offset.zero, radius * 0.3, paint);
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
