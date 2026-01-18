/// Balloon Physics Engine
///
/// 風船の物理挙動を管理
/// 上昇移動、横揺れ、画面境界処理
library;

import 'dart:math';
import 'dart:ui';

import 'package:tasbal/src/core/widgets/balloon/balloon_string_physics.dart';
import 'package:tasbal/src/features/balloon/domain/entities/balloon.dart';

/// 風船の物理状態
///
/// 位置、速度、加速度を保持
class BalloonPhysicsState {
  /// 位置（画面座標）
  final Offset position;

  /// 速度（px/s）
  final Offset velocity;

  /// 横揺れ位相（0 ～ 2π）
  final double swayPhase;

  /// 横揺れ周期（秒）
  final double swayPeriod;

  /// 紐の物理状態
  final StringPhysicsState stringState;

  const BalloonPhysicsState({
    required this.position,
    required this.velocity,
    required this.swayPhase,
    required this.swayPeriod,
    required this.stringState,
  });

  /// コピー with
  BalloonPhysicsState copyWith({
    Offset? position,
    Offset? velocity,
    double? swayPhase,
    double? swayPeriod,
    StringPhysicsState? stringState,
  }) {
    return BalloonPhysicsState(
      position: position ?? this.position,
      velocity: velocity ?? this.velocity,
      swayPhase: swayPhase ?? this.swayPhase,
      swayPeriod: swayPeriod ?? this.swayPeriod,
      stringState: stringState ?? this.stringState,
    );
  }
}

/// 風船物理エンジン
///
/// 物理シミュレーション
/// - 移動速度：8 ～ 18 px/s（ランダム方向）
/// - 横揺れ：-6 ～ +6 px/s
/// - ゆらぎ周期：4 ～ 7 秒
class BalloonPhysics {
  final Random _random = Random();
  final BalloonStringPhysics _stringPhysics = BalloonStringPhysics();

  /// 移動速度の最小値（px/s）
  static const double minSpeed = 8.0;

  /// 移動速度の最大値（px/s）
  static const double maxSpeed = 18.0;

  /// 横揺れの最大振幅（px/s）
  static const double maxSwayAmplitude = 6.0;

  /// 横揺れ周期の最小値（秒）
  static const double minSwayPeriod = 4.0;

  /// 横揺れ周期の最大値（秒）
  static const double maxSwayPeriod = 7.0;

  /// 初期物理状態を生成
  ///
  /// 画面サイズと風船タイプに基づいて初期位置と速度を決定
  BalloonPhysicsState createInitialState({
    required Size screenSize,
    required Balloon balloon,
  }) {
    // 初期位置：画面全体にランダムに配置
    final x = _random.nextDouble() * screenSize.width;
    final y = _random.nextDouble() * screenSize.height;

    // ランダムな方向に移動（360度どの方向にも）
    final angle = _random.nextDouble() * 2 * pi;
    final speed = minSpeed + _random.nextDouble() * (maxSpeed - minSpeed);
    final velocityX = cos(angle) * speed;
    final velocityY = sin(angle) * speed;

    // 横揺れ周期：4 ～ 7 秒のランダム値
    final swayPeriod =
        minSwayPeriod + _random.nextDouble() * (maxSwayPeriod - minSwayPeriod);

    // 初期位相：0 ～ 2π のランダム値
    final swayPhase = _random.nextDouble() * 2 * pi;

    final position = Offset(x, y);

    // 紐の初期状態を生成
    final stringState = _stringPhysics.createInitialState(
      balloonPosition: position,
      balloonRadius: balloon.currentRadius,
    );

    return BalloonPhysicsState(
      position: position,
      velocity: Offset(velocityX, velocityY),
      swayPhase: swayPhase,
      swayPeriod: swayPeriod,
      stringState: stringState,
    );
  }

