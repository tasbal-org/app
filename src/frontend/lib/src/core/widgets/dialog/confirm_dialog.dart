/// Widget: ConfirmDialog
///
/// 汎用確認ダイアログ
library;

import 'package:flutter/material.dart';

/// 確認ダイアログ
///
/// タイトル、メッセージ、キャンセル・確認ボタンを表示
class ConfirmDialog extends StatelessWidget {
  /// タイトル
  final String title;

  /// メッセージ
  final String message;

  /// キャンセルボタンのテキスト
  final String cancelText;

  /// 確認ボタンのテキスト
  final String confirmText;

  /// 確認ボタンが危険なアクションかどうか（削除など）
  final bool isDanger;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.cancelText = 'キャンセル',
    this.confirmText = '確認',
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: isDanger
              ? TextButton.styleFrom(foregroundColor: Colors.red)
              : null,
          child: Text(confirmText),
        ),
      ],
    );
  }
}

/// 確認ダイアログを表示するヘルパー関数
///
/// 戻り値: true=確認、false=キャンセル、null=ダイアログ外タップ
Future<bool?> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String cancelText = 'キャンセル',
  String confirmText = '確認',
  bool isDanger = false,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => ConfirmDialog(
      title: title,
      message: message,
      cancelText: cancelText,
      confirmText: confirmText,
      isDanger: isDanger,
    ),
  );
}

/// 削除確認ダイアログを表示するヘルパー関数
///
/// 戻り値: true=削除、false=キャンセル、null=ダイアログ外タップ
Future<bool?> showDeleteConfirmDialog({
  required BuildContext context,
  required String itemName,
  String? customMessage,
}) {
  return showConfirmDialog(
    context: context,
    title: '削除の確認',
    message: customMessage ?? '「$itemName」を削除しますか？\nこの操作は取り消せません。',
    cancelText: 'キャンセル',
    confirmText: '削除',
    isDanger: true,
  );
}
