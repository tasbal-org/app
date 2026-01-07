import 'package:equatable/equatable.dart';
import 'package:qrino_admin/src/features/auth/presentation/redux/actions.dart';
import 'package:qrino_admin/src/features/auth/presentation/redux/reducers.dart';
import 'package:qrino_admin/src/features/auth/presentation/redux/state.dart';
import 'package:qrino_admin/src/redux/actions.dart';

class AppState extends Equatable {
  final bool isLoading;
  final AuthState authState;

  const AppState({
    required this.isLoading,
    required this.authState,
  });

  factory AppState.initial() => AppState(
      isLoading: false,
      authState: AuthState.initial(),
    );

  AppState copyWith({
    bool? isLoading,
    AuthState? authState,
  }) => AppState(
        isLoading: isLoading ?? this.isLoading,
        authState: authState ?? this.authState,
      );

  @override
  List<Object> get props => [
      isLoading,
      authState
    ];
}

AppState appReducer(AppState state, dynamic action) {
  bool isLoading = state.isLoading;

  switch (action) {
    case SetLoadingAction _:
      isLoading = action.isLoading;
      break;
    case LoginAction _:
    case RefreshTokenAction _:
    case LogoutAction _:
      isLoading = true;
      break;
    case LoginSuccessAction _:
    case LoginFailureAction _:
    case RefreshTokenSuccessAction _:
    case RefreshTokenFailureAction _:
    case LogoutSuccessAction _:
    case LogoutFailureAction _:
      isLoading = false;
      break;
    default:
      isLoading = false;
      break;
  }

  return AppState(
    authState: authReducer(state.authState, action),
    isLoading: isLoading,
  );
}