  /// 物理状態を更新
  ///
  /// deltaTime（秒）分の時間経過に応じて位置と速度を更新
  BalloonPhysicsState updateState({
    required BalloonPhysicsState state,
    required Balloon balloon,
    required Size screenSize,
    required double deltaTime,
  }) {
    // 横揺れの位相を更新
    final newSwayPhase = state.swayPhase + (2 * pi / state.swayPeriod) * deltaTime;

    // 横揺れによる追加の横方向速度（-6 ～ +6 px/s）
    final swayVelocity = maxSwayAmplitude * sin(newSwayPhase);

    // 新しい位置を計算（X・Y両方向の速度を使用）
    final newX = state.position.dx + state.velocity.dx * deltaTime + swayVelocity * deltaTime;
    final newY = state.position.dy + state.velocity.dy * deltaTime;

    var newPosition = Offset(newX, newY);
    var newVelocity = state.velocity;

    // 画面境界処理
    if (balloon.isPinned) {
      // ピン留めグループ：画面端で反射
      newPosition = _handlePinnedBoundary(
        position: newPosition,
        velocity: newVelocity,
        screenSize: screenSize,
        balloonRadius: balloon.currentRadius,
      ).position;
      newVelocity = _handlePinnedBoundary(
        position: newPosition,
        velocity: newVelocity,
        screenSize: screenSize,
        balloonRadius: balloon.currentRadius,
      ).velocity;
    } else {
      // 流動グループ：画面外に出たら画面全体にランダムに再出現
      if (_isOffScreen(newPosition, screenSize, balloon.currentRadius)) {
        return createInitialState(screenSize: screenSize, balloon: balloon);
      }
    }

    // 紐の物理状態を更新
    final newStringState = _stringPhysics.updateState(
      state: state.stringState,
      balloonPosition: newPosition,
      balloonRadius: balloon.currentRadius,
      deltaTime: deltaTime,
    );

    return BalloonPhysicsState(
      position: newPosition,
      velocity: newVelocity,
      swayPhase: newSwayPhase,
      swayPeriod: state.swayPeriod,
      stringState: newStringState,
    );
  }

  /// ピン留めグループの境界処理
  ///
  /// 画面端で反射させる
  ({Offset position, Offset velocity}) _handlePinnedBoundary({
    required Offset position,
    required Offset velocity,
    required Size screenSize,
    required double balloonRadius,
  }) {
    var newX = position.dx;
    var newY = position.dy;
    var newVx = velocity.dx;
    var newVy = velocity.dy;

    // 左端
    if (newX - balloonRadius < 0) {
      newX = balloonRadius;
      newVx = newVx.abs();
    }

    // 右端
    if (newX + balloonRadius > screenSize.width) {
      newX = screenSize.width - balloonRadius;
      newVx = -newVx.abs();
    }

    // 上端
    if (newY - balloonRadius < 0) {
      newY = balloonRadius;
      newVy = newVy.abs();
    }

    // 下端
    if (newY + balloonRadius > screenSize.height) {
      newY = screenSize.height - balloonRadius;
      newVy = -newVy.abs();
    }

    return (
      position: Offset(newX, newY),
      velocity: Offset(newVx, newVy),
    );
  }

  /// 画面外判定
  ///
  /// 風船が完全に画面外に出たかどうか
  bool _isOffScreen(Offset position, Size screenSize, double radius) {
    return position.dx + radius < 0 ||
        position.dx - radius > screenSize.width ||
        position.dy + radius < 0 ||
        position.dy - radius > screenSize.height;
  }

  /// 反射処理を適用
  ///
  /// 衝突時の反発を計算（減衰係数：0.7、フレーム減衰：0.99）
  BalloonPhysicsState applyReflection({
    required BalloonPhysicsState state,
    required Offset reflectionNormal,
    double restitution = 0.7,
    double decay = 0.99,
  }) {
    // 法線方向の速度成分を計算
    final velocityDotNormal =
        state.velocity.dx * reflectionNormal.dx +
        state.velocity.dy * reflectionNormal.dy;

    // 反射ベクトルを計算
    final reflectedVelocity = Offset(
      state.velocity.dx - 2 * velocityDotNormal * reflectionNormal.dx,
      state.velocity.dy - 2 * velocityDotNormal * reflectionNormal.dy,
    );

    // 反発係数と減衰を適用
    final dampedVelocity = Offset(
      reflectedVelocity.dx * restitution * decay,
      reflectedVelocity.dy * restitution * decay,
    );

    return state.copyWith(
      velocity: dampedVelocity,
    );
  }

  /// 2つの風船が衝突しているか判定
  ///
  /// 円形の簡易衝突判定
  bool isColliding(
    BalloonPhysicsState state1,
    Balloon balloon1,
    BalloonPhysicsState state2,
    Balloon balloon2,
  ) {
    final dx = state1.position.dx - state2.position.dx;
    final dy = state1.position.dy - state2.position.dy;
    final distance = sqrt(dx * dx + dy * dy);
    final minDistance = balloon1.currentRadius + balloon2.currentRadius;

    return distance < minDistance;
  }

  /// 衝突時の反射方向を計算
  ///
  /// 2つの風船の中心を結ぶベクトルに垂直な法線ベクトルを返す
  Offset calculateCollisionNormal(
    BalloonPhysicsState state1,
    BalloonPhysicsState state2,
  ) {
    final dx = state1.position.dx - state2.position.dx;
    final dy = state1.position.dy - state2.position.dy;
    final distance = sqrt(dx * dx + dy * dy);

    if (distance == 0) {
      // 完全に重なっている場合はランダムな方向
      return Offset(
        _random.nextDouble() * 2 - 1,
        _random.nextDouble() * 2 - 1,
      );
    }

    return Offset(dx / distance, dy / distance);
  }
}
