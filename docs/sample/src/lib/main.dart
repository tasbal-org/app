// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:qrino_admin/src/config/router.dart';
import 'package:qrino_admin/src/core/theme/app_theme.dart';
import 'package:qrino_admin/src/core/widgets/global_spinner.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:qrino_admin/src/core/di/injection.dart';
import 'package:qrino_admin/src/redux/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await addDependencies();
  final store = Store<AppState>(
    appReducer,
    initialState: AppState.initial(),
    middleware: [thunkMiddleware],
  );
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;
  const MyApp({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: StoreConnector<AppState, bool>(
        converter: (store) => store.state.isLoading,
        builder: (context, isLoading) => MaterialApp.router(
          title: 'Qrino Admin',
          theme: AppTheme.getTheme(), // AppTheme を適用
          routerConfig: router,
          builder: (context, child) => Stack(
            children: [
              child!,
              if (isLoading) const GlobalSpinner(),
            ],
          ),
        ),
      )
    );
  }
}