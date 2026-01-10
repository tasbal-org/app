/// Complete Onboarding Use Case
///
/// オンボーディング完了ユースケース
/// オンボーディング完了状態を保存する
library;

import 'package:dartz/dartz.dart';
import 'package:tasbal/src/core/error/failures.dart';
import 'package:tasbal/src/features/onboarding/domain/repositories/onboarding_repository.dart';

/// オンボーディング完了ユースケース
///
/// オンボーディング画面で最後まで進んだ際に呼び出される
/// 完了フラグとバージョンをローカルストレージに保存
class CompleteOnboardingUseCase {
  /// オンボーディングリポジトリ
  final OnboardingRepository repository;

  CompleteOnboardingUseCase(this.repository);

  /// オンボーディングを完了としてマーク
  ///
  /// [version] オンボーディングバージョン（省略時は現在のバージョン）
  /// Returns: 成功時はRight(void)、失敗時はLeft(Failure)
  Future<Either<Failure, void>> call({int? version}) async {
    return await repository.saveCompletionStatus(
      completed: true,
      version: version,
    );
  }
}
