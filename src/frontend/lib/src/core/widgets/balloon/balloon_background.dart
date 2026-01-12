/// Balloon Background Layer
///
/// 背景風船レイヤーウィジェット
/// 全画面で使用する風船アニメーションシステム
library;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tasbal/src/enums/balloon_display_group.dart';
import 'package:tasbal/src/enums/balloon_type.dart';
import 'package:tasbal/src/core/widgets/balloon/balloon_background_painter.dart';
import 'package:tasbal/src/core/widgets/balloon/balloon_grid_painter.dart';
import 'package:tasbal/src/core/widgets/balloon/balloon_painter.dart';
import 'package:tasbal/src/features/balloon/domain/entities/balloon.dart';
import 'package:tasbal/src/features/balloon/domain/physics/balloon_collision.dart';
import 'package:tasbal/src/features/balloon/domain/physics/balloon_physics.dart';

/// パフォーマンス品質設定
enum BalloonQuality {
  /// 通常品質（14個の風船）
  normal(14),

  /// 低品質（10個の風船）
  low(10),

  /// 最大品質（30個の風船）
  max(30);

  final int balloonCount;
  const BalloonQuality(this.balloonCount);
}

/// 風船背景レイヤー
///
/// すべての画面の背景に表示される風船アニメーション
class BalloonBackgroundLayer extends StatefulWidget {
  /// パフォーマンス品質
  final BalloonQuality quality;

  /// デバッグモード（衝突判定の可視化）
  final bool debugMode;

  /// 風船タップコールバック
  final void Function(Balloon balloon)? onBalloonTap;

  const BalloonBackgroundLayer({
    super.key,
    this.quality = BalloonQuality.normal,
    this.debugMode = false,
    this.onBalloonTap,
  });

  @override
  State<BalloonBackgroundLayer> createState() => _BalloonBackgroundLayerState();
}

