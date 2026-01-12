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
  /// 設計書: 反発係数 0.7、減衰 0.99/frame
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

      // 衝突法線を計算
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

      if (overlap > 0) {
        // 両方の風船を反対方向に押し出す
        final pushDistance = overlap / 2;
        final push = Offset(
          normal.dx * pushDistance,
          normal.dy * pushDistance,
        );

        newStates[collision.index1] = state1.copyWith(
          position: Offset(
            state1.position.dx + push.dx,
            state1.position.dy + push.dy,
          ),
        );

        newStates[collision.index2] = state2.copyWith(
          position: Offset(
            state2.position.dx - push.dx,
            state2.position.dy - push.dy,
          ),
        );
      }

      // 反射を適用
      newStates[collision.index1] = physics.applyReflection(
        state: newStates[collision.index1],
        reflectionNormal: normal,
        restitution: 0.7,
        decay: 0.99,
      );

      newStates[collision.index2] = physics.applyReflection(
        state: newStates[collision.index2],
        reflectionNormal: Offset(-normal.dx, -normal.dy), // 逆方向
        restitution: 0.7,
        decay: 0.99,
      );
    }

    return newStates;
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
