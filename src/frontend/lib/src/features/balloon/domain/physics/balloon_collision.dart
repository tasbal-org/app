/// Balloon Collision Detection
///
/// 空間分割グリッドを用いた高速衝突判定
/// 設計書: 全風船衝突ON、円形簡易衝突判定、空間分割必須
library;

import 'dart:math';
import 'dart:ui';

import 'package:tasbal/src/features/balloon/domain/entities/balloon.dart';
import 'package:tasbal/src/features/balloon/domain/physics/balloon_physics.dart';

/// 空間グリッドのセル
///
/// 各セルに含まれる風船のインデックスを保持
class GridCell {
  final List<int> balloonIndices = [];

  void clear() => balloonIndices.clear();
  void add(int index) => balloonIndices.add(index);
}

/// 衝突ペア
///
/// 衝突している2つの風船のインデックス
class CollisionPair {
  final int index1;
  final int index2;

  const CollisionPair(this.index1, this.index2);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CollisionPair &&
          ((index1 == other.index1 && index2 == other.index2) ||
              (index1 == other.index2 && index2 == other.index1));

  @override
  int get hashCode => index1.hashCode ^ index2.hashCode;
}

/// 風船衝突検出エンジン
///
/// 空間分割グリッドを使用してO(n²)からO(n)に最適化
class BalloonCollisionDetector {
  /// グリッドのセルサイズ（px）
  /// 風船の最大直径を考慮して設定（最大半径28+14=42px → 直径84px）
  static const double cellSize = 100.0;

  /// 空間グリッド
  final Map<String, GridCell> _grid = {};

  /// グリッドをクリア
  void clearGrid() {
    for (final cell in _grid.values) {
      cell.clear();
    }
  }

  /// グリッドキーを生成
  ///
  /// (x, y) 座標から "x,y" 形式のキーを生成
  String _getGridKey(int gridX, int gridY) {
    return '$gridX,$gridY';
  }

  /// 風船が占有するグリッドセルを取得
  ///
  /// 風船の半径を考慮して、複数のセルにまたがる場合も処理
  List<String> _getOccupiedCells(Offset position, double radius) {
    final cells = <String>[];

    final minX = ((position.dx - radius) / cellSize).floor();
    final maxX = ((position.dx + radius) / cellSize).floor();
    final minY = ((position.dy - radius) / cellSize).floor();
    final maxY = ((position.dy + radius) / cellSize).floor();

    for (var x = minX; x <= maxX; x++) {
      for (var y = minY; y <= maxY; y++) {
        cells.add(_getGridKey(x, y));
      }
    }

    return cells;
  }

  /// 風船をグリッドに登録
  ///
  /// 風船の位置と半径に基づいて該当するセルに登録
  void registerBalloon({
    required int index,
    required Offset position,
    required double radius,
  }) {
    final cells = _getOccupiedCells(position, radius);

    for (final cellKey in cells) {
      _grid.putIfAbsent(cellKey, () => GridCell());
      _grid[cellKey]!.add(index);
    }
  }

  /// 衝突ペアを検出
  ///
  /// グリッドベースの高速衝突判定
  List<CollisionPair> detectCollisions({
    required List<BalloonPhysicsState> states,
    required List<Balloon> balloons,
  }) {
    clearGrid();

    // 全風船をグリッドに登録
    for (var i = 0; i < states.length; i++) {
      registerBalloon(
        index: i,
        position: states[i].position,
        radius: balloons[i].currentRadius,
      );
    }

    final collisionPairs = <CollisionPair>{};

    // 各セル内で衝突判定
    for (final cell in _grid.values) {
      final indices = cell.balloonIndices;

      // セル内の全ペアをチェック
      for (var i = 0; i < indices.length; i++) {
        for (var j = i + 1; j < indices.length; j++) {
          final index1 = indices[i];
          final index2 = indices[j];

          // 円形の簡易衝突判定
          if (_checkCircleCollision(
            states[index1].position,
            balloons[index1].currentRadius,
            states[index2].position,
            balloons[index2].currentRadius,
          )) {
            collisionPairs.add(CollisionPair(index1, index2));
          }
        }
      }
    }

    return collisionPairs.toList();
  }

  /// 円形衝突判定
  ///
  /// 2つの円が重なっているかを判定
  bool _checkCircleCollision(
    Offset position1,
    double radius1,
    Offset position2,
    double radius2,
  ) {
    final dx = position1.dx - position2.dx;
    final dy = position1.dy - position2.dy;
    final distanceSquared = dx * dx + dy * dy;
    final minDistance = radius1 + radius2;

    return distanceSquared < minDistance * minDistance;
  }

