/// Balloon Content Renderer
///
/// 風船の本体に描画するコンテンツ（ブランドアイコン、国旗など）
library;

import 'dart:math';

import 'package:flutter/material.dart';

/// 風船のコンテンツタイプ
sealed class BalloonContent {
  const BalloonContent();
}

/// 形状コンテンツ（Circle, Square, Triangle など）
class ShapeContent extends BalloonContent {
  final int shapeType;
  const ShapeContent(this.shapeType);
}

/// 絵文字/国旗コンテンツ
class EmojiContent extends BalloonContent {
  final String emoji;
  final String? flagCode;
  const EmojiContent(this.emoji, {this.flagCode});
}

/// ブランドアイコンコンテンツ
class BrandContent extends BalloonContent {
  final BrandType brand;
  const BrandContent(this.brand);
}

/// ブランドタイプ
enum BrandType {
  github,
  gitlab,
  npm,
  react,
  apple,
  android,
  flutter,
  docker,
  kubernetes,
  aws,
  gcp,
  azure,
}

/// 風船コンテンツレンダラー
class BalloonContentRenderer {
  const BalloonContentRenderer();

  /// コンテンツを描画
  void render({
    required Canvas canvas,
    required Offset position,
    required double size,
    required BalloonContent content,
    double opacity = 0.9,
  }) {
    canvas.save();
    canvas.translate(position.dx, position.dy);

    switch (content) {
      case ShapeContent(:final shapeType):
        _drawShape(canvas, size, shapeType, opacity);
      case EmojiContent(:final flagCode):
        if (flagCode != null) {
          // 国旗の場合はフラグパターンで処理（別レンダラー）
          // ここでは簡易的にテキスト表示
          _drawEmoji(canvas, size, content.emoji, opacity);
        } else {
          _drawEmoji(canvas, size, content.emoji, opacity);
        }
      case BrandContent(:final brand):
        _drawBrand(canvas, size, brand, opacity);
    }

    canvas.restore();
  }

  /// 形状を描画
  void _drawShape(Canvas canvas, double size, int type, double opacity) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.white.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size * 0.15
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final halfSize = size / 2;

