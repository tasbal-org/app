/// Settings Use Case: Get Preferences
///
/// 設定取得ユースケース
library;

import 'package:dartz/dartz.dart';
import 'package:tasbal/src/core/error/failures.dart';
import 'package:tasbal/src/features/settings/domain/entities/user_preferences.dart';
import 'package:tasbal/src/features/settings/domain/repositories/settings_repository.dart';

/// 設定取得ユースケース
///
/// ローカルストレージから設定を取得
class GetPreferencesUseCase {
  final SettingsRepository _repository;

  GetPreferencesUseCase(this._repository);

  /// 設定を取得
  Future<Either<Failure, UserPreferences>> call() {
    return _repository.getPreferences();
  }
}
