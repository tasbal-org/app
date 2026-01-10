/// Onboarding Repository Implementation
///
/// オンボーディングリポジトリの実装
/// ローカルサービスを使用してオンボーディング状態を管理
library;

import 'package:dartz/dartz.dart';
import 'package:tasbal/src/core/error/exceptions.dart';
import 'package:tasbal/src/core/error/failures.dart';
import 'package:tasbal/src/features/onboarding/data/data_sources/local/onboarding_local_service.dart';
import 'package:tasbal/src/features/onboarding/domain/repositories/onboarding_repository.dart';

/// オンボーディングリポジトリ実装
///
/// ローカルストレージとの通信を担当
/// 例外をFailureに変換してドメイン層に返す
class OnboardingRepositoryImpl implements OnboardingRepository {
  /// ローカルサービス
  final OnboardingLocalService localService;

  OnboardingRepositoryImpl({
    required this.localService,
  });

  @override
  Future<Either<Failure, void>> saveCompletionStatus({
    required bool completed,
    int? version,
  }) async {
    try {
      await localService.saveCompletionStatus(
        completed: completed,
        version: version,
      );
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> hasCompletedOnboarding() async {
    try {
      final hasCompleted = await localService.hasCompletedOnboarding();
      return Right(hasCompleted);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> getSavedVersion() async {
    try {
      final version = await localService.getSavedVersion();
      return Right(version);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearOnboardingData() async {
    try {
      await localService.clearOnboardingData();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }
}