class _BalloonBackgroundLayerState extends State<BalloonBackgroundLayer>
    with SingleTickerProviderStateMixin {
  /// 風船エンティティリスト
  late List<Balloon> _balloons;

  /// 風船物理状態リスト
  late List<BalloonPhysicsState> _physicsStates;

  /// 物理エンジン
  final BalloonPhysics _physics = BalloonPhysics();

  /// 衝突検出エンジン
  final BalloonCollisionDetector _collisionDetector = BalloonCollisionDetector();

  /// アニメーションティッカー
  Ticker? _ticker;

  /// 前回フレームの時刻
  Duration _lastFrameTime = Duration.zero;

  /// ランダム生成器
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _initializeBalloons();
    _startAnimation();
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }

  /// 風船を初期化
  void _initializeBalloons() {
    _balloons = List.generate(
      widget.quality.balloonCount,
      (index) => _createRandomBalloon(index),
    );

    _physicsStates = [];

    debugPrint('[Balloon] 風船を${_balloons.length}個作成しました');
  }

  /// ランダムな風船を生成
  Balloon _createRandomBalloon(int index) {
    // ランダムな色を生成
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.teal,
    ];
    final color = colors[_random.nextInt(colors.length)];

    // ランダムなタイプとグループ
    final types = BalloonType.values;
    final type = types[_random.nextInt(types.length)];

    // ピン留めグループと流動グループを半々に
    final displayGroup = index < widget.quality.balloonCount / 2
        ? BalloonDisplayGroup.Pinned
        : BalloonDisplayGroup.Drifting;

    // ランダムな進捗値
    final currentValue = _random.nextInt(80);
    final nextThreshold = 100;

    // USER風船の場合はタグアイコンを設定
    final tagIconId = type == BalloonType.User
        ? _random.nextInt(12) + 1 // 1-12のランダムID
        : null;

    return Balloon(
      id: 'balloon_$index',
      type: type,
      displayGroup: displayGroup,
      color: color,
      currentValue: currentValue,
      nextThreshold: nextThreshold,
      tagIconId: tagIconId,
      createdAt: DateTime.now(),
    );
  }

  /// アニメーションを開始
  void _startAnimation() {
    _ticker = createTicker(_onTick);
    _ticker!.start();
  }

  /// フレーム更新
  void _onTick(Duration elapsed) {
    if (!mounted) return;

    // 物理状態を初期化（画面サイズが必要なのでここで実行）
    if (_physicsStates.isEmpty) {
      _initializePhysicsStates();
      _lastFrameTime = elapsed;
      setState(() {});
      return;
    }

    // 初回フレーム
    if (_lastFrameTime == Duration.zero) {
      _lastFrameTime = elapsed;
      return;
    }

    // デルタタイム（秒）
    final deltaTime = (elapsed - _lastFrameTime).inMicroseconds / 1000000.0;
    _lastFrameTime = elapsed;

    // 物理状態を更新
    _updatePhysics(deltaTime);

    setState(() {});
  }

  /// 物理状態を初期化
  void _initializePhysicsStates() {
    final screenSize = MediaQuery.of(context).size;

    _physicsStates = _balloons.map((balloon) {
      return _physics.createInitialState(
        screenSize: screenSize,
        balloon: balloon,
      );
    }).toList();

    debugPrint('[Balloon] 物理状態を${_physicsStates.length}個初期化しました');
  }

  /// 物理シミュレーションを更新
  void _updatePhysics(double deltaTime) {
    if (_physicsStates.isEmpty) return;

    final screenSize = MediaQuery.of(context).size;

    // 各風船の位置を更新
    for (var i = 0; i < _balloons.length; i++) {
      _physicsStates[i] = _physics.updateState(
        state: _physicsStates[i],
        balloon: _balloons[i],
        screenSize: screenSize,
        deltaTime: deltaTime,
      );
    }

    // 衝突検出
    final collisions = _collisionDetector.detectCollisions(
      states: _physicsStates,
      balloons: _balloons,
    );

    // 衝突解決
    if (collisions.isNotEmpty) {
      _physicsStates = _collisionDetector.resolveCollisions(
        states: _physicsStates,
        balloons: _balloons,
        collisions: collisions,
        physics: _physics,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_physicsStates.isEmpty) {
      return const SizedBox.expand();
    }

    final screenSize = MediaQuery.of(context).size;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SizedBox.expand(
      child: Stack(
        children: [
          // 背景（垂直グラデーション）
          CustomPaint(
            size: screenSize,
            painter: BalloonBackgroundPainter(
              isDarkMode: isDarkMode,
            ),
          ),

          // グリッド（菱形グリッド）
          CustomPaint(
            size: screenSize,
            painter: BalloonGridPainter(
              isDarkMode: isDarkMode,
            ),
          ),

          // 風船を描画
          for (var i = 0; i < _balloons.length; i++)
            BalloonWidget(
              balloon: _balloons[i],
              physicsState: _physicsStates[i],
              debugMode: widget.debugMode,
              onTap: widget.onBalloonTap != null
                  ? () => widget.onBalloonTap!(_balloons[i])
                  : null,
            ),

          // デバッグ情報
          if (widget.debugMode) _buildDebugInfo(),
        ],
      ),
    );
  }

  /// デバッグ情報を表示
  Widget _buildDebugInfo() {
    final stats = _collisionDetector.getGridStats();

    return Positioned(
      top: 50,
      left: 10,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.yellow, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🎈 風船作成数: ${_balloons.length}',
              style: const TextStyle(color: Colors.yellow, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              '📍 物理状態数: ${_physicsStates.length}',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            Text(
              '🔲 Grid Cells: ${stats['nonEmptyCells']}',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            Text(
              '📊 Max/Cell: ${stats['maxBalloonsInCell']}',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

/// 風船背景ラッパー
///
/// 子ウィジェットの背景に風船レイヤーを追加
class BalloonBackground extends StatelessWidget {
  /// 子ウィジェット
  final Widget child;

  /// パフォーマンス品質
  final BalloonQuality quality;

  /// デバッグモード
  final bool debugMode;

  /// 風船タップコールバック
  final void Function(Balloon balloon)? onBalloonTap;

  const BalloonBackground({
    super.key,
    required this.child,
    this.quality = BalloonQuality.normal,
    this.debugMode = false,
    this.onBalloonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 風船背景レイヤー
        BalloonBackgroundLayer(
          quality: quality,
          debugMode: debugMode,
          onBalloonTap: onBalloonTap,
        ),

        // 前面コンテンツ
        child,
      ],
    );
  }
}
