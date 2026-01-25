/// Widget: LiquidGlassModalHeader
///
/// 汎用モーダル用のヘッダー
/// キャンセル・タイトル・[中央ボタン]・完了ボタンを配置
library;

import 'package:flutter/material.dart';
import 'package:flutter_liquid_glass_plus/flutter_liquid_glass.dart';

/// モーダル用ヘッダー
///
/// 「キャンセル」「タイトル」「[中央ボタン]」「完了」の構成
class LiquidGlassModalHeader extends StatelessWidget {
  /// タイトル
  final String title;

  /// ダークモードかどうか
  final bool isDarkMode;

  /// キャンセルコールバック
  final VoidCallback onCancel;

  /// 完了コールバック
  final VoidCallback onDone;

  /// 完了ボタンが有効かどうか
  final bool doneEnabled;

  /// 中央ボタンのコールバック（nullの場合は非表示）
  final VoidCallback? onCenterAction;

  /// 中央ボタンのアイコン
  final IconData centerIcon;

  /// 水平パディング
  final double horizontalPadding;

  /// 垂直パディング
  final double verticalPadding;

  /// ボタンサイズ
  final double buttonSize;

  /// アイコンサイズ
  final double iconSize;

  const LiquidGlassModalHeader({
    super.key,
    required this.title,
    required this.isDarkMode,
    required this.onCancel,
    required this.onDone,
    this.doneEnabled = true,
    this.onCenterAction,
    this.centerIcon = Icons.add,
    this.horizontalPadding = 12,
    this.verticalPadding = 12,
    this.buttonSize = 44,
    this.iconSize = 22,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Row(
        children: [
          // キャンセルボタン
          _buildCancelButton(),
          const SizedBox(width: 12),
          // タイトル
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // 中央ボタン（オプション）
          if (onCenterAction != null) ...[
            const SizedBox(width: 8),
            _buildCenterButton(),
          ],
          const SizedBox(width: 12),
          // 完了ボタン
          _buildDoneButton(),
        ],
      ),
    );
  }

  Widget _buildCancelButton() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LGButton(
        icon: Icons.close,
        onTap: onCancel,
        width: buttonSize,
        height: buttonSize,
        iconSize: iconSize,
        iconColor: isDarkMode
            ? Colors.white.withValues(alpha: 0.7)
            : Colors.black.withValues(alpha: 0.6),
        shape: const LiquidOval(),
        settings: LiquidGlassSettings(
          thickness: 0,
          glassColor: isDarkMode
              ? const Color(0xFF707070)
              : const Color(0xFFC7C7CC),
          lightIntensity: 0,
          blur: 0,
        ),
        useOwnLayer: true,
        glowColor: const Color.fromARGB(20, 255, 255, 255),
      ),
    );
  }

  Widget _buildCenterButton() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LGButton(
        icon: centerIcon,
        onTap: onCenterAction!,
        width: buttonSize,
        height: buttonSize,
        iconSize: iconSize,
        iconColor: Colors.white,
        shape: const LiquidOval(),
        settings: const LiquidGlassSettings(
          thickness: 0,
          glassColor: Color(0xFF007AFF),
          lightIntensity: 0,
          blur: 0,
        ),
        useOwnLayer: true,
        glowColor: const Color.fromARGB(20, 255, 255, 255),
      ),
    );
  }

  Widget _buildDoneButton() {
    final enabled = doneEnabled;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Opacity(
        opacity: enabled ? 1.0 : 0.5,
        child: LGButton(
          icon: Icons.check,
          onTap: enabled ? onDone : () {},
          width: buttonSize,
          height: buttonSize,
          iconSize: iconSize,
          iconColor: Colors.white,
          shape: const LiquidOval(),
          settings: const LiquidGlassSettings(
            thickness: 0,
            glassColor: Color.fromARGB(120, 185, 185, 185),
            lightIntensity: 0,
            blur: 0,
          ),
          useOwnLayer: true,
          glowColor: const Color.fromARGB(20, 255, 255, 255),
        ),
      ),
    );
  }
}
