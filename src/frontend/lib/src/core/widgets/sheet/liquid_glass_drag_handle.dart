/// Widget: LiquidGlassDragHandle
///
/// Liquid Glassスタイルのドラッグハンドル
library;

import 'package:flutter/material.dart';

/// ボトムシート用ドラッグハンドル
class LiquidGlassDragHandle extends StatelessWidget {
  /// ダークモードかどうか
  final bool isDarkMode;

  /// ハンドルの幅
  final double width;

  /// ハンドルの高さ
  final double height;

  /// 上部マージン
  final double marginTop;

  /// 下部マージン
  final double marginBottom;

  const LiquidGlassDragHandle({
    super.key,
    required this.isDarkMode,
    this.width = 36,
    this.height = 4,
    this.marginTop = 12,
    this.marginBottom = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: marginTop, bottom: marginBottom),
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height / 2),
          color: isDarkMode
              ? Colors.white.withValues(alpha: 0.3)
              : Colors.black.withValues(alpha: 0.2),
        ),
      ),
    );
  }
}
