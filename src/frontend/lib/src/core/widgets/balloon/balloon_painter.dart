/// Balloon Painter Widget
///
/// 風船の描画を担当
/// 新しいRenderer/Painter構造への橋渡し
library;

import 'package:flutter/material.dart';
import 'package:tasbal/src/core/widgets/balloon/painters/base_balloon_painter.dart';
import 'package:tasbal/src/core/widgets/balloon/renderers/balloon_body_renderer.dart';
import 'package:tasbal/src/features/balloon/domain/entities/balloon.dart';
import 'package:tasbal/src/features/balloon/domain/physics/balloon_physics.dart';

// Renderers のエクスポート（利便性のため）
export 'package:tasbal/src/core/widgets/balloon/renderers/balloon_body_renderer.dart';
export 'package:tasbal/src/core/widgets/balloon/renderers/balloon_shadow_renderer.dart';
export 'package:tasbal/src/core/widgets/balloon/renderers/balloon_string_renderer.dart';
export 'package:tasbal/src/core/widgets/balloon/renderers/balloon_tag_renderer.dart';

// Painters のエクスポート
export 'package:tasbal/src/core/widgets/balloon/painters/base_balloon_painter.dart';

/// 風船ペインター
///
/// CustomPainter を使用して風船を描画
/// 後方互換性のため BalloonPainter として残し、内部で StandardBalloonPainter を使用
class BalloonPainter extends StandardBalloonPainter {
  BalloonPainter({
    required super.balloon,
    required super.physicsState,
    super.debugMode,
  });
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
    // 卵型形状に合わせた比率
    final hTop = radius * BalloonBodyConstants.hTopRatio;
    final hBottom = radius * BalloonBodyConstants.hBottomRatio;
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
