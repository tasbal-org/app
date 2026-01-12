/// Balloon Shadow Renderer
///
/// 風船の影の描画を担当
/// 地面への楕円形の影
library;

import 'package:flutter/material.dart';
import 'package:tasbal/src/core/widgets/balloon/renderers/balloon_body_renderer.dart';

/// 影の描画定数
class BalloonShadowConstants {
  /// 影の透明度
  static const double opacity = 0.15;

  /// 影のぼかし強度
  static const double blurSigma = 6.0;

  /// 影の横幅倍率（radius * widthRatio）
  static const double widthRatio = 1.5;

  /// 影の高さ倍率（radius * heightRatio）
  static const double heightRatio = 0.6;

  /// 影のX方向オフセット倍率（radius * xOffsetRatio）
  static const double xOffsetRatio = 0.8;

  /// 影のY方向位置倍率（紐の長さに対する位置）
  static const double yPositionRatio = 0.7;

  const BalloonShadowConstants._();
}

/// 影の描画クラス
///
/// 風船の地面への影を描画
class BalloonShadowRenderer {
  const BalloonShadowRenderer();

  /// 影を描画
  ///
  /// [balloonCenter] 風船の中心座標
  /// [radius] 風船の半径
  /// [stringLengthMultiplier] 紐の長さ倍率（デフォルト: 1.8）
  void render({
    required Canvas canvas,
    required Offset balloonCenter,
    required double radius,
    double stringLengthMultiplier = 1.8,
  }) {
    final hBottom = radius * BalloonBodyConstants.hBottomRatio;
    final stringLength = radius * stringLengthMultiplier;

    // 影の位置（風船の右斜め下、タグに少しかかる位置）
    final shadowCenter = Offset(
      balloonCenter.dx + radius * BalloonShadowConstants.xOffsetRatio,
      balloonCenter.dy + hBottom + stringLength * BalloonShadowConstants.yPositionRatio,
    );

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: BalloonShadowConstants.opacity)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        BalloonShadowConstants.blurSigma,
      );

    canvas.drawOval(
      Rect.fromCenter(
        center: shadowCenter,
        width: radius * BalloonShadowConstants.widthRatio,
        height: radius * BalloonShadowConstants.heightRatio,
      ),
      shadowPaint,
    );
  }

  /// カスタム位置に影を描画
  ///
  /// [center] 影の中心座標
  /// [width] 影の横幅
  /// [height] 影の高さ
  /// [opacity] 透明度（デフォルト: 0.15）
  void renderAt({
    required Canvas canvas,
    required Offset center,
    required double width,
    required double height,
    double opacity = BalloonShadowConstants.opacity,
  }) {
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: opacity)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        BalloonShadowConstants.blurSigma,
      );

    canvas.drawOval(
      Rect.fromCenter(center: center, width: width, height: height),
      shadowPaint,
    );
  }
}
