import 'package:redux_thunk/redux_thunk.dart';
import 'package:qrino_admin/src/config/router.dart';
import 'package:qrino_admin/src/core/utils/thunk_helper.dart';
import 'package:qrino_admin/src/features/auth/domain/use_cases/logout_use_case.dart';
import 'package:qrino_admin/src/features/auth/domain/use_cases/refresh_token_use_case.dart';
import 'package:qrino_admin/src/redux/app_state.dart';
import 'package:qrino_admin/src/core/di/injection.dart';
import 'package:qrino_admin/src/features/auth/domain/use_cases/login_use_case.dart';
import 'package:qrino_admin/src/features/auth/presentation/redux/actions.dart';

ThunkAction<AppState> loginThunk(String email, String password) {
  return createThunk<void, AuthAction>(
    LoginAction(email: email, password: password),
    () => sl<LoginUseCase>().call(email, password),
    (token) => LoginSuccessAction(),
    (failure) => LoginFailureAction(failure: failure),
    onSuccess: () => router.go('/home'),
    isLoading: true,
  );
}

ThunkAction<AppState> refreshTokenThunk() {
  return createThunk<void, AuthAction>(
    RefreshTokenAction(),
    () => sl<RefreshTokenUseCase>().call(),
    (token) => RefreshTokenSuccessAction(),
    (failure) => RefreshTokenFailureAction(failure: failure),
    isLoading: true,
  );
}

ThunkAction<AppState> logoutThunk() {
  return createThunk<void, AuthAction>(
    LogoutAction(),
    () => sl<LogoutUseCase>().call(),
    (_) => LogoutSuccessAction(),
    (failure) => LogoutFailureAction(failure: failure),
    onSuccess: () => router.go('/login'),
    isLoading: true,
  );
}