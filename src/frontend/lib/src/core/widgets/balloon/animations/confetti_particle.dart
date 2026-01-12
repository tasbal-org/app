/// Confetti Particle System
///
/// 風船が破裂した時の紙吹雪パーティクル
/// 物理演算による自然な動き
library;

import 'dart:math';

import 'package:flutter/material.dart';

/// 紙吹雪パーティクル
class ConfettiParticle {
  /// 一意のID
  final int id;

  /// X座標
  double x;

  /// Y座標
  double y;

  /// X方向の速度
  double vx;

  /// Y方向の速度
  double vy;

  /// 色
  final Color color;

  /// 回転角度
  double rotation;

  /// 回転速度
  final double rotationSpeed;

  /// サイズ
  final double size;

  /// Y方向のスケール（ひらひら効果）
  double scaleY;

  /// 透明度
  double opacity;

  ConfettiParticle({
    required this.id,
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.color,
    required this.rotation,
    required this.rotationSpeed,
    required this.size,
    this.scaleY = 1.0,
    this.opacity = 1.0,
  });
}

/// 紙吹雪パーティクルシステム
class ConfettiSystem {
  /// パーティクルリスト
  final List<ConfettiParticle> particles = [];

  /// 重力
  static const double gravity = 0.15;

  /// 空気抵抗
  static const double airResistance = 0.99;

  /// フェードアウト速度
  static const double fadeSpeed = 0.005;

  /// パーティクル数
  static const int particleCount = 40;

  final Random _random = Random();

  /// 紙吹雪を生成
  void createConfetti({
    required double x,
    required double y,
    required Color baseColor,
  }) {
    final colors = _generateConfettiColors(baseColor);

    for (int i = 0; i < particleCount; i++) {
      final angle = _random.nextDouble() * pi * 2;
      final speed = 2 + _random.nextDouble() * 6;

      particles.add(ConfettiParticle(
        id: DateTime.now().millisecondsSinceEpoch + i,
        x: x,
        y: y,
        vx: cos(angle) * speed,
        vy: sin(angle) * speed - 2, // 上向きに飛び出す
        color: colors[_random.nextInt(colors.length)],
        rotation: _random.nextDouble() * pi * 2,
        rotationSpeed: (_random.nextDouble() - 0.5) * 0.2,
        size: 4 + _random.nextDouble() * 6,
        scaleY: _random.nextDouble(),
        opacity: 1.0,
      ));
    }
  }

  /// パーティクルを更新
  ///
  /// [screenHeight] 画面の高さ（画面外に出たパーティクルを削除するため）
  void update(double screenHeight) {
    for (int i = particles.length - 1; i >= 0; i--) {
      final p = particles[i];

      // 位置更新
      p.x += p.vx;
      p.y += p.vy;

      // 重力
      p.vy += gravity;

      // 空気抵抗
      p.vx *= airResistance;

      // 回転
      p.rotation += p.rotationSpeed;

      // ひらひら効果
      p.scaleY = cos(p.rotation);

      // フェードアウト
      p.opacity -= fadeSpeed;

      // 削除判定
      if (p.opacity <= 0 || p.y > screenHeight + 50) {
        particles.removeAt(i);
      }
    }
  }

  /// パーティクルをクリア
  void clear() {
    particles.clear();
  }

  /// アクティブなパーティクルがあるか
  bool get hasActiveParticles => particles.isNotEmpty;

  /// 紙吹雪用の色バリエーションを生成
  List<Color> _generateConfettiColors(Color baseColor) {
    final hsl = HSLColor.fromColor(baseColor);
    return [
      baseColor,
      hsl.withLightness((hsl.lightness + 0.2).clamp(0.0, 1.0)).toColor(),
      hsl.withLightness((hsl.lightness - 0.1).clamp(0.0, 1.0)).toColor(),
      hsl.withSaturation((hsl.saturation * 0.7).clamp(0.0, 1.0)).toColor(),
      Colors.white.withValues(alpha: 0.9),
      const Color(0xFFFFD700), // 金色
    ];
  }
}

/// 紙吹雪のレンダラー
class ConfettiRenderer {
  const ConfettiRenderer();

  /// 紙吹雪を描画
  void render({
    required Canvas canvas,
    required List<ConfettiParticle> particles,
  }) {
    for (final p in particles) {
      canvas.save();
      canvas.translate(p.x, p.y);
      canvas.rotate(p.rotation);

      final paint = Paint()
        ..color = p.color.withValues(alpha: p.opacity)
        ..style = PaintingStyle.fill;

      // 四角形の紙吹雪（ひらひら効果付き）
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: p.size,
          height: p.size * p.scaleY.abs().clamp(0.1, 1.0),
        ),
        paint,
      );

      canvas.restore();
    }
  }
}
