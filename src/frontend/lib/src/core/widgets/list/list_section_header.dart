/// Widget: ListSectionHeader
///
/// リストセクションヘッダー
/// アイコン付きのセクションタイトル
library;

import 'package:flutter/material.dart';

/// リストセクションヘッダー
class ListSectionHeader extends StatelessWidget {
  /// セクションタイトル
  final String title;

  /// ダークモードかどうか
  final bool isDarkMode;

  /// アイコン（オプション）
  final IconData? icon;

  /// 上部パディング
  final double topPadding;

  /// 下部パディング
  final double bottomPadding;

  const ListSectionHeader({
    super.key,
    required this.title,
    this.isDarkMode = false,
    this.icon,
    this.topPadding = 16,
    this.bottomPadding = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding, top: topPadding, left: 4),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 18,
              color: isDarkMode
                  ? Colors.white.withValues(alpha: 0.6)
                  : Colors.black.withValues(alpha: 0.5),
            ),
            const SizedBox(width: 8),
          ],
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: isDarkMode
                  ? Colors.white.withValues(alpha: 0.6)
                  : Colors.black.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
