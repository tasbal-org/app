import 'package:qrino_admin/src/core/constants/status.dart';
import 'package:qrino_admin/src/features/auth/presentation/redux/actions.dart';
import 'package:qrino_admin/src/features/auth/presentation/redux/state.dart';

AuthState authReducer(AuthState state, dynamic action) {
  if (action is LoginAction) {
    return state.copyWith(status: Status.loading);
  } if (action is LoginSuccessAction) {
    return state.copyWith(
      status: Status.success,
      failure: null,
    );
  } else if (action is LoginFailureAction) {
    return state.copyWith(
      status: Status.error,
      failure: action.failure,
    );
  } else if (action is RefreshTokenAction) {
    return state.copyWith(status: Status.loading);
  } else if (action is RefreshTokenSuccessAction) {
    return state.copyWith(
      status: Status.success,
      failure: null,
    );
  } else if (action is RefreshTokenFailureAction) {
    return state.copyWith(
      status: Status.error,
      failure: action.failure,
    );
  } else if (action is LogoutAction) {
    return state.copyWith(status: Status.loading);
  } else if (action is LogoutSuccessAction) {
    return AuthState.initial();
  } else if (action is LogoutFailureAction) {
    return state.copyWith(
      status: Status.error,
      failure: action.failure,
    );
  }
  return state;
}