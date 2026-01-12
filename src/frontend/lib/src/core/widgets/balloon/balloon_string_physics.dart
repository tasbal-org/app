/// Balloon String Physics
///
/// 風船の紐とタグの物理演算
/// バネモデルによる揺れアニメーション
library;

import 'dart:math';

import 'package:flutter/material.dart';

/// 紐の物理状態
class StringPhysicsState {
  /// 紐の制御点リスト（セグメント化された紐の各点）
  final List<Offset> segments;

  /// 各セグメントの速度
  final List<Offset> velocities;

  /// タグの回転角度（ラジアン）
  final double tagRotation;

  /// タグの回転速度
  final double tagAngularVelocity;

  const StringPhysicsState({
    required this.segments,
    required this.velocities,
    this.tagRotation = 0.0,
    this.tagAngularVelocity = 0.0,
  });

  /// 紐の終端位置（タグの位置）- 後方互換性のため
  Offset get endPoint => segments.last;

  /// 紐の速度（終端の速度）- 後方互換性のため
  Offset get velocity => velocities.last;

  StringPhysicsState copyWith({
    List<Offset>? segments,
    List<Offset>? velocities,
    double? tagRotation,
    double? tagAngularVelocity,
  }) {
    return StringPhysicsState(
      segments: segments ?? this.segments,
      velocities: velocities ?? this.velocities,
      tagRotation: tagRotation ?? this.tagRotation,
      tagAngularVelocity: tagAngularVelocity ?? this.tagAngularVelocity,
    );
  }
}

/// 紐の物理エンジン
///
/// バネモデルによる自然な揺れを実現
class BalloonStringPhysics {
  /// バネの強さ（縦方向）
  static const double verticalStiffness = 0.3;

  /// バネの強さ（横方向 - 真下に戻る力）
  static const double horizontalStiffness = 0.5;

  /// 減衰係数
  static const double damping = 0.85;

  /// タグの回転減衰
  static const double rotationDamping = 0.95;

  /// 紐の長さ（風船半径の倍数）
  static const double lengthMultiplier = 1.8;

  /// タグサイズ（風船半径の倍数）
  static const double tagSizeMultiplier = 0.35;

  /// 紐のセグメント数（多いほど柔らかい）
  static const int segmentCount = 5;

  final Random _random = Random();

  /// 初期状態を生成
  StringPhysicsState createInitialState({
    required Offset balloonPosition,
    required double balloonRadius,
  }) {
    final stringLength = balloonRadius * lengthMultiplier;
    final segmentLength = stringLength / segmentCount;

    // 紐の開始位置は風船の下端（結び目の位置）
    const hBottomRatio = 1.45; // BalloonPainterと同じ卵型形状の比率
    final knotY = balloonPosition.dy + balloonRadius * hBottomRatio + 4;

    // 各セグメントの初期位置を生成（真下に配置）
    final segments = <Offset>[];
    final velocities = <Offset>[];
    final randomOffset = (_random.nextDouble() - 0.5) * balloonRadius * 0.2;

    for (int i = 0; i <= segmentCount; i++) {
      segments.add(Offset(
        balloonPosition.dx + randomOffset * (i / segmentCount),
        knotY + segmentLength * i,
      ));
      velocities.add(Offset.zero);
    }

    return StringPhysicsState(
      segments: segments,
      velocities: velocities,
      tagRotation: (_random.nextDouble() - 0.5) * 0.2, // ±0.1ラジアン
      tagAngularVelocity: 0.0,
    );
  }

  /// 最大deltaTime（これ以上大きい場合はリセット）
  static const double maxDeltaTime = 0.1; // 100ms

  /// deltaTimeのクランプ値（通常の物理演算用）
  static const double clampedDeltaTime = 0.016; // 約60fps相当

