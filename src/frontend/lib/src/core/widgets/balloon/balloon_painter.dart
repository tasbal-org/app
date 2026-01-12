/// Balloon Painter Widget
///
/// 風船の描画を担当
/// 円形ベース、グラデーション、ハイライト効果
library;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tasbal/src/features/balloon/domain/entities/balloon.dart';
import 'package:tasbal/src/features/balloon/domain/physics/balloon_physics.dart';

/// 風船ペインター
///
/// CustomPainter を使用して風船を描画
class BalloonPainter extends CustomPainter {
  /// 風船エンティティ
  final Balloon balloon;

  /// 物理状態
  final BalloonPhysicsState physicsState;

  /// デバッグモード（衝突判定の可視化）
  final bool debugMode;

  const BalloonPainter({
    required this.balloon,
    required this.physicsState,
    this.debugMode = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final radius = balloon.currentRadius;
    // 新しい卵型形状に合わせた比率
    final hTop = radius * 1.27;

    // CustomPaint内では中心を基準に描画
    // 中心点はCustomPaintの幅の中央、上からhTopの位置
    final center = Offset(
      size.width / 2,
      hTop,
    );

    // 地面への影を先に描画
    _drawGroundShadow(canvas, center, radius);

    // 紐とタグを描画（風船の下に）
    _drawStringAndTag(canvas, center, radius);

    // 風船本体を描画
    _drawBalloon(canvas, center, radius);

    // 選択状態のリング
    if (balloon.isSelected) {
      _drawSelectionRing(canvas, center, radius);
    }

    // デバッグモード：衝突判定の円を描画
    if (debugMode) {
      _drawDebugCircle(canvas, center, radius);
    }
  }

  /// 風船本体を描画（ベジェ曲線で卵型）
  void _drawBalloon(Canvas canvas, Offset position, double radius) {
    // サンプルコードの比率を参考に（w=55, h_top=70, h_bottom=80 → radius=55基準）
    // radius を基準にスケーリング
    final w = radius; // 横幅の半分
    final hTop = radius * 1.27; // 上部の高さ (70/55)
    final hBottom = radius * 1.45; // 下部の高さ (80/55)

    // ベジェ曲線で卵型の風船を描画
    final balloonPath = Path();

    // 下の中心から開始
    balloonPath.moveTo(position.dx, position.dy + hBottom);

    // 左側のカーブ（下→上）
    balloonPath.cubicTo(
      position.dx - w * 1.5, position.dy + hBottom * 0.5, // 制御点1（左下）
      position.dx - w * 1.5, position.dy - hTop, // 制御点2（左上）
      position.dx, position.dy - hTop, // 終点（上の中心）
    );

    // 右側のカーブ（上→下）
    balloonPath.cubicTo(
      position.dx + w * 1.5, position.dy - hTop, // 制御点1（右上）
      position.dx + w * 1.5, position.dy + hBottom * 0.5, // 制御点2（右下）
      position.dx, position.dy + hBottom, // 終点（下の中心）
    );

    balloonPath.close();

    // グラデーション（4色ストップ）- 光源は左上
    final totalHeight = hTop + hBottom;
    final gradientRect = Rect.fromCenter(
      center: position,
      width: w * 3,
      height: totalHeight,
    );

    final highlightColor = _lightenColor(balloon.color, 0.3);
    final baseColor = balloon.color;
    final darkerColor = _darkenColor(balloon.color, 0.15);
    final darkestColor = _darkenColor(balloon.color, 0.3);

    final shadingGradient = RadialGradient(
      center: const Alignment(-0.35, -0.35), // 左上寄り
      radius: 1.0,
      colors: [
        highlightColor, // ハイライト
        baseColor, // 基本色
        darkerColor, // やや暗い
        darkestColor, // 最も暗い
      ],
      stops: const [0.0, 0.2, 0.7, 1.0],
    );

    final shadingPaint = Paint()
      ..shader = shadingGradient.createShader(gradientRect)
      ..style = PaintingStyle.fill;

    canvas.drawPath(balloonPath, shadingPaint);

    // 光沢反射（楕円形）
    _drawGlossyReflection(canvas, position, radius, hTop);

    // 結び目を描画
    _drawKnot(canvas, position, radius, hBottom);

    // 進捗インジケーター（オプション：ユーザー作成風船のみ）
    if (balloon.title != null) {
      _drawProgressIndicator(canvas, position, radius);
    }
  }

  /// 光沢反射を描画（楕円形）
  void _drawGlossyReflection(Canvas canvas, Offset position, double radius, double hTop) {
    final reflectionCenter = Offset(
      position.dx - radius * 0.45,
      position.dy - hTop * 0.5,
    );

    canvas.save();
    canvas.translate(reflectionCenter.dx, reflectionCenter.dy);
    canvas.rotate(pi / 4); // 45度回転

    final reflectionPath = Path();
    reflectionPath.addOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: radius * 0.35,
        height: radius * 0.7,
      ),
    );