  /// 衝突を解決
  ///
  /// 弾性衝突による運動量・エネルギー保存則に基づく衝突応答
  /// 設計書: 反発係数 0.7
  List<BalloonPhysicsState> resolveCollisions({
    required List<BalloonPhysicsState> states,
    required List<Balloon> balloons,
    required List<CollisionPair> collisions,
    required BalloonPhysics physics,
  }) {
    final newStates = List<BalloonPhysicsState>.from(states);

    for (final collision in collisions) {
      final state1 = newStates[collision.index1];
      final state2 = newStates[collision.index2];
      final balloon1 = balloons[collision.index1];
      final balloon2 = balloons[collision.index2];

      // 衝突法線を計算（風船1から風船2への方向）
      final normal = _calculateCollisionNormal(
        state1.position,
        state2.position,
      );

      // 風船を押し出す（重なりを解消）
      final overlap = _calculateOverlap(
        state1.position,
        balloon1.currentRadius,
        state2.position,
        balloon2.currentRadius,
      );

      var pos1 = state1.position;
      var pos2 = state2.position;

      if (overlap > 0) {
        // 両方の風船を反対方向に押し出す
        final pushDistance = overlap / 2 + 0.5; // 少し余分に押し出す
        final push = Offset(
          normal.dx * pushDistance,
          normal.dy * pushDistance,
        );

        pos1 = Offset(pos1.dx + push.dx, pos1.dy + push.dy);
        pos2 = Offset(pos2.dx - push.dx, pos2.dy - push.dy);
      }

      // 弾性衝突の速度計算（運動量保存則に基づく）
      final velocities = _calculateElasticCollisionVelocities(
        velocity1: state1.velocity,
        velocity2: state2.velocity,
        mass1: balloon1.currentRadius * balloon1.currentRadius, // 半径の2乗を質量として使用
        mass2: balloon2.currentRadius * balloon2.currentRadius,
        normal: normal,
        restitution: 0.7,
      );

      newStates[collision.index1] = state1.copyWith(
        position: pos1,
        velocity: velocities.velocity1,
      );

      newStates[collision.index2] = state2.copyWith(
        position: pos2,
        velocity: velocities.velocity2,
      );
    }

    return newStates;
  }

  /// 弾性衝突による速度計算
  ///
  /// 運動量保存則とエネルギー保存則に基づいて衝突後の速度を計算
  /// v1' = v1 - (2*m2/(m1+m2)) * <v1-v2, n> * n
  /// v2' = v2 - (2*m1/(m1+m2)) * <v2-v1, n> * n
  ({Offset velocity1, Offset velocity2}) _calculateElasticCollisionVelocities({
    required Offset velocity1,
    required Offset velocity2,
    required double mass1,
    required double mass2,
    required Offset normal,
    required double restitution,
  }) {
    // 相対速度
    final relativeVelocity = Offset(
      velocity1.dx - velocity2.dx,
      velocity1.dy - velocity2.dy,
    );

    // 法線方向の相対速度成分
    final relVelDotNormal =
        relativeVelocity.dx * normal.dx + relativeVelocity.dy * normal.dy;

    // 離れていく方向なら衝突処理しない
    if (relVelDotNormal > 0) {
      return (velocity1: velocity1, velocity2: velocity2);
    }

    // 質量を考慮した衝撃力の係数
    final totalMass = mass1 + mass2;
    final impulseScalar = -(1 + restitution) * relVelDotNormal / totalMass;

    // 衝撃力ベクトル
    final impulse = Offset(
      impulseScalar * normal.dx,
      impulseScalar * normal.dy,
    );

    // 新しい速度を計算（運動量保存）
    final newVelocity1 = Offset(
      velocity1.dx + impulse.dx * mass2,
      velocity1.dy + impulse.dy * mass2,
    );

    final newVelocity2 = Offset(
      velocity2.dx - impulse.dx * mass1,
      velocity2.dy - impulse.dy * mass1,
    );

    return (velocity1: newVelocity1, velocity2: newVelocity2);
  }

  /// 衝突法線を計算
  ///
  /// 2つの風船の中心を結ぶ方向ベクトル
  Offset _calculateCollisionNormal(Offset position1, Offset position2) {
    final dx = position1.dx - position2.dx;
    final dy = position1.dy - position2.dy;
    final distance = sqrt(dx * dx + dy * dy);

    if (distance == 0) {
      // 完全に重なっている場合は上方向を返す
      return const Offset(0, -1);
    }

    return Offset(dx / distance, dy / distance);
  }

  /// 重なり量を計算
  ///
  /// 2つの円がどれだけ重なっているか
  double _calculateOverlap(
    Offset position1,
    double radius1,
    Offset position2,
    double radius2,
  ) {
    final dx = position1.dx - position2.dx;
    final dy = position1.dy - position2.dy;
    final distance = sqrt(dx * dx + dy * dy);
    final minDistance = radius1 + radius2;

    return max(0, minDistance - distance);
  }

  /// グリッド統計を取得（デバッグ用）
  ///
  /// セル数、最大風船数などの情報
  Map<String, dynamic> getGridStats() {
    var totalBalloons = 0;
    var maxBalloonsInCell = 0;
    var nonEmptyCells = 0;

    for (final cell in _grid.values) {
      final count = cell.balloonIndices.length;
      if (count > 0) {
        nonEmptyCells++;
        totalBalloons += count;
        if (count > maxBalloonsInCell) {
          maxBalloonsInCell = count;
        }
      }
    }

    return {
      'totalCells': _grid.length,
      'nonEmptyCells': nonEmptyCells,
      'totalBalloons': totalBalloons,
      'maxBalloonsInCell': maxBalloonsInCell,
      'averageBalloonsPerCell':
          nonEmptyCells > 0 ? totalBalloons / nonEmptyCells : 0,
    };
  }
}
