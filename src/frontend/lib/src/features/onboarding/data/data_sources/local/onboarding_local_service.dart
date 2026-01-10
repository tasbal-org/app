/// Onboarding Local Service
///
/// オンボーディング関連のローカルストレージ操作を管理
/// Hiveを使用してオンボーディング完了状態を永続化
library;

import 'package:hive_flutter/hive_flutter.dart';
import 'package:tasbal/src/core/error/exceptions.dart';

/// オンボーディングローカルサービス
///
/// オンボーディング完了フラグやバージョン情報をHiveで管理
class OnboardingLocalService {
  /// Hiveボックス名
  static const String _boxName = 'onboarding_box';

  /// オンボーディング完了フラグのキー
  static const String _completedKey = 'has_completed_onboarding';

  /// オンボーディングバージョンのキー
  static const String _versionKey = 'onboarding_version';

  /// 現在のオンボーディングバージョン
  /// UIや内容が変わった場合はこの値を増やす
  static const int currentVersion = 1;

  /// オンボーディング完了フラグを保存
  ///
  /// [completed] 完了状態（true: 完了, false: 未完了）
  /// [version] オンボーディングのバージョン（省略時は現在のバージョン）
  Future<void> saveCompletionStatus({
    required bool completed,
    int? version,
  }) async {
    try {
      final box = await Hive.openBox(_boxName);
      await box.put(_completedKey, completed);
      await box.put(_versionKey, version ?? currentVersion);
    } catch (e) {
      throw CacheException(
        message: 'Failed to save onboarding completion status: $e',
      );
    }
  }

  /// オンボーディング完了フラグを取得
  ///
  /// Returns: 完了済みの場合true、未完了の場合false
  Future<bool> hasCompletedOnboarding() async {
    try {
      final box = await Hive.openBox(_boxName);
      final completed = box.get(_completedKey, defaultValue: false) as bool;
      final savedVersion = box.get(_versionKey, defaultValue: 0) as int;

      // バージョンが古い場合は未完了扱い（再表示）
      if (savedVersion < currentVersion) {
        return false;
      }

      return completed;
    } catch (e) {
      throw CacheException(
        message: 'Failed to get onboarding completion status: $e',
      );
    }
  }

  /// オンボーディングバージョンを取得
  ///
  /// Returns: 保存されているバージョン番号（未保存の場合は0）
  Future<int> getSavedVersion() async {
    try {
      final box = await Hive.openBox(_boxName);
      return box.get(_versionKey, defaultValue: 0) as int;
    } catch (e) {
      throw CacheException(
        message: 'Failed to get onboarding version: $e',
      );
    }
  }

  /// オンボーディング状態をクリア
  ///
  /// 主にデバッグやテスト用
  Future<void> clearOnboardingData() async {
    try {
      final box = await Hive.openBox(_boxName);
      await box.clear();
    } catch (e) {
      throw CacheException(
        message: 'Failed to clear onboarding data: $e',
      );
    }
  }
}
