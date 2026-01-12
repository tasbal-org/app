/// Balloon Inflation Animation
///
/// 風船の膨らみアニメーション
/// タップで膨らみ、一定以上膨らむと破裂
library;

import 'dart:math';

/// 膨らみアニメーションの状態
class BalloonInflationState {
  /// 現在の膨らみ倍率（1.0 = 通常サイズ）
  final double bulge;

  /// 目標の膨らみ倍率
  final double targetBulge;

  /// 膨らみの速度
  final double bulgeVelocity;

  /// 初期膨らみアニメーションの進捗（0.0 ～ 1.0）
  final double inflationProgress;

  /// 破裂したかどうか
  final bool isPopped;

  /// 破裂時刻（nullの場合は未破裂）
  final DateTime? poppedAt;

  const BalloonInflationState({
    this.bulge = 1.0,
    this.targetBulge = 1.0,
    this.bulgeVelocity = 0.0,
    this.inflationProgress = 1.0,
    this.isPopped = false,
    this.poppedAt,
  });

  BalloonInflationState copyWith({
    double? bulge,
    double? targetBulge,
    double? bulgeVelocity,
    double? inflationProgress,
    bool? isPopped,
    DateTime? poppedAt,
  }) {
    return BalloonInflationState(
      bulge: bulge ?? this.bulge,
      targetBulge: targetBulge ?? this.targetBulge,
      bulgeVelocity: bulgeVelocity ?? this.bulgeVelocity,
      inflationProgress: inflationProgress ?? this.inflationProgress,
      isPopped: isPopped ?? this.isPopped,
      poppedAt: poppedAt ?? this.poppedAt,
    );
  }
}

/// 膨らみアニメーションエンジン
class BalloonInflationEngine {
  /// バネ定数（膨らみの戻り速度）
  static const double springK = 0.15;

  /// 減衰係数
  static const double springDamp = 0.85;

  /// 破裂する膨らみの閾値
  static const double popThreshold = 1.8;

  /// タップ時の膨らみ増加量
  static const double tapBulgeIncrement = 0.2;

  /// タップ時の速度増加量
  static const double tapVelocityKick = 0.05;

  /// 初期膨らみアニメーション速度
  static const double initialInflationSpeed = 0.015;

  const BalloonInflationEngine();

  /// 初期状態を生成
  BalloonInflationState createInitialState({
    double initialInflationProgress = 0.0,
    double targetScale = 1.0,
  }) {
    return BalloonInflationState(
      bulge: 1.0,
      targetBulge: 1.0,
      bulgeVelocity: 0.0,
      inflationProgress: initialInflationProgress,
      isPopped: false,
    );
  }

  /// 状態を更新
  ///
  /// [state] 現在の状態
  /// [deltaTime] 経過時間（秒）
  /// [inflationDelay] 初期膨らみアニメーションの遅延（ミリ秒）
  /// [elapsedTime] 開始からの経過時間（ミリ秒）
  BalloonInflationState updateState({
    required BalloonInflationState state,
    required double deltaTime,
    double inflationDelay = 0,
    double elapsedTime = 0,
  }) {
    if (state.isPopped) {
      return state;
    }

    var newBulge = state.bulge;
    var newBulgeVelocity = state.bulgeVelocity;
    var newInflationProgress = state.inflationProgress;
    var newIsPopped = state.isPopped;
    DateTime? newPoppedAt = state.poppedAt;

    // 初期膨らみアニメーション
    if (newInflationProgress < 1.0 && elapsedTime > inflationDelay) {
      newInflationProgress += initialInflationSpeed;
      if (newInflationProgress > 1.0) {
        newInflationProgress = 1.0;
      }
    }

    // バネ物理演算
    final force = (state.targetBulge - newBulge) * springK;
    newBulgeVelocity += force;
    newBulgeVelocity *= springDamp;
    newBulge += newBulgeVelocity;

    // 破裂判定
    if (newBulge > popThreshold && !newIsPopped) {
      newIsPopped = true;
      newPoppedAt = DateTime.now();
    }

    return state.copyWith(
      bulge: newBulge,
      bulgeVelocity: newBulgeVelocity,
      inflationProgress: newInflationProgress,
      isPopped: newIsPopped,
      poppedAt: newPoppedAt,
    );
  }

  /// タップで膨らませる
  BalloonInflationState inflate(BalloonInflationState state) {
    if (state.isPopped) {
      return state;
    }

    return state.copyWith(
      targetBulge: state.targetBulge + tapBulgeIncrement,
      bulgeVelocity: state.bulgeVelocity + tapVelocityKick,
    );
  }

  /// 膨らみをリセット（ゆっくり戻す）
  BalloonInflationState resetBulge(BalloonInflationState state) {
    if (state.isPopped) {
      return state;
    }

    return state.copyWith(
      targetBulge: 1.0,
    );
  }

  /// Elastic イージング（弾むような動き）
  static double easeOutElastic(double x) {
    const c4 = (2 * pi) / 3;
    if (x == 0) return 0;
    if (x == 1) return 1;
    return pow(2, -10 * x) * sin((x * 10 - 0.75) * c4) + 1;
  }

  /// 膨らみ進捗にイージングを適用したスケールを取得
  double getAnimatedScale(BalloonInflationState state, double targetScale) {
    final easedProgress = easeOutElastic(state.inflationProgress);
    return targetScale * easedProgress;
  }
}
