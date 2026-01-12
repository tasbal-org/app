/// Balloon 3D Transform
///
/// 風船の3D座標変換と透視投影
/// Wii U Mii風の俯瞰視点を実現
library;

import 'dart:math';
import 'dart:ui';

/// 3D座標
class Vector3D {
  final double x;
  final double y;
  final double z;

  const Vector3D(this.x, this.y, this.z);

  Vector3D operator +(Vector3D other) =>
      Vector3D(x + other.x, y + other.y, z + other.z);

  Vector3D operator -(Vector3D other) =>
      Vector3D(x - other.x, y - other.y, z - other.z);

  Vector3D operator *(double scalar) =>
      Vector3D(x * scalar, y * scalar, z * scalar);

  double get length => sqrt(x * x + y * y + z * z);

  Vector3D normalized() {
    final len = length;
    if (len == 0) return this;
    return Vector3D(x / len, y / len, z / len);
  }
}

/// 風船カメラ
///
/// 俯瞰視点（30-45度）の透視投影カメラ
class BalloonCamera {
  /// カメラ位置
  final Vector3D position;

  /// 注視点
  final Vector3D target;

  /// 視野角（FOV）
  final double fov;

  /// 俯瞰角度（ラジアン）
  final double angle;

  /// 画面サイズ
  final Size screenSize;

  const BalloonCamera({
    this.position = const Vector3D(0, 200, -300),
    this.target = const Vector3D(0, 0, 0),
    this.fov = 50.0,
    this.angle = 0.6, // 約34度
    required this.screenSize,
  });

  /// 3D座標を2D画面座標に変換（透視投影）
  Offset project3DTo2D(Vector3D point) {
    // カメラ空間への変換
    final relativeToCamera = point - position;

    // 回転行列（俯瞰角度）
    final cosAngle = cos(angle);
    final sinAngle = sin(angle);

    final rotatedY = relativeToCamera.y * cosAngle - relativeToCamera.z * sinAngle;
    final rotatedZ = relativeToCamera.y * sinAngle + relativeToCamera.z * sinAngle;

    // 透視投影
    final distance = 300.0; // カメラからの基準距離
    final perspectiveFactor = distance / (distance + rotatedZ);

    // 画面中心を基準に投影
    final screenX = screenSize.width / 2 + relativeToCamera.x * perspectiveFactor;
    final screenY = screenSize.height / 2 + rotatedY * perspectiveFactor;

    return Offset(screenX, screenY);
  }

  /// Z座標から拡大率を計算
  double getScaleFactor(double z) {
    final distance = 300.0;
    final relativeZ = z - position.z;
    return distance / (distance + relativeZ).clamp(1.0, 1000.0);
  }

  /// Z座標からフォグ係数を計算（0.0=透明, 1.0=完全）
  double getFogFactor(double z) {
    const near = 100.0; // フォグ開始距離
    const far = 800.0; // フォグ完全濃度距離

    final relativeZ = (z - position.z).abs();

    if (relativeZ < near) return 0.0;
    if (relativeZ > far) return 1.0;
    return (relativeZ - near) / (far - near);
  }

  /// フォグを適用した色を取得
  Color applyFog(Color balloonColor, double z) {
    final fogColor = const Color(0xFFE8E8E8);
    final factor = getFogFactor(z);
    return Color.lerp(balloonColor, fogColor, factor)!;
  }
}

/// 風船の3D物理状態
class Balloon3DPhysicsState {
  /// 3D位置
  final Vector3D position;

  /// 3D速度
  final Vector3D velocity;

  /// 横揺れ位相
  final double swayPhase;

  /// 横揺れ周期
  final double swayPeriod;

  /// 回転角度（ラジアン）
  final double rotation;

  const Balloon3DPhysicsState({
    required this.position,
    required this.velocity,
    required this.swayPhase,
    required this.swayPeriod,
    this.rotation = 0.0,
  });

  Balloon3DPhysicsState copyWith({
    Vector3D? position,
    Vector3D? velocity,
    double? swayPhase,
    double? swayPeriod,
    double? rotation,
  }) {
    return Balloon3DPhysicsState(
      position: position ?? this.position,
      velocity: velocity ?? this.velocity,
      swayPhase: swayPhase ?? this.swayPhase,
      swayPeriod: swayPeriod ?? this.swayPeriod,
      rotation: rotation ?? this.rotation,
    );
  }
}
