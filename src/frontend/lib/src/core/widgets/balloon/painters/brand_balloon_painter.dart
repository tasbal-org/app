/// Brand Balloon Painter
///
/// ブランドアイコン風船のペインター
/// 風船本体にGitHub、GitLabなどのブランドアイコンを表示
library;

import 'package:flutter/material.dart';
import 'package:tasbal/src/core/widgets/balloon/painters/base_balloon_painter.dart';
import 'package:tasbal/src/core/widgets/balloon/renderers/balloon_content_renderer.dart';

/// ブランド風船ペインター
///
/// ブランドアイコンを風船本体に描画
class BrandBalloonPainter extends BaseBalloonPainter {
  /// ブランドタイプ
  final BrandType brandType;

  /// コンテンツレンダラー
  final BalloonContentRenderer _contentRenderer;

  BrandBalloonPainter({
    required super.balloon,
    required super.physicsState,
    required this.brandType,
    super.debugMode,
    super.inflationState,
    BalloonContentRenderer? contentRenderer,
  }) : _contentRenderer = contentRenderer ?? const BalloonContentRenderer();

  @override
  void renderBody(Canvas canvas, Offset center, double radius) {
    // 通常の風船本体を描画
    bodyRenderer.render(
      canvas: canvas,
      position: center,
      radius: radius,
      color: balloon.color,
      bulge: bulge,
    );

    // ブランドアイコンを描画
    final iconPosition = Offset(center.dx, center.dy - radius * 0.15);
    final iconSize = radius * 0.8;

    _contentRenderer.render(
      canvas: canvas,
      position: iconPosition,
      size: iconSize,
      content: BrandContent(brandType),
      opacity: 0.9,
    );
  }
}

/// シェイプ風船ペインター
///
/// 形状アイコンを風船本体に描画
class ShapeBalloonPainter extends BaseBalloonPainter {
  /// シェイプタイプ（1-12）
  final int shapeType;

  /// コンテンツレンダラー
  final BalloonContentRenderer _contentRenderer;

  ShapeBalloonPainter({
    required super.balloon,
    required super.physicsState,
    required this.shapeType,
    super.debugMode,
    super.inflationState,
    BalloonContentRenderer? contentRenderer,
  }) : _contentRenderer = contentRenderer ?? const BalloonContentRenderer();

  @override
  void renderBody(Canvas canvas, Offset center, double radius) {
    // 通常の風船本体を描画
    bodyRenderer.render(
      canvas: canvas,
      position: center,
      radius: radius,
      color: balloon.color,
      bulge: bulge,
    );

    // シェイプアイコンを描画
    final iconPosition = Offset(center.dx, center.dy - radius * 0.15);
    final iconSize = radius * 0.6;

    _contentRenderer.render(
      canvas: canvas,
      position: iconPosition,
      size: iconSize,
      content: ShapeContent(shapeType),
      opacity: 0.9,
    );
  }
}
