/// Widget: LiquidGlassBottomSheet
///
/// Liquid Glassスタイルの汎用ボトムシート
library;

import 'package:flutter/material.dart';

/// 汎用ボトムシートコンテナ
///
/// ダークモード対応の背景色と角丸を適用
class LiquidGlassBottomSheet extends StatelessWidget {
  /// 子ウィジェット
  final Widget child;

  /// ダークモードかどうか
  final bool isDarkMode;

  /// 高さ（nullの場合はコンテンツに応じて自動調整）
  final double? height;

  /// 角丸の半径
  final double borderRadius;

  /// ライトモードの背景色
  final Color? lightBackground;

  /// ダークモードの背景色
  final Color? darkBackground;

  const LiquidGlassBottomSheet({
    super.key,
    required this.child,
    required this.isDarkMode,
    this.height,
    this.borderRadius = 20,
    this.lightBackground,
    this.darkBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: isDarkMode
            ? (darkBackground ?? const Color(0xFF1E1E3C))
            : (lightBackground ?? Colors.white),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(borderRadius),
        ),
      ),
      child: child,
    );
  }
}

/// ボトムシートを表示するヘルパー関数
Future<T?> showLiquidGlassBottomSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext context) builder,
  bool isScrollControlled = false,
  Color barrierColor = Colors.black54,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: isScrollControlled,
    barrierColor: barrierColor,
    builder: builder,
  );
}