  /// 物理状態を更新
  StringPhysicsState updateState({
    required StringPhysicsState state,
    required Offset balloonPosition,
    required double balloonRadius,
    required double deltaTime,
  }) {
    final stringLength = balloonRadius * lengthMultiplier;
    final segmentLength = stringLength / segmentCount;

    // アプリがバックグラウンドから復帰した場合など、deltaTimeが大きすぎる場合はリセット
    if (deltaTime > maxDeltaTime) {
      return createInitialState(
        balloonPosition: balloonPosition,
        balloonRadius: balloonRadius,
      );
    }

    // deltaTimeをクランプして安定した物理演算を行う
    final clampedDt = deltaTime.clamp(0.001, clampedDeltaTime);

    // 紐の開始位置は風船の下端（結び目の位置）
    const hBottomRatio = 1.45; // BalloonPainterと同じ卵型形状の比率
    final knotPosition = Offset(
      balloonPosition.dx,
      balloonPosition.dy + balloonRadius * hBottomRatio + 4,
    );

    final newSegments = List<Offset>.from(state.segments);
    final newVelocities = List<Offset>.from(state.velocities);

    // 最初のセグメントは風船の結び目に固定
    newSegments[0] = knotPosition;
    newVelocities[0] = Offset.zero;

    // 各セグメントを物理演算で更新（Verlet積分）
    for (int i = 1; i < newSegments.length; i++) {
      // 重力
      const gravity = Offset(0, 30.0);

      // 前のセグメントへの制約力
      final prevSegment = newSegments[i - 1];
      final towardPrev = prevSegment - newSegments[i];
      final distanceToPrev = sqrt(towardPrev.dx * towardPrev.dx + towardPrev.dy * towardPrev.dy);

      Offset constraintForce = Offset.zero;
      if (distanceToPrev > 0.001) {
        // 理想的な距離からのずれを修正
        final error = distanceToPrev - segmentLength;
        final direction = towardPrev / distanceToPrev;
        constraintForce = direction * error * 10.0; // バネ定数
      }

      // 空気抵抗
      final drag = newVelocities[i] * -2.0;

      // 力を合成
      final totalForce = gravity + constraintForce + drag;

      // 速度更新
      newVelocities[i] = newVelocities[i] + totalForce * clampedDt;
      newVelocities[i] = newVelocities[i] * 0.98; // 減衰

      // 位置更新
      newSegments[i] = newSegments[i] + newVelocities[i] * clampedDt;
    }

    // 制約の適用（各セグメント間の距離を強制）
    for (int iteration = 0; iteration < 3; iteration++) {
      for (int i = 1; i < newSegments.length; i++) {
        final prevSegment = newSegments[i - 1];
        final currentSegment = newSegments[i];
        final delta = currentSegment - prevSegment;
        final distance = sqrt(delta.dx * delta.dx + delta.dy * delta.dy);

        if (distance > 0.001) {
          final direction = delta / distance;
          final correction = direction * (distance - segmentLength) * 0.5;

          // 前のセグメントが固定されていない場合のみ移動
          if (i > 1) {
            newSegments[i - 1] = prevSegment + correction;
          }
          newSegments[i] = currentSegment - correction;
        }
      }
    }

    // タグの回転更新（最後の2セグメントの角度）
    final lastSegment = newSegments[newSegments.length - 1];
    final secondLastSegment = newSegments[newSegments.length - 2];
    final stringDirection = lastSegment - secondLastSegment;
    final targetRotation = atan2(stringDirection.dx, stringDirection.dy).clamp(-0.3, 0.3);

    final rotationDiff = targetRotation - state.tagRotation;
    var newAngularVelocity = state.tagAngularVelocity + rotationDiff * 0.1;
    newAngularVelocity *= 0.92;

    final newTagRotation = (state.tagRotation + newAngularVelocity * clampedDt)
        .clamp(-0.3, 0.3);

    return StringPhysicsState(
      segments: newSegments,
      velocities: newVelocities,
      tagRotation: newTagRotation,
      tagAngularVelocity: newAngularVelocity,
    );
  }

  /// 紐を描画
  void drawString({
    required Canvas canvas,
    required Offset balloonPosition,
    required double balloonRadius,
    required StringPhysicsState state,
    required Color balloonColor,
  }) {
    // 紐の開始位置は結び目の位置
    const hBottomRatio = 1.45; // BalloonPainterと同じ卵型形状の比率
    final anchorPoint = Offset(
      balloonPosition.dx,
      balloonPosition.dy + balloonRadius * hBottomRatio + 4,
    );

    final paint = Paint()
      ..color = balloonColor.withValues(alpha: 0.7)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // 紐を曲線で描画（より自然な揺れ）
    final path = Path();
    path.moveTo(anchorPoint.dx, anchorPoint.dy);

    // 中間制御点
    final midPoint = Offset(
      (anchorPoint.dx + state.endPoint.dx) / 2 + state.velocity.dx * 0.1,
      (anchorPoint.dy + state.endPoint.dy) / 2,
    );

    path.quadraticBezierTo(
      midPoint.dx,
      midPoint.dy,
      state.endPoint.dx,
      state.endPoint.dy,
    );

    canvas.drawPath(path, paint);
  }

  /// タグを描画（アイソメトリック立方体）
  void drawTag({
    required Canvas canvas,
    required StringPhysicsState state,
    required double balloonRadius,
    required Color balloonColor,
    required int tagIconId,
  }) {
    final tagSize = balloonRadius * tagSizeMultiplier;

    canvas.save();

    // タグの位置に移動
    canvas.translate(state.endPoint.dx, state.endPoint.dy);

    // わずかな回転を適用
    canvas.rotate(state.tagRotation);

    // タグの色（風船色の彩度を下げる）
    final tagColor = _desaturateColor(balloonColor);

    // アイソメトリック立方体を描画
    _drawIsometricCube(canvas, tagSize, tagColor);

    // タグアイコン（シンボル）を上面に描画
    _drawTagIcon(canvas, tagIconId, tagSize);

    canvas.restore();
  }

