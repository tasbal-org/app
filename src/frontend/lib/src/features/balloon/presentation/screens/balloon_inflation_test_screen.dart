/// Balloon Inflation Test Screen
///
/// 風船の膨らみ・破裂アニメーションのテスト画面
library;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:tasbal/src/core/widgets/balloon/animations/balloon_inflation.dart';
import 'package:tasbal/src/core/widgets/balloon/animations/confetti_particle.dart';
import 'package:tasbal/src/core/widgets/balloon/balloon_background_painter.dart';
import 'package:tasbal/src/core/widgets/balloon/balloon_grid_painter.dart';
import 'package:tasbal/src/core/widgets/balloon/balloon_string_physics.dart';
import 'package:tasbal/src/core/widgets/balloon/renderers/balloon_body_renderer.dart';
import 'package:tasbal/src/enums/balloon_display_group.dart';
import 'package:tasbal/src/enums/balloon_type.dart';
import 'package:tasbal/src/features/balloon/domain/entities/balloon.dart';
import 'package:tasbal/src/features/balloon/domain/physics/balloon_physics.dart';

/// 風船膨らみテスト画面
class BalloonInflationTestScreen extends StatefulWidget {
  const BalloonInflationTestScreen({super.key});

  @override
  State<BalloonInflationTestScreen> createState() =>
      _BalloonInflationTestScreenState();
}

