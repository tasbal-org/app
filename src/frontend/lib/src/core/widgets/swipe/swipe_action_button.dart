/// Core Widget: SwipeActionButton
///
/// スワイプアクション用のボタンコンポーネント
/// スワイプ可能なカードで表示されるアクションボタン
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// スワイプアクションボタン
///
/// スワイプ時に表示されるアクションボタン
/// アイコンとラベルを縦に配置
class SwipeActionButton extends StatelessWidget {
  /// アイコン
  final IconData icon;

  /// ラベル
  final String label;

  /// 背景色
  final Color backgroundColor;

  /// アイコン・テキストの色
  final Color foregroundColor;

  /// アイコンサイズ
  final double iconSize;

  /// フォントサイズ
  final double fontSize;

  /// タップ時のコールバック
  final VoidCallback? onTap;

  /// ハプティックフィードバックを有効にするか
  final bool enableHapticFeedback;

  const SwipeActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    this.foregroundColor = Colors.white,
    this.iconSize = 24,
    this.fontSize = 12,
    this.onTap,
    this.enableHapticFeedback = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (enableHapticFeedback) {
          HapticFeedback.mediumImpact();
        }
        onTap?.call();
      },
      child: Container(
        color: backgroundColor,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: foregroundColor,
              size: iconSize,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: foregroundColor,
                fontWeight: FontWeight.w600,
                fontSize: fontSize,
              ),
              maxLines: 1,
              overflow: TextOverflow.clip,
            ),
          ],
        ),
      ),
    );
  }
}