    final reflectionPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    canvas.drawPath(reflectionPath, reflectionPaint);
    canvas.restore();
  }

  /// 進捗インジケーターを描画
  ///
  /// 風船の周囲に円弧で進捗を表示
  void _drawProgressIndicator(Canvas canvas, Offset position, double radius) {
    final progressAngle = 2 * pi * balloon.progressRatio;

    final progressPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: position, radius: radius + 5),
      -pi / 2, // 開始角度（上部）
      progressAngle,
      false,
      progressPaint,
    );
  }

  /// 結び目を描画（有機的な形状）- サンプルコードに合わせた形状
  void _drawKnot(Canvas canvas, Offset position, double radius, double hBottom) {
    // 風船の下端から結び目を配置
    final knotY = position.dy + hBottom - 2;
    final scale = radius / 55; // サンプルのスケール基準

    // 風船本体による結び目への影（先に描画）
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(position.dx, knotY + 1 * scale),
        width: 12 * scale,
        height: 4 * scale,
      ),
      shadowPaint,
    );

    // 結び目のグラデーション（立体感）
    final knotGradient = RadialGradient(
      center: const Alignment(-0.3, -0.2),
      radius: 1.0,
      colors: [
        balloon.color,
        _darkenColor(balloon.color, 0.25),
      ],
    );

    final knotRect = Rect.fromCenter(
      center: Offset(position.dx, knotY + 6 * scale),
      width: 20 * scale,
      height: 14 * scale,
    );

    final knotPaint = Paint()
      ..shader = knotGradient.createShader(knotRect)
      ..style = PaintingStyle.fill;

    // 有機的な結び目の形状（ベジェ曲線）
    final knotPath = Path();
    knotPath.moveTo(position.dx - 3 * scale, knotY);

    // 左側
    knotPath.cubicTo(
      position.dx - 8 * scale, knotY + 2 * scale,
      position.dx - 10 * scale, knotY + 10 * scale,
      position.dx - 4 * scale, knotY + 12 * scale,
    );

    // 下部
    knotPath.cubicTo(
      position.dx, knotY + 14 * scale,
      position.dx, knotY + 14 * scale,
      position.dx + 4 * scale, knotY + 12 * scale,
    );

    // 右側
    knotPath.cubicTo(
      position.dx + 10 * scale, knotY + 10 * scale,
      position.dx + 8 * scale, knotY + 2 * scale,
      position.dx + 3 * scale, knotY,
    );

    knotPath.close();
    canvas.drawPath(knotPath, knotPaint);

    // しわ/折り目（左）
    final creasePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final leftCreasePath = Path();
    leftCreasePath.moveTo(position.dx - 2 * scale, knotY + 4 * scale);
    leftCreasePath.quadraticBezierTo(
      position.dx - 5 * scale, knotY + 8 * scale,
      position.dx - 3 * scale, knotY + 10 * scale,
    );
    canvas.drawPath(leftCreasePath, creasePaint);

    // しわ/折り目（右）
    final rightCreasePath = Path();
    rightCreasePath.moveTo(position.dx + 2 * scale, knotY + 4 * scale);
    rightCreasePath.quadraticBezierTo(
      position.dx + 5 * scale, knotY + 8 * scale,
      position.dx + 3 * scale, knotY + 10 * scale,
    );
    canvas.drawPath(rightCreasePath, creasePaint);
  }

  /// 紐とタグを描画
  void _drawStringAndTag(Canvas canvas, Offset balloonCenter, double radius) {
    // CustomPaint内のローカル座標系からグローバル座標系への変換
    // physicsState.positionは画面全体の座標
    // balloonCenterはCustomPaint内のローカル座標
    // 紐の物理状態も画面全体の座標を使用しているため、
    // ローカル座標系に変換する必要がある

    // 各セグメントをローカル座標に変換
    final localSegments = physicsState.stringState.segments.map((segment) {
      return Offset(
        balloonCenter.dx + (segment.dx - physicsState.position.dx),
        balloonCenter.dy + (segment.dy - physicsState.position.dy),
      );
    }).toList();

    // 紐を描画（滑らかな曲線で接続）- シルバー/ホワイト色
    final paint = Paint()
      ..color = const Color(0xFFCCCCCC) // シルバー
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    if (localSegments.length >= 2) {
      final path = Path();
      path.moveTo(localSegments[0].dx, localSegments[0].dy);

      // Catmull-Rom スプライン曲線で滑らかに接続
      for (int i = 0; i < localSegments.length - 1; i++) {
        final p0 = i > 0 ? localSegments[i - 1] : localSegments[i];
        final p1 = localSegments[i];
        final p2 = localSegments[i + 1];
        final p3 = i < localSegments.length - 2 ? localSegments[i + 2] : localSegments[i + 1];

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

      canvas.drawPath(path, paint);

      // タグ接続部分の小さな結び目
      if (localSegments.isNotEmpty) {
        final stringEnd = localSegments.last;
        canvas.drawCircle(
          stringEnd,
          2,
          Paint()
            ..color = const Color(0xFFBBBBBB)
            ..style = PaintingStyle.fill,
        );
      }
    }

    // タグを描画（ユーザー作成風船のみ）
    if (balloon.tagIconId != null && localSegments.isNotEmpty) {
      final tagPosition = localSegments.last;
      _drawTagLocal(canvas, tagPosition, radius, physicsState.stringState.tagRotation);
    }
  }

  /// タグをローカル座標系で描画（光沢カード型）
  void _drawTagLocal(Canvas canvas, Offset position, double balloonRadius, double rotation) {
    // タグのサイズ（サンプルに合わせて調整）
    const tagBaseSize = 28.0;
    final tagW = tagBaseSize;
    final tagH = tagBaseSize;
    const tagRadius = 6.0;
    const holeY = 5.0;
    const depth = 3.0;

    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(rotation);

    // タグの位置（穴が(0,0)になるように）
    final tagX = -tagW / 2;
    final tagY = -holeY;

    // 色の準備
    final highlightColor = _lightenColor(balloon.color, 0.3);
    final boxColor = _lightenColor(balloon.color, 0.15);

    // 1. タグの厚み（影/奥行き）
    final depthPaint = Paint()
      ..color = _darkenColor(balloon.color, 0.35)
      ..style = PaintingStyle.fill;
    _drawRoundedRect(canvas, tagX + depth, tagY + depth, tagW, tagH, tagRadius, depthPaint);

    // 2. タグ本体（グラデーション）
    final tagGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        highlightColor,
        boxColor,
        balloon.color,
      ],
      stops: const [0.0, 0.4, 1.0],
    );

    final tagRect = Rect.fromLTWH(tagX, tagY, tagW, tagH);
    final tagPaint = Paint()
      ..shader = tagGradient.createShader(tagRect)
      ..style = PaintingStyle.fill;
    _drawRoundedRect(canvas, tagX, tagY, tagW, tagH, tagRadius, tagPaint);

    // 3. 内側のハイライト枠
    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    _drawRoundedRect(canvas, tagX + 2, tagY + 2, tagW - 4, tagH - 4, tagRadius - 1, borderPaint);

    // 4. 光沢反射（左上の斜め）
    canvas.save();
    final clipPath = Path();
    _addRoundedRectToPath(clipPath, tagX, tagY, tagW, tagH, tagRadius);
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

    // 5. 穴（グロメット）
    // 穴のリム（外側）
    canvas.drawCircle(
      Offset.zero,
      5,
      Paint()
        ..color = const Color(0xFFE0E0E0)
        ..style = PaintingStyle.fill,
    );
    // 穴（内側 - 暗い）
    canvas.drawCircle(
      Offset.zero,
      3,
      Paint()
        ..color = const Color(0xFF666666)
        ..style = PaintingStyle.fill,
    );
    // 穴のハイライトリング
    canvas.drawCircle(
      Offset.zero,
      5,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // 6. アイコンを描画
    if (balloon.tagIconId != null) {
      final iconCenterX = tagX + tagW / 2;
      final iconCenterY = tagY + tagH / 2 + 2;
      final iconSize = tagBaseSize * 0.4;
      _drawTagIcon(canvas, balloon.tagIconId!, iconSize, Offset(iconCenterX, iconCenterY));
    }

    canvas.restore();
  }

  /// 角丸四角形を描画
  void _drawRoundedRect(Canvas canvas, double x, double y, double w, double h, double r, Paint paint) {
    final path = Path();
    _addRoundedRectToPath(path, x, y, w, h, r);
    canvas.drawPath(path, paint);
  }

  /// 角丸四角形をPathに追加
  void _addRoundedRectToPath(Path path, double x, double y, double w, double h, double r) {
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
  }

  /// タグアイコンを描画
  void _drawTagIcon(Canvas canvas, int iconId, double size, Offset center) {
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

  /// ハートアイコンを描画
  void _drawHeartIcon(Canvas canvas, Paint paint, double radius) {
    final path = Path();
    path.moveTo(0, radius * 0.7);
    path.cubicTo(radius, 0, radius, -radius, 0, -radius * 0.6);
    path.cubicTo(-radius, -radius, -radius, 0, 0, radius * 0.7);
    path.close();
    canvas.drawPath(path, paint);
  }

  /// 六角形アイコンを描画
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

  /// 花アイコンを描画
  void _drawFlowerIcon(Canvas canvas, Paint paint, double radius) {
    // 5枚の花びら
    for (var i = 0; i < 5; i++) {
      final angle = (pi * 2 * i) / 5;
      final cx = cos(angle) * radius * 0.5;
      final cy = sin(angle) * radius * 0.5;
      canvas.drawCircle(Offset(cx, cy), radius * 0.4, paint);
    }
    // 中心
    canvas.drawCircle(Offset.zero, radius * 0.3, paint);
  }

  /// 星アイコンを描画
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
      // 内側の点
      final innerAngle = angle + pi / 5;
      final innerX = cos(innerAngle) * radius * 0.5;
      final innerY = sin(innerAngle) * radius * 0.5;
      path.lineTo(innerX, innerY);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  /// 地面への影を描画（右斜め下、タグに少しかかる位置）
  void _drawGroundShadow(Canvas canvas, Offset balloonCenter, double radius) {
    // 新しい卵型形状に合わせた比率
    final hBottom = radius * 1.45;
    // 紐の長さを考慮（BalloonStringPhysicsのlengthMultiplier = 1.8）
    final stringLength = radius * 1.8;

    // 影は風船の右斜め下に配置（タグに少しかかる位置）
    final shadowX = balloonCenter.dx + radius * 0.8; // 右にオフセット
    final shadowY = balloonCenter.dy + hBottom + stringLength * 0.7; // タグの少し上

    final shadowCenter = Offset(shadowX, shadowY);

    // 影の透明度は固定
    const shadowOpacity = 0.15;

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: shadowOpacity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6.0);

    // 楕円の影（少し大きめ）
    canvas.drawOval(
      Rect.fromCenter(
        center: shadowCenter,
        width: radius * 1.5,
        height: radius * 0.6,
      ),
      shadowPaint,
    );
  }

  /// 選択状態のリングを描画
  void _drawSelectionRing(Canvas canvas, Offset position, double radius) {
    final ringPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    canvas.drawCircle(position, radius + 8, ringPaint);
  }

  /// デバッグ用：衝突判定の円を描画
  void _drawDebugCircle(Canvas canvas, Offset position, double radius) {
    final debugPaint = Paint()
      ..color = Colors.red.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(position, radius, debugPaint);

    // 中心点
    final centerPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, 2, centerPaint);
  }

  /// 色を明るくする
  Color _lightenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  /// 色を暗くする
  Color _darkenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  @override
  bool shouldRepaint(covariant BalloonPainter oldDelegate) {
    // 位置や状態が変わったら再描画
    return oldDelegate.physicsState != physicsState ||
        oldDelegate.balloon != balloon ||
        oldDelegate.debugMode != debugMode;
  }
}

/// 風船ウィジェット
///
/// BalloonPainter を使用して風船を表示
class BalloonWidget extends StatelessWidget {
  /// 風船エンティティ
  final Balloon balloon;

  /// 物理状態
  final BalloonPhysicsState physicsState;

  /// デバッグモード
  final bool debugMode;

  /// タップコールバック
  final VoidCallback? onTap;

  const BalloonWidget({
    super.key,
    required this.balloon,
    required this.physicsState,
    this.debugMode = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = balloon.currentRadius;
    // 新しい卵型形状に合わせた比率（_drawBalloonと同じ値）
    final hTop = radius * 1.27; // 上部の高さ
    final hBottom = radius * 1.45; // 下部の高さ
    final width = radius * 3; // 横幅（w * 1.5 * 2）
    final height = hTop + hBottom;

    return Positioned(
      left: physicsState.position.dx - width / 2,
      top: physicsState.position.dy - hTop,
      child: GestureDetector(
        onTap: onTap,
        child: CustomPaint(
          size: Size(width, height),
          painter: BalloonPainter(
            balloon: balloon,
            physicsState: physicsState,
            debugMode: debugMode,
          ),
        ),
      ),
    );
  }
}
