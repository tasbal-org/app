/// Core Widgets: Global Spinner
///
/// アプリ全体で使用するグローバルローディングスピナー
/// 背景を半透明にしてユーザー操作をブロック
library;

import 'package:flutter/material.dart';

/// グローバルスピナーウィジェット
///
/// 画面全体を覆う半透明の背景とローディングインジケーターを表示
/// Redux stateのisLoadingフラグで表示/非表示を制御
class GlobalSpinner extends StatelessWidget {
  const GlobalSpinner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.3),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }
}