    switch (type) {
      case 1: // Circle
        canvas.drawCircle(Offset.zero, halfSize, paint);
      case 2: // Square
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: size, height: size),
          paint,
        );
      case 3: // Triangle
        final path = Path()
          ..moveTo(0, -halfSize)
          ..lineTo(halfSize, halfSize)
          ..lineTo(-halfSize, halfSize)
          ..close();
        canvas.drawPath(path, paint);
      case 4: // Star
        _drawStar(canvas, halfSize, 5, halfSize * 0.4, paint);
      case 5: // Heart
        _drawHeart(canvas, halfSize, paint);
      case 6: // Diamond
        final path = Path()
          ..moveTo(0, -halfSize)
          ..lineTo(halfSize, 0)
          ..lineTo(0, halfSize)
          ..lineTo(-halfSize, 0)
          ..close();
        canvas.drawPath(path, paint);
      case 7: // Hexagon
        _drawPolygon(canvas, halfSize, 6, paint);
      case 8: // Cross
        final path = Path()
          ..moveTo(-halfSize, 0)
          ..lineTo(halfSize, 0)
          ..moveTo(0, -halfSize)
          ..lineTo(0, halfSize);
        canvas.drawPath(path, strokePaint);
      case 9: // Wave
        final path = Path()
          ..moveTo(-halfSize, 0)
          ..cubicTo(
            -halfSize + size * 0.25, -size * 0.4,
            -halfSize + size * 0.25, size * 0.4,
            0, 0,
          )
          ..cubicTo(
            halfSize - size * 0.25, -size * 0.4,
            halfSize - size * 0.25, size * 0.4,
            halfSize, 0,
          );
        canvas.drawPath(path, strokePaint);
      case 10: // Dot
        canvas.drawCircle(Offset.zero, halfSize * 0.4, paint);
      case 11: // Ring (Donut)
        final ringPath = Path()
          ..addOval(Rect.fromCircle(center: Offset.zero, radius: halfSize))
          ..addOval(Rect.fromCircle(center: Offset.zero, radius: halfSize * 0.6))
          ..fillType = PathFillType.evenOdd;
        canvas.drawPath(ringPath, paint);
      case 12: // Flower
        _drawFlower(canvas, halfSize, paint);
    }
  }

  /// 星形を描画
  void _drawStar(Canvas canvas, double outerRadius, int points, double innerRadius, Paint paint) {
    final path = Path();
    double rot = -pi / 2;
    final step = pi / points;

    path.moveTo(0, -outerRadius);
    for (int i = 0; i < points; i++) {
      final outerX = cos(rot) * outerRadius;
      final outerY = sin(rot) * outerRadius;
      path.lineTo(outerX, outerY);
      rot += step;

      final innerX = cos(rot) * innerRadius;
      final innerY = sin(rot) * innerRadius;
      path.lineTo(innerX, innerY);
      rot += step;
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  /// ハート形を描画
  void _drawHeart(Canvas canvas, double radius, Paint paint) {
    final path = Path()
      ..moveTo(0, radius * 0.7)
      ..cubicTo(
        radius, 0,
        radius, -radius,
        0, -radius * 0.6,
      )
      ..cubicTo(
        -radius, -radius,
        -radius, 0,
        0, radius * 0.7,
      )
      ..close();
    canvas.drawPath(path, paint);
  }

  /// 多角形を描画
  void _drawPolygon(Canvas canvas, double radius, int sides, Paint paint) {
    final path = Path();
    final angle = (pi * 2) / sides;
    for (int i = 0; i < sides; i++) {
      final px = radius * cos(angle * i - pi / 2);
      final py = radius * sin(angle * i - pi / 2);
      if (i == 0) {
        path.moveTo(px, py);
      } else {
        path.lineTo(px, py);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  /// 花形を描画
  void _drawFlower(Canvas canvas, double radius, Paint paint) {
    final petalRadius = radius * 0.5;
    for (int i = 0; i < 5; i++) {
      final angle = (pi * 2 * i) / 5;
      final cx = cos(angle) * petalRadius;
      final cy = sin(angle) * petalRadius;
      canvas.drawCircle(Offset(cx, cy), petalRadius, paint);
    }
    // Center
    canvas.drawCircle(Offset.zero, petalRadius * 0.5, paint);
  }

  /// 絵文字を描画
  void _drawEmoji(Canvas canvas, double size, String emoji, double opacity) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: emoji,
        style: TextStyle(
          fontSize: size,
          color: Colors.white.withValues(alpha: opacity),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );
  }

  /// ブランドアイコンを描画
  void _drawBrand(Canvas canvas, double size, BrandType brand, double opacity) {
    final scale = size / 24;
    canvas.scale(scale, scale);

    final paint = Paint()
      ..color = Colors.white.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    switch (brand) {
      case BrandType.github:
        _drawGitHubIcon(canvas, paint);
      case BrandType.gitlab:
        _drawGitLabIcon(canvas, paint);
      case BrandType.npm:
        _drawNpmIcon(canvas, paint);
      case BrandType.react:
        _drawReactIcon(canvas, opacity);
      case BrandType.apple:
        _drawAppleIcon(canvas, paint);
      case BrandType.android:
        _drawAndroidIcon(canvas, paint);
      case BrandType.flutter:
        _drawFlutterIcon(canvas, paint);
      case BrandType.docker:
        _drawDockerIcon(canvas, paint);
      case BrandType.kubernetes:
        _drawKubernetesIcon(canvas, paint);
      case BrandType.aws:
        _drawAwsIcon(canvas, paint);
      case BrandType.gcp:
        _drawGcpIcon(canvas, paint);
      case BrandType.azure:
        _drawAzureIcon(canvas, paint);
    }
  }

  /// GitHub アイコン（Octocat シルエット）
  void _drawGitHubIcon(Canvas canvas, Paint paint) {
    // Head
    canvas.drawCircle(Offset.zero, 10, paint);

    // Left ear
    final leftEar = Path()
      ..moveTo(-8, -4)
      ..lineTo(-8, -10)
      ..lineTo(-3, -8)
      ..close();
    canvas.drawPath(leftEar, paint);

    // Right ear
    final rightEar = Path()
      ..moveTo(8, -4)
      ..lineTo(8, -10)
      ..lineTo(3, -8)
      ..close();
    canvas.drawPath(rightEar, paint);

    // Face (shadow)
    final facePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(0, 2), width: 12, height: 8),
      facePaint,
    );
  }

  /// GitLab アイコン（狐）
  void _drawGitLabIcon(Canvas canvas, Paint paint) {
    final gitlabPaint = Paint()
      ..color = const Color(0xFFE24329)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 10)
      ..lineTo(-6, -6)
      ..lineTo(-3, -6)
      ..lineTo(-2, 2)
      ..lineTo(2, 2)
      ..lineTo(3, -6)
      ..lineTo(6, -6)
      ..close();
    canvas.drawPath(path, gitlabPaint);
  }

  /// npm アイコン
  void _drawNpmIcon(Canvas canvas, Paint paint) {
    final npmPaint = Paint()
      ..color = const Color(0xFFCB3837)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      const Rect.fromLTWH(-10, -8, 20, 16),
      npmPaint,
    );

    // 'n' shape inside
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawRect(const Rect.fromLTWH(-7, -5, 4, 10), whitePaint);
    canvas.drawRect(const Rect.fromLTWH(-3, -5, 4, 7), whitePaint);
    canvas.drawRect(const Rect.fromLTWH(1, -5, 4, 10), whitePaint);
  }

  /// React アイコン（軌道）
  void _drawReactIcon(Canvas canvas, double opacity) {
    final reactPaint = Paint()
      ..color = const Color(0xFF61DAFB).withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final centerPaint = Paint()
      ..color = const Color(0xFF61DAFB).withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    // Center dot
    canvas.drawCircle(Offset.zero, 2, centerPaint);

    // Three orbits
    canvas.save();
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 20, height: 7),
      reactPaint,
    );
    canvas.restore();

    canvas.save();
    canvas.rotate(pi / 3);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 20, height: 7),
      reactPaint,
    );
    canvas.restore();

    canvas.save();
    canvas.rotate(-pi / 3);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 20, height: 7),
      reactPaint,
    );
    canvas.restore();
  }

  /// Apple アイコン
  void _drawAppleIcon(Canvas canvas, Paint paint) {
    // Simplified apple shape
    final path = Path()
      ..moveTo(0, -10)
      ..cubicTo(5, -10, 10, -5, 10, 2)
      ..cubicTo(10, 8, 5, 12, 0, 12)
      ..cubicTo(-5, 12, -10, 8, -10, 2)
      ..cubicTo(-10, -5, -5, -10, 0, -10)
      ..close();
    canvas.drawPath(path, paint);

    // Leaf
    final leafPath = Path()
      ..moveTo(0, -10)
      ..quadraticBezierTo(5, -14, 4, -12);
    final leafPaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(leafPath, leafPaint);
  }

  /// Android アイコン
  void _drawAndroidIcon(Canvas canvas, Paint paint) {
    final androidPaint = Paint()
      ..color = const Color(0xFF3DDC84)
      ..style = PaintingStyle.fill;

    // Head
    canvas.drawArc(
      Rect.fromCenter(center: const Offset(0, -4), width: 16, height: 16),
      pi,
      pi,
      true,
      androidPaint,
    );

    // Eyes
    final eyePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(-4, -6), 1.5, eyePaint);
    canvas.drawCircle(const Offset(4, -6), 1.5, eyePaint);

    // Antennas
    final antennaPaint = Paint()
      ..color = const Color(0xFF3DDC84)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(-5, -10), const Offset(-7, -14), antennaPaint);
    canvas.drawLine(const Offset(5, -10), const Offset(7, -14), antennaPaint);

    // Body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-8, 0, 16, 12),
        const Radius.circular(2),
      ),
      androidPaint,
    );
  }

  /// Flutter アイコン
  void _drawFlutterIcon(Canvas canvas, Paint paint) {
    final bluePaint = Paint()
      ..color = const Color(0xFF02569B)
      ..style = PaintingStyle.fill;

    final cyanPaint = Paint()
      ..color = const Color(0xFF45D1FD)
      ..style = PaintingStyle.fill;

    // Upper part
    final upperPath = Path()
      ..moveTo(-8, 0)
      ..lineTo(4, -12)
      ..lineTo(4, -4)
      ..lineTo(-4, 4)
      ..close();
    canvas.drawPath(upperPath, bluePaint);

    // Lower part
    final lowerPath = Path()
      ..moveTo(-4, 4)
      ..lineTo(4, -4)
      ..lineTo(4, 4)
      ..lineTo(-4, 12)
      ..close();
    canvas.drawPath(lowerPath, cyanPaint);
  }

  /// Docker アイコン
  void _drawDockerIcon(Canvas canvas, Paint paint) {
    final dockerPaint = Paint()
      ..color = const Color(0xFF2496ED)
      ..style = PaintingStyle.fill;

    // Whale body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-10, -2, 18, 8),
        const Radius.circular(2),
      ),
      dockerPaint,
    );

    // Containers
    for (int row = 0; row < 2; row++) {
      for (int col = 0; col < 4; col++) {
        canvas.drawRect(
          Rect.fromLTWH(-9.0 + col * 4, -10.0 + row * 4, 3, 3),
          dockerPaint,
        );
      }
    }

    // Tail
    final tailPath = Path()
      ..moveTo(-10, 2)
      ..lineTo(-12, 0)
      ..lineTo(-10, -2);
    canvas.drawPath(tailPath, dockerPaint);
  }

  /// Kubernetes アイコン
  void _drawKubernetesIcon(Canvas canvas, Paint paint) {
    final k8sPaint = Paint()
      ..color = const Color(0xFF326CE5)
      ..style = PaintingStyle.fill;

    // Helm wheel
    _drawPolygon(canvas, 10, 7, k8sPaint);

    // Inner circle
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, 5, whitePaint);
  }

  /// AWS アイコン
  void _drawAwsIcon(Canvas canvas, Paint paint) {
    final awsPaint = Paint()
      ..color = const Color(0xFFFF9900)
      ..style = PaintingStyle.fill;

    // Arrow/smile shape
    final path = Path()
      ..moveTo(-10, 0)
      ..quadraticBezierTo(0, 8, 10, 0)
      ..lineTo(8, -2)
      ..quadraticBezierTo(0, 5, -8, -2)
      ..close();
    canvas.drawPath(path, awsPaint);

    // Text A
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'A',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(-textPainter.width / 2, -10));
  }

  /// GCP アイコン
  void _drawGcpIcon(Canvas canvas, Paint paint) {
    // Simplified cloud
    final cloudPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(const Offset(-4, 0), 6, cloudPaint);
    canvas.drawCircle(const Offset(4, 0), 6, cloudPaint);
    canvas.drawCircle(const Offset(0, -4), 5, cloudPaint);
  }

  /// Azure アイコン
  void _drawAzureIcon(Canvas canvas, Paint paint) {
    final azurePaint = Paint()
      ..color = const Color(0xFF0078D4)
      ..style = PaintingStyle.fill;

    // A shape
    final path = Path()
      ..moveTo(-8, 8)
      ..lineTo(0, -10)
      ..lineTo(8, 8)
      ..lineTo(4, 8)
      ..lineTo(2, 2)
      ..lineTo(-2, 2)
      ..lineTo(-4, 8)
      ..close();
    canvas.drawPath(path, azurePaint);
  }
}
