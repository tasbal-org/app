/// Balloon Grid Painter
///
/// 菱形グリッドを描画
/// 色のグラデーションのみで奥行きを表現
library;

import 'package:flutter/material.dart';

/// グリッド背景ペインター
///
/// 45度回転した正方形（菱形）グリッドをフラットに描画
/// 透視投影なし、すべて同一サイズ
class BalloonGridPainter extends CustomPainter {
  /// ダークモード対応
  final bool isDarkMode;

  /// グリッドの線の色（ライトモード用）
  final Color? lightModeColor;

  /// グリッドの線の色（ダークモード用）
  final Color? darkModeColor;

  /// グリッドの線の太さ
  final double strokeWidth;

  /// グリッドのセルサイズ（菱形の対角線の長さ）
  final double cellSize;

  const BalloonGridPainter({
    this.isDarkMode = false,
    this.lightModeColor,
    this.darkModeColor,
    this.strokeWidth = 1.0,
    this.cellSize = 40.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 仕様に基づくデフォルトカラー
    final defaultLightColor = const Color(0xFFE9EEF2); // Grid / Shadow (Light)
    final defaultDarkColor = const Color(0xFF2A313B); // Grid / Shadow (Dark)

    final baseColor = isDarkMode
        ? (darkModeColor ?? defaultDarkColor)
        : (lightModeColor ?? defaultLightColor);

    // 菱形グリッドを描画
    // 縦に短い菱形（横長）= 緩やかな斜線
    final halfCell = cellSize / 2;
    final horizontalStretch = 2.5; // 横方向の伸び率（大きいほど横長の菱形）

    // 垂直方向のグラデーション（Y軸）
    // 上部: より明るく、下部: やや暗く
    final lineCountX = (size.width / (halfCell * horizontalStretch)).ceil() + 2;
    final lineCountY = (size.height / halfCell).ceil() + 2;

    // 右下がりの斜線（\）
    for (var i = -lineCountY; i < lineCountX + lineCountY; i++) {
      final startX = i * halfCell * horizontalStretch;
      final startY = 0.0;
      final endY = size.height;
      final endX = startX + size.height * horizontalStretch;

      // Y座標に応じた透明度（グラデーション）
      // 上部: より薄く（透明）、下部: やや濃く
      final avgY = (startY + endY) / 2;
      final depthRatio = avgY / size.height; // 0.0（上）～ 1.0（下）

      final opacity = isDarkMode
          ? 0.20 + (depthRatio * 0.10) // ダーク: 20%～30%
          : 0.25 + (depthRatio * 0.20); // ライト: 25%～45%

      final linePaint = Paint()
        ..color = baseColor.withValues(alpha: opacity)
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke;

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        linePaint,
      );
    }

    // 左下がりの斜線（/）
    for (var i = -lineCountY; i < lineCountX + lineCountY; i++) {
      final startX = size.width - (i * halfCell * horizontalStretch);
      final startY = 0.0;
      final endY = size.height;
      final endX = startX - size.height * horizontalStretch;

      // Y座標に応じた透明度（グラデーション）
      final avgY = (startY + endY) / 2;
      final depthRatio = avgY / size.height;

      final opacity = isDarkMode
          ? 0.20 + (depthRatio * 0.10)
          : 0.25 + (depthRatio * 0.20);

      final linePaint = Paint()
        ..color = baseColor.withValues(alpha: opacity)
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke;

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant BalloonGridPainter oldDelegate) {
    return oldDelegate.isDarkMode != isDarkMode ||
        oldDelegate.lightModeColor != lightModeColor ||
        oldDelegate.darkModeColor != darkModeColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.cellSize != cellSize;
  }
}
