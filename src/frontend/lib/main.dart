/// Tasbal - タスク達成を風船で共有するアプリ
///
/// エントリーポイント
/// DI、Redux、ルーティングを初期化してアプリを起動
library;

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:logging/logging.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:tasbal/src/config/environment.dart';
import 'package:tasbal/src/config/router.dart';
import 'package:tasbal/src/core/di/injection.dart';
import 'package:tasbal/src/core/utils/logger.dart';
import 'package:tasbal/src/core/widgets/global_spinner.dart';
import 'package:tasbal/src/redux/app_reducer.dart';
import 'package:tasbal/src/redux/app_state.dart';

/// アプリケーションのエントリーポイント
///
/// 1. ロガーの初期化
/// 2. 依存性の登録（DI）
/// 3. Reduxストアの作成
/// 4. アプリの起動
void main() async {
  // Flutterバインディングの初期化（非同期処理前に必須）
  WidgetsFlutterBinding.ensureInitialized();

  // ロガーの初期化（開発環境のみDEBUGレベル）
  AppLogger.init(
    level: Environment.isDev ? Level.ALL : Level.INFO,
  );

  final logger = AppLogger.getLogger('Main');
  logger.info('アプリケーション起動開始 - 環境: ${Environment.environmentName}');

  // 依存性の登録
  await addDependencies();
  logger.info('依存性の登録完了');

  // Reduxストアの作成
  final store = Store<AppState>(
    appReducer,
    initialState: AppState.initial(),
    middleware: [thunkMiddleware],
  );
  logger.info('Reduxストア作成完了');

  // アプリ起動
  runApp(TasbalApp(store: store));
}

/// Tasbalアプリケーションのルートウィジェット
///
/// Redux StoreProviderでアプリ全体を包み、
/// グローバルローディングスピナーとルーターを設定
class TasbalApp extends StatelessWidget {
  /// Reduxストア
  final Store<AppState> store;

  const TasbalApp({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: StoreConnector<AppState, bool>(
        // グローバルローディング状態を購読
        converter: (store) => store.state.isLoading,
        builder: (context, isLoading) => MaterialApp.router(
          title: 'Tasbal',
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          theme: ThemeData(
            // TODO: カスタムテーマを適用
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          // グローバルローディングスピナーを重ねて表示
          builder: (context, child) => Stack(
            children: [
              child!,
              if (isLoading) const GlobalSpinner(),
            ],
          ),
        ),
      ),
    );
  }
}
