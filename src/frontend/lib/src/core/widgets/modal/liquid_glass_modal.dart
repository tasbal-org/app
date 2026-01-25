/// Widget: LiquidGlassModal
///
/// Liquid Glassスタイルの汎用モーダル
/// ヘッダー（キャンセル・タイトル・確定）+ コンテンツ + フッター構成
library;

import 'package:flutter/material.dart';

import 'liquid_glass_modal_header.dart';

/// 汎用モーダルウィジェット
///
/// ピッカーやタスク編集シート等で共通して使用できるボトムシート
class LiquidGlassModal extends StatelessWidget {
  /// タイトル
  final String title;

  /// ダークモードかどうか
  final bool isDarkMode;

  /// キャンセルコールバック
  final VoidCallback onCancel;

  /// 確定コールバック
  final VoidCallback onDone;

  /// 確定ボタンが有効かどうか
  final bool doneEnabled;

  /// 中央ボタンのコールバック（nullの場合は非表示）
  final VoidCallback? onCenterAction;

  /// 中央ボタンのアイコン
  final IconData centerIcon;

  /// コンテンツウィジェット
  final Widget child;

  /// 高さ（nullの場合はコンテンツに応じて自動調整）
  final double? height;

  /// 最大高さ（画面高さの割合、デフォルト: 0.9）
  final double maxHeightRatio;

  /// 角丸の半径
  final double borderRadius;

  const LiquidGlassModal({
    super.key,
    required this.title,
    required this.isDarkMode,
    required this.onCancel,
    required this.onDone,
    required this.child,
    this.doneEnabled = true,
    this.onCenterAction,
    this.centerIcon = Icons.add,
    this.height,
    this.maxHeightRatio = 0.9,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;

    return Container(
      height: height,
      constraints: BoxConstraints(
        maxHeight: screenHeight * maxHeightRatio,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(borderRadius),
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(bottom: bottomPadding),
          decoration: BoxDecoration(
            color: isDarkMode
                ? const Color(0xFF1E1E3C)
                : Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ヘッダー
              LiquidGlassModalHeader(
                title: title,
                isDarkMode: isDarkMode,
                onCancel: onCancel,
                onDone: onDone,
                doneEnabled: doneEnabled,
                onCenterAction: onCenterAction,
                centerIcon: centerIcon,
              ),
              // コンテンツ
              Flexible(child: child),
              // SafeArea分の余白
              SizedBox(height: bottomSafeArea > 0 ? bottomSafeArea : 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// 汎用モーダルを表示するヘルパー関数
///
/// [context] BuildContext
/// [title] モーダルのタイトル
/// [isDarkMode] ダークモードかどうか
/// [builder] コンテンツビルダー（setStateを受け取る）
/// [onDone] 確定時のコールバック（戻り値を返す）
/// [doneEnabled] 確定ボタンが有効かどうか（StatefulBuilderで動的に変更可能）
/// [onCenterAction] 中央ボタンのコールバック
/// [centerIcon] 中央ボタンのアイコン
/// [height] モーダルの高さ
/// [maxHeightRatio] 最大高さの画面比率
Future<T?> showLiquidGlassModal<T>({
  required BuildContext context,
  required String title,
  required bool isDarkMode,
  required Widget Function(BuildContext context, StateSetter setState) builder,
  required T? Function() onDone,
  bool doneEnabled = true,
  VoidCallback? onCenterAction,
  IconData centerIcon = Icons.add,
  double? height,
  double maxHeightRatio = 0.9,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    barrierColor: Colors.black54,
    builder: (context) => StatefulBuilder(
      builder: (context, setModalState) => LiquidGlassModal(
        title: title,
        isDarkMode: isDarkMode,
        onCancel: () => Navigator.pop(context),
        onDone: () => Navigator.pop(context, onDone()),
        doneEnabled: doneEnabled,
        onCenterAction: onCenterAction,
        centerIcon: centerIcon,
        height: height,
        maxHeightRatio: maxHeightRatio,
        child: builder(context, setModalState),
      ),
    ),
  );
}
