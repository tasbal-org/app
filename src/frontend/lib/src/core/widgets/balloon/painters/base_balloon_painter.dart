/// Base Balloon Painter
///
/// 風船の基底 Painter クラス
/// 継承して各種風船タイプ（標準、ロケーション、深呼吸など）を実装可能
library;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tasbal/src/core/widgets/balloon/renderers/balloon_body_renderer.dart';
import 'package:tasbal/src/core/widgets/balloon/renderers/balloon_shadow_renderer.dart';
import 'package:tasbal/src/core/widgets/balloon/renderers/balloon_string_renderer.dart';
import 'package:tasbal/src/core/widgets/balloon/renderers/balloon_tag_renderer.dart';
import 'package:tasbal/src/features/balloon/domain/entities/balloon.dart';
import 'package:tasbal/src/features/balloon/domain/physics/balloon_physics.dart';

/// 風船の基底 Painter
///
/// 標準的な風船の描画を行う。
/// 継承して各種風船タイプをカスタマイズ可能。
///
/// ## 拡張ポイント
/// - [renderBody] - 風船本体の描画をオーバーライド
/// - [renderStringAndTag] - 紐とタグの描画をオーバーライド
/// - [renderShadow] - 影の描画をオーバーライド
/// - [renderOverlay] - 追加のオーバーレイ描画（進捗インジケーターなど）
/// - [renderDebug] - デバッグ表示をオーバーライド
abstract class BaseBalloonPainter extends CustomPainter {
  /// 風船エンティティ
  final Balloon balloon;

  /// 物理状態
  final BalloonPhysicsState physicsState;

  /// デバッグモード
  final bool debugMode;

  /// レンダラー群（サブクラスで差し替え可能）
  @protected
  final BalloonBodyRenderer bodyRenderer;
  @protected
  final BalloonStringRenderer stringRenderer;
  @protected
  final BalloonTagRenderer tagRenderer;
  @protected
  final BalloonShadowRenderer shadowRenderer;

  BaseBalloonPainter({
    required this.balloon,
    required this.physicsState,
    this.debugMode = false,
    BalloonBodyRenderer? bodyRenderer,
    BalloonStringRenderer? stringRenderer,
    BalloonTagRenderer? tagRenderer,
    BalloonShadowRenderer? shadowRenderer,
  })  : bodyRenderer = bodyRenderer ?? const BalloonBodyRenderer(),
        stringRenderer = stringRenderer ?? const BalloonStringRenderer(),
        tagRenderer = tagRenderer ?? const BalloonTagRenderer(),
        shadowRenderer = shadowRenderer ?? const BalloonShadowRenderer();

  @override
  void paint(Canvas canvas, Size size) {
    final radius = balloon.currentRadius;
    final hTop = radius * BalloonBodyConstants.hTopRatio;

    // 中心座標を計算
    final center = Offset(size.width / 2, hTop);

    // 描画順序（後ろから前へ）
    renderShadow(canvas, center, radius);
    renderStringAndTag(canvas, center, radius);
    renderBody(canvas, center, radius);
    renderOverlay(canvas, center, radius);

    if (balloon.isSelected) {
      renderSelectionRing(canvas, center, radius);
    }

    if (debugMode) {
      renderDebug(canvas, center, radius);
    }
  }

  /// 影を描画（オーバーライド可能）
  @protected
  void renderShadow(Canvas canvas, Offset center, double radius) {
    shadowRenderer.render(
      canvas: canvas,
      balloonCenter: center,
      radius: radius,
    );
  }

  /// 紐とタグを描画（オーバーライド可能）
  @protected
  void renderStringAndTag(Canvas canvas, Offset center, double radius) {
    // セグメントをローカル座標に変換
    final localSegments = physicsState.stringState.segments.map((segment) {
      return Offset(
        center.dx + (segment.dx - physicsState.position.dx),
        center.dy + (segment.dy - physicsState.position.dy),
      );
    }).toList();

    // 紐を描画
    stringRenderer.render(
      canvas: canvas,
      segments: localSegments,
    );

    // タグを描画（タグアイコンがある場合のみ）
    if (balloon.tagIconId != null && localSegments.isNotEmpty) {
      tagRenderer.render(
        canvas: canvas,
        position: localSegments.last,
        rotation: physicsState.stringState.tagRotation,
        color: balloon.color,
        iconId: balloon.tagIconId,
      );
    }
  }

  /// 風船本体を描画（オーバーライド可能）
  @protected
  void renderBody(Canvas canvas, Offset center, double radius) {
    bodyRenderer.render(
      canvas: canvas,
      position: center,
      radius: radius,
      color: balloon.color,
    );
  }

  /// オーバーレイ描画（進捗インジケーターなど）
  /// サブクラスでオーバーライドして追加描画
  @protected
  void renderOverlay(Canvas canvas, Offset center, double radius) {
    // タイトルがある場合は進捗インジケーターを表示
    if (balloon.title != null) {
      _drawProgressIndicator(canvas, center, radius);
    }
  }

  /// 選択状態のリングを描画
  @protected
  void renderSelectionRing(Canvas canvas, Offset center, double radius) {
    final ringPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    canvas.drawCircle(center, radius + 8, ringPaint);
  }

  /// デバッグ表示（オーバーライド可能）
  @protected
  void renderDebug(Canvas canvas, Offset center, double radius) {
    // 衝突判定の円
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.red.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // 中心点
    canvas.drawCircle(
      center,
      2,
      Paint()
        ..color = Colors.red
        ..style = PaintingStyle.fill,
    );
  }

  /// 進捗インジケーターを描画
  void _drawProgressIndicator(Canvas canvas, Offset center, double radius) {
    final progressAngle = 2 * pi * balloon.progressRatio;

    final progressPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius + 5),
      -pi / 2,
      progressAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant BaseBalloonPainter oldDelegate) {
    return oldDelegate.physicsState != physicsState ||
        oldDelegate.balloon != balloon ||
        oldDelegate.debugMode != debugMode;
  }
}

/// 標準風船の Painter
///
/// BaseBalloonPainter をそのまま使用
class StandardBalloonPainter extends BaseBalloonPainter {
  StandardBalloonPainter({
    required super.balloon,
    required super.physicsState,
    super.debugMode,
  });
}
