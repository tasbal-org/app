/// Check Onboarding Use Case
///
/// オンボーディング状態確認ユースケース
/// アプリ起動時にオンボーディング完了状態をチェック
library;

import 'package:dartz/dartz.dart';
import 'package:tasbal/src/core/error/failures.dart';
import 'package:tasbal/src/features/onboarding/domain/repositories/onboarding_repository.dart';

/// オンボーディング状態確認ユースケース
///
/// アプリ起動時（スプラッシュ画面）で呼び出される
/// オンボーディング完了フラグを確認して遷移先を決定
class CheckOnboardingUseCase {
  /// オンボーディングリポジトリ
  final OnboardingRepository repository;

  CheckOnboardingUseCase(this.repository);

  /// オンボーディング完了状態を確認
  ///
  /// Returns: 成功時はRight(bool)、失敗時はLeft(Failure)
  ///          true: オンボーディング完了済み
  ///          false: オンボーディング未完了
  Future<Either<Failure, bool>> call() async {
    return await repository.hasCompletedOnboarding();
  }
}