class _BalloonInflationTestScreenState extends State<BalloonInflationTestScreen>
    with SingleTickerProviderStateMixin {
  /// テスト用風船
  late Balloon _balloon;

  /// 物理状態
  late BalloonPhysicsState _physicsState;

  /// 膨らみ状態
  late BalloonInflationState _inflationState;

  /// 紙吹雪システム
  final ConfettiSystem _confettiSystem = ConfettiSystem();

  /// アニメーションエンジン
  final BalloonInflationEngine _inflationEngine = BalloonInflationEngine();
  final BalloonStringPhysics _stringPhysics = BalloonStringPhysics();

  /// ティッカー
  Ticker? _ticker;

  /// 開始時刻
  Duration _startTime = Duration.zero;

  /// 前回フレーム時刻
  Duration _lastFrameTime = Duration.zero;

  /// 自動膨らみモード
  bool _autoInflate = true;

  /// 膨らみ速度（毎秒）
  double _inflateSpeed = 0.3;

  /// 初期化済みフラグ
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeBalloon();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initializePhysics();
      _startAnimation();
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }

  /// 風船を初期化
  void _initializeBalloon() {
    _balloon = Balloon(
      id: 'test_balloon',
      type: BalloonType.User,
      displayGroup: BalloonDisplayGroup.Pinned,
      color: Colors.red,
      currentValue: 50,
      nextThreshold: 100,
      createdAt: DateTime.now(),
    );

    _inflationState = _inflationEngine.createInitialState();
  }

  /// 物理状態を初期化
  void _initializePhysics() {
    final screenSize = MediaQuery.of(context).size;
    final position = Offset(screenSize.width / 2, screenSize.height / 2 - 50);
    _physicsState = BalloonPhysicsState(
      position: position,
      velocity: Offset.zero,
      swayPhase: 0.0,
      swayPeriod: 5.0,
      stringState: _stringPhysics.createInitialState(
        balloonPosition: position,
        balloonRadius: _balloon.currentRadius,
      ),
    );
  }

  /// アニメーション開始
  void _startAnimation() {
    _ticker = createTicker(_onTick);
    _ticker!.start();
  }

  /// フレーム更新
  void _onTick(Duration elapsed) {
    if (!mounted) return;

    if (_startTime == Duration.zero) {
      _startTime = elapsed;
      _lastFrameTime = elapsed;
      return;
    }

    final deltaTime = (elapsed - _lastFrameTime).inMicroseconds / 1000000.0;
    _lastFrameTime = elapsed;

    // 膨らみ状態を更新
    if (!_inflationState.isPopped) {
      // 自動膨らみモード
      if (_autoInflate) {
        _inflationState = _inflationState.copyWith(
          targetBulge: _inflationState.targetBulge + _inflateSpeed * deltaTime,
        );
      }

      _inflationState = _inflationEngine.updateState(
        state: _inflationState,
        deltaTime: deltaTime,
      );

      // 破裂した瞬間
      if (_inflationState.isPopped) {
        _confettiSystem.createConfetti(
          x: _physicsState.position.dx,
          y: _physicsState.position.dy,
          baseColor: _balloon.color,
        );
      }
    }

    // 紙吹雪を更新
    final screenSize = MediaQuery.of(context).size;
    _confettiSystem.update(screenSize.height);

    setState(() {});
  }

  /// 風船をリセット
  void _resetBalloon() {
    _inflationState = _inflationEngine.createInitialState();
    _confettiSystem.clear();
    setState(() {});
  }

  /// 手動で膨らませる
  void _manualInflate() {
    if (!_inflationState.isPopped) {
      _inflationState = _inflationEngine.inflate(_inflationState);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // 背景
          CustomPaint(
            size: screenSize,
            painter: BalloonBackgroundPainter(isDarkMode: isDarkMode),
          ),

          // グリッド
          CustomPaint(
            size: screenSize,
            painter: BalloonGridPainter(isDarkMode: isDarkMode),
          ),

          // 風船（破裂していない場合のみ）
          if (!_inflationState.isPopped)
            CustomPaint(
              size: screenSize,
              painter: _InflatingBalloonPainter(
                balloon: _balloon,
                physicsState: _physicsState,
                inflationState: _inflationState,
              ),
            ),

          // 紙吹雪
          CustomPaint(
            size: screenSize,
            painter: _ConfettiPainter(
              particles: _confettiSystem.particles,
            ),
          ),

          // UI
          _buildUI(),

          // デバッグ情報
          _buildDebugInfo(),
        ],
      ),
    );
  }

  /// UI構築
  Widget _buildUI() {
    return SafeArea(
      child: Column(
        children: [
          // 上部ヘッダー
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.go('/balloon-test'),
                ),
                const Expanded(
                  child: Text(
                    '風船膨らみテスト',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),

          const Spacer(),

          // 下部コントロール
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                // 自動膨らみトグル
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '自動膨らみ',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Switch(
                      value: _autoInflate,
                      onChanged: (value) {
                        setState(() {
                          _autoInflate = value;
                        });
                      },
                    ),
                  ],
                ),

                // 膨らみ速度スライダー
                Row(
                  children: [
                    const Text(
                      '速度',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    Expanded(
                      child: Slider(
                        value: _inflateSpeed,
                        min: 0.1,
                        max: 1.0,
                        onChanged: (value) {
                          setState(() {
                            _inflateSpeed = value;
                          });
                        },
                      ),
                    ),
                    Text(
                      '${_inflateSpeed.toStringAsFixed(1)}x',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ボタン
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _inflationState.isPopped ? null : _manualInflate,
                      icon: const Icon(Icons.touch_app),
                      label: const Text('膨らませる'),
                    ),
                    ElevatedButton.icon(
                      onPressed: _resetBalloon,
                      icon: const Icon(Icons.refresh),
                      label: const Text('リセット'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// デバッグ情報
  Widget _buildDebugInfo() {
    return Positioned(
      top: 100,
      left: 16,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '膨らみ: ${_inflationState.bulge.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            Text(
              '目標: ${_inflationState.targetBulge.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.cyan, fontSize: 14),
            ),
            Text(
              '閾値: ${BalloonInflationEngine.popThreshold}',
              style: const TextStyle(color: Colors.yellow, fontSize: 14),
            ),
            Text(
              '状態: ${_inflationState.isPopped ? "破裂!" : "膨らみ中"}',
              style: TextStyle(
                color: _inflationState.isPopped ? Colors.red : Colors.green,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '紙吹雪: ${_confettiSystem.particles.length}',
              style: const TextStyle(color: Colors.pink, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

/// 膨らむ風船のペインター
class _InflatingBalloonPainter extends CustomPainter {
  final Balloon balloon;
  final BalloonPhysicsState physicsState;
  final BalloonInflationState inflationState;

  final BalloonBodyRenderer _bodyRenderer = const BalloonBodyRenderer();

  _InflatingBalloonPainter({
    required this.balloon,
    required this.physicsState,
    required this.inflationState,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _bodyRenderer.render(
      canvas: canvas,
      position: physicsState.position,
      radius: balloon.currentRadius,
      color: balloon.color,
      bulge: inflationState.bulge,
    );
  }

  @override
  bool shouldRepaint(covariant _InflatingBalloonPainter oldDelegate) {
    return oldDelegate.inflationState.bulge != inflationState.bulge ||
        oldDelegate.inflationState.isPopped != inflationState.isPopped;
  }
}

/// 紙吹雪ペインター
class _ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final ConfettiRenderer _renderer = const ConfettiRenderer();

  _ConfettiPainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    _renderer.render(canvas: canvas, particles: particles);
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) {
    return true; // 常に再描画（パーティクルは毎フレーム変化）
  }
}
