import 'package:dartz/dartz.dart';
import 'package:qrino_admin/src/core/error/failures.dart';
import 'package:qrino_admin/src/redux/actions.dart';
import 'package:qrino_admin/src/redux/app_state.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction<AppState> createThunk<T, A extends Object>(
  A action,
  Future<Either<Failure, T>> Function() useCase,
  A Function(T) successAction,
  A Function(Failure) failureAction, {
  void Function()? onSuccess,
  bool isLoading = false,
}) {
  return (Store<AppState> store) async {
    store.dispatch(SetLoadingAction(isLoading));
    store.dispatch(action);
    final result = await useCase();
    result.fold(
      (failure) => store.dispatch(failureAction(failure)),
      (value) {
        store.dispatch(successAction(value));
        onSuccess?.call();
      },
    );
  };
}