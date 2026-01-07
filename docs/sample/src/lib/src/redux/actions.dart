import 'package:flutter/foundation.dart';

@immutable
class SetLoadingAction {
  final bool isLoading;
  const SetLoadingAction(this.isLoading);
}