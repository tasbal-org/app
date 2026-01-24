/// Settings Repository Implementation
///
/// 設定リポジトリの実装
library;

import 'package:dartz/dartz.dart';
import 'package:tasbal/src/core/error/exceptions.dart';
import 'package:tasbal/src/core/error/failures.dart';
import 'package:tasbal/src/features/settings/data/data_sources/local/settings_local_service.dart';
import 'package:tasbal/src/features/settings/domain/entities/user_preferences.dart';
import 'package:tasbal/src/features/settings/domain/repositories/settings_repository.dart';

/// 設定リポジトリ実装
///
/// ローカルストレージを使用して設定を管理
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalService _localService;

  SettingsRepositoryImpl({
    required SettingsLocalService localService,
  }) : _localService = localService;

  @override
  Future<Either<Failure, UserPreferences>> getPreferences() async {
    try {
      final preferences = await _localService.getPreferences();
      return Right(preferences);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get preferences: $e'));
    }
  }

  @override
  Future<Either<Failure, UserPreferences>> savePreferences(
    UserPreferences preferences,
  ) async {
    try {
      await _localService.savePreferences(preferences);
      return Right(preferences);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to save preferences: $e'));
    }
  }

  @override
  Future<Either<Failure, UserPreferences>> updateCountryCode(
    String? countryCode,
  ) async {
    try {
      await _localService.saveCountryCode(countryCode);
      final preferences = await _localService.getPreferences();
      return Right(preferences);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to update country code: $e'));
    }
  }

  @override
  Future<Either<Failure, UserPreferences>> updateRenderQuality(
    RenderQuality quality,
  ) async {
    try {
      await _localService.saveRenderQuality(quality);
      final preferences = await _localService.getPreferences();
      return Right(preferences);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to update render quality: $e'));
    }
  }

  @override
  Future<Either<Failure, UserPreferences>> updateAutoLowPowerMode(
    bool enabled,
  ) async {
    try {
      await _localService.saveAutoLowPowerMode(enabled);
      final preferences = await _localService.getPreferences();
      return Right(preferences);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(
          CacheFailure(message: 'Failed to update auto low power mode: $e'));
    }
  }

  @override
  Future<Either<Failure, UserPreferences>> updateThemeMode(
    ThemeMode mode,
  ) async {
    try {
      await _localService.saveThemeMode(mode);
      final preferences = await _localService.getPreferences();
      return Right(preferences);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to update theme mode: $e'));
    }
  }

  @override
  Future<Either<Failure, UserPreferences>> resetPreferences() async {
    try {
      await _localService.clearPreferences();
      return Right(UserPreferences.initial());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to reset preferences: $e'));
    }
  }
}
