/// Onboarding Repository Interface
///
/// オンボーディング機能のリポジトリインターフェース
/// ローカルストレージとの通信を抽象化
library;

import 'package:dartz/dartz.dart';
import 'package:tasbal/src/core/error/failures.dart';

/// オンボーディングリポジトリ
///
/// オンボーディング状態の永続化と取得を担当
abstract class OnboardingRepository {
  /// オンボーディング完了状態を保存
  ///
  /// [completed] 完了状態（true: 完了, false: 未完了）
  /// [version] オンボーディングバージョン（省略時は現在のバージョン）
  /// Returns: 成功時はRight(void)、失敗時はLeft(Failure)
  Future<Either<Failure, void>> saveCompletionStatus({
    required bool completed,
    int? version,
  });

  /// オンボーディング完了状態を取得
  ///
  /// Returns: 成功時はRight(bool)、失敗時はLeft(Failure)
  Future<Either<Failure, bool>> hasCompletedOnboarding();

  /// オンボーディングバージョンを取得
  ///
  /// Returns: 成功時はRight(int)、失敗時はLeft(Failure)
  Future<Either<Failure, int>> getSavedVersion();

  /// オンボーディング状態をクリア
  ///
  /// デバッグやテスト用
  /// Returns: 成功時はRight(void)、失敗時はLeft(Failure)
  Future<Either<Failure, void>> clearOnboardingData();
}