  /// 立方体をアイソメトリック投影で描画
  void _drawIsometricCube(Canvas canvas, double size, Color color) {
    const angle = pi / 6; // 30度
    final halfSize = size / 2;

    // 上面（明るい）
    final topPath = Path()
      ..moveTo(0, -size * 0.3)
      ..lineTo(-cos(angle) * halfSize, -size * 0.3 - sin(angle) * halfSize)
      ..lineTo(0, -size * 0.3 - halfSize)
      ..lineTo(cos(angle) * halfSize, -size * 0.3 - sin(angle) * halfSize)
      ..close();

    canvas.drawPath(
      topPath,
      Paint()
        ..color = _brightenColor(color, 0.2)
        ..style = PaintingStyle.fill,
    );

    // 左面（中間）
    final leftPath = Path()
      ..moveTo(-cos(angle) * halfSize, -size * 0.3 - sin(angle) * halfSize)
      ..lineTo(-cos(angle) * halfSize, size * 0.3 - sin(angle) * halfSize)
      ..lineTo(0, size * 0.3)
      ..lineTo(0, -size * 0.3)
      ..close();

    canvas.drawPath(
      leftPath,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );

    // 右面（暗い）
    final rightPath = Path()
      ..moveTo(cos(angle) * halfSize, -size * 0.3 - sin(angle) * halfSize)
      ..lineTo(cos(angle) * halfSize, size * 0.3 - sin(angle) * halfSize)
      ..lineTo(0, size * 0.3)
      ..lineTo(0, -size * 0.3)
      ..close();

    canvas.drawPath(
      rightPath,
      Paint()
        ..color = _darkenColor(color, 0.2)
        ..style = PaintingStyle.fill,
    );
  }

  /// 色の彩度を下げる
  Color _desaturateColor(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withSaturation(hsl.saturation * 0.6).toColor();
  }

  /// 色を明るくする
  Color _brightenColor(Color color, double amount) {
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

  /// タグアイコンを描画
  void _drawTagIcon(Canvas canvas, int tagIconId, double size) {
    final iconPaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final halfSize = size * 0.5;

    switch (tagIconId) {
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
        _drawStar(canvas, iconPaint, halfSize);
        break;
      case 5: // ハート
        _drawHeart(canvas, iconPaint, halfSize);
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
        _drawHexagon(canvas, iconPaint, halfSize);
        break;
      case 8: // クロス
        canvas.drawLine(
          Offset(-halfSize, 0),
          Offset(halfSize, 0),
          iconPaint,
        );
        canvas.drawLine(
          Offset(0, -halfSize),
          Offset(0, halfSize),
          iconPaint,
        );
        break;
      case 9: // 波
        _drawWave(canvas, iconPaint, halfSize);
        break;
      case 10: // ドット
        final dotPaint = Paint()
          ..color = const Color(0xFFFFFFFF)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset.zero, halfSize * 0.3, dotPaint);
        break;
      case 11: // リング
        canvas.drawCircle(Offset.zero, halfSize, iconPaint);
        canvas.drawCircle(Offset.zero, halfSize * 0.6, iconPaint);
        break;
      case 12: // 花
        _drawFlower(canvas, iconPaint, halfSize);
        break;
      default:
        canvas.drawCircle(Offset.zero, halfSize, iconPaint);
    }
  }

  void _drawStar(Canvas canvas, Paint paint, double radius) {
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

  void _drawHeart(Canvas canvas, Paint paint, double radius) {
    final path = Path();
    path.moveTo(0, radius * 0.3);
    path.cubicTo(
      -radius, -radius * 0.5,
      -radius * 0.5, -radius,
      0, -radius * 0.3,
    );
    path.cubicTo(
      radius * 0.5, -radius,
      radius, -radius * 0.5,
      0, radius * 0.3,
    );
    canvas.drawPath(path, paint);
  }

  void _drawHexagon(Canvas canvas, Paint paint, double radius) {
    final path = Path();
    for (var i = 0; i < 6; i++) {
      final angle = (pi / 3) * i;
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

  void _drawWave(Canvas canvas, Paint paint, double radius) {
    final path = Path();
    path.moveTo(-radius, 0);
    path.quadraticBezierTo(-radius * 0.5, -radius * 0.5, 0, 0);
    path.quadraticBezierTo(radius * 0.5, radius * 0.5, radius, 0);
    canvas.drawPath(path, paint);
  }

  void _drawFlower(Canvas canvas, Paint paint, double radius) {
    for (var i = 0; i < 6; i++) {
      final angle = (pi / 3) * i;
      final x = cos(angle) * radius * 0.6;
      final y = sin(angle) * radius * 0.6;
      canvas.drawCircle(Offset(x, y), radius * 0.3, paint);
    }
    canvas.drawCircle(Offset.zero, radius * 0.25, paint);
  }
}
