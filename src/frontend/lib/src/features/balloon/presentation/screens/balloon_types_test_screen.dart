/// Balloon Types Test Screen
///
/// 各種風船タイプのテスト画面
/// ロケーション風船、ブランド風船、深呼吸風船
library;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:tasbal/src/core/widgets/balloon/balloon_background_painter.dart';
import 'package:tasbal/src/core/widgets/balloon/balloon_grid_painter.dart';
import 'package:tasbal/src/core/widgets/balloon/balloon_string_physics.dart';
import 'package:tasbal/src/core/widgets/balloon/painters/brand_balloon_painter.dart';
import 'package:tasbal/src/core/widgets/balloon/painters/breath_balloon_painter.dart';
import 'package:tasbal/src/core/widgets/balloon/painters/location_balloon_painter.dart';
import 'package:tasbal/src/core/widgets/balloon/renderers/balloon_content_renderer.dart';
import 'package:tasbal/src/core/widgets/balloon/renderers/balloon_flag_renderer.dart';
import 'package:tasbal/src/enums/balloon_display_group.dart';
import 'package:tasbal/src/enums/balloon_type.dart';
import 'package:tasbal/src/features/balloon/domain/entities/balloon.dart';
import 'package:tasbal/src/features/balloon/domain/physics/balloon_physics.dart';

/// 表示する風船タイプ
enum TestBalloonType {
  location,
  brand,
  shape,
  breath,
}

/// 風船タイプテスト画面
class BalloonTypesTestScreen extends StatefulWidget {
  const BalloonTypesTestScreen({super.key});

  @override
  State<BalloonTypesTestScreen> createState() => _BalloonTypesTestScreenState();
}

class _BalloonTypesTestScreenState extends State<BalloonTypesTestScreen>
    with SingleTickerProviderStateMixin {
  /// 現在のテストタイプ
  TestBalloonType _currentType = TestBalloonType.brand;

  /// 風船エンティティ
  late Balloon _balloon;

  /// 物理状態
  late BalloonPhysicsState _physicsState;

  /// 紐物理エンジン
  final BalloonStringPhysics _stringPhysics = BalloonStringPhysics();

  /// ティッカー
  Ticker? _ticker;

  /// 前回フレーム時刻
  Duration _lastFrameTime = Duration.zero;

  /// 初期化済みフラグ
  bool _initialized = false;

  /// 選択中のフラグ
  FlagCode _selectedFlag = FlagCode.jp;

  /// 選択中のブランド
  BrandType _selectedBrand = BrandType.github;

  /// 選択中のシェイプ
  int _selectedShape = 4; // Star

  /// 深呼吸フェーズ
  BreathPhase _breathPhase = BreathPhase.rest;

  /// 深呼吸進捗
  double _breathProgress = 0.0;

  /// 深呼吸スケール
  double _breathScale = 1.0;

  /// 経過時間
  double _elapsedTime = 0.0;

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
  }

  /// 物理状態を初期化
  void _initializePhysics() {
    final screenSize = MediaQuery.of(context).size;
    final position = Offset(screenSize.width / 2, screenSize.height / 2 - 80);
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

    if (_lastFrameTime == Duration.zero) {
      _lastFrameTime = elapsed;
      return;
    }

    final deltaTime = (elapsed - _lastFrameTime).inMicroseconds / 1000000.0;
    _lastFrameTime = elapsed;
    _elapsedTime += deltaTime;

    // 深呼吸アニメーション
    if (_currentType == TestBalloonType.breath) {
      _updateBreathAnimation();
    }

    setState(() {});
  }

  /// 深呼吸アニメーションを更新
  void _updateBreathAnimation() {
    // 4秒吸う、2秒止める、4秒吐く、2秒休む = 12秒サイクル
    final cycleTime = _elapsedTime % 12.0;

    if (cycleTime < 4.0) {
      // 吸う
      _breathPhase = BreathPhase.inhale;
      _breathProgress = cycleTime / 4.0;
      _breathScale = 1.0 + 0.3 * _breathProgress;
    } else if (cycleTime < 6.0) {
      // 止める
      _breathPhase = BreathPhase.hold;
      _breathProgress = (cycleTime - 4.0) / 2.0;
      _breathScale = 1.3;
    } else if (cycleTime < 10.0) {
      // 吐く
      _breathPhase = BreathPhase.exhale;
      _breathProgress = (cycleTime - 6.0) / 4.0;
      _breathScale = 1.3 - 0.3 * _breathProgress;
    } else {
      // 休む
      _breathPhase = BreathPhase.rest;
      _breathProgress = (cycleTime - 10.0) / 2.0;
      _breathScale = 1.0;
    }
  }

  /// 風船の色を変更
  void _changeBalloonColor(Color color) {
    setState(() {
      _balloon = Balloon(
        id: _balloon.id,
        type: _balloon.type,
        displayGroup: _balloon.displayGroup,
        color: color,
        currentValue: _balloon.currentValue,
        nextThreshold: _balloon.nextThreshold,
        createdAt: _balloon.createdAt,
      );
    });
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

          // 風船
          CustomPaint(
            size: screenSize,
            painter: _buildBalloonPainter(),
          ),

          // UI
          _buildUI(),
        ],
      ),
    );
  }

  /// 風船ペインターを構築
  CustomPainter _buildBalloonPainter() {
    switch (_currentType) {
      case TestBalloonType.location:
        return LocationBalloonPainter(
          balloon: _balloon,
          physicsState: _physicsState,
          flagCode: _selectedFlag,
        );
      case TestBalloonType.brand:
        return BrandBalloonPainter(
          balloon: _balloon,
          physicsState: _physicsState,
          brandType: _selectedBrand,
        );
      case TestBalloonType.shape:
        return ShapeBalloonPainter(
          balloon: _balloon,
          physicsState: _physicsState,
          shapeType: _selectedShape,
        );
      case TestBalloonType.breath:
        return BreathBalloonPainter(
          balloon: _balloon,
          physicsState: _physicsState,
          breathPhase: _breathPhase,
          breathProgress: _breathProgress,
          breathScale: _breathScale,
          pulseIntensity: _breathPhase == BreathPhase.inhale ? _breathProgress : 0,
        );
    }
  }

  /// UI構築
  Widget _buildUI() {
    return SafeArea(
      child: Column(
        children: [
          // ヘッダー
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
                    '風船タイプテスト',
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

          // タイプ選択タブ
          _buildTypeSelector(),

          const Spacer(),

          // オプションパネル
          _buildOptionsPanel(),
        ],
      ),
    );
  }

  /// タイプ選択タブ
  Widget _buildTypeSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: TestBalloonType.values.map((type) {
          final isSelected = _currentType == type;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _currentType = type;
                  _elapsedTime = 0;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withValues(alpha: 0.2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getTypeName(type),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white60,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// タイプ名を取得
  String _getTypeName(TestBalloonType type) {
    switch (type) {
      case TestBalloonType.location:
        return 'ロケーション';
      case TestBalloonType.brand:
        return 'ブランド';
      case TestBalloonType.shape:
        return 'シェイプ';
      case TestBalloonType.breath:
        return '深呼吸';
    }
  }

  /// オプションパネル
  Widget _buildOptionsPanel() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 色選択
          const Text(
            '風船の色',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 8),
          _buildColorSelector(),

          const SizedBox(height: 16),

          // タイプ固有のオプション
          _buildTypeSpecificOptions(),
        ],
      ),
    );
  }

  /// 色選択
  Widget _buildColorSelector() {
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: colors.map((color) {
        final isSelected = _balloon.color == color;
        return GestureDetector(
          onTap: () => _changeBalloonColor(color),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: Colors.white, width: 3)
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }

  /// タイプ固有のオプション
  Widget _buildTypeSpecificOptions() {
    switch (_currentType) {
      case TestBalloonType.location:
        return _buildFlagSelector();
      case TestBalloonType.brand:
        return _buildBrandSelector();
      case TestBalloonType.shape:
        return _buildShapeSelector();
      case TestBalloonType.breath:
        return _buildBreathInfo();
    }
  }

  /// 国旗選択
  Widget _buildFlagSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '国旗',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: FlagCode.values.map((flag) {
            final isSelected = _selectedFlag == flag;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFlag = flag;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: isSelected ? Border.all(color: Colors.white) : null,
                ),
                child: Text(
                  _getFlagEmoji(flag),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// 国旗絵文字を取得
  String _getFlagEmoji(FlagCode code) {
    switch (code) {
      case FlagCode.jp: return '🇯🇵';
      case FlagCode.us: return '🇺🇸';
      case FlagCode.gb: return '🇬🇧';
      case FlagCode.fr: return '🇫🇷';
      case FlagCode.de: return '🇩🇪';
      case FlagCode.it: return '🇮🇹';
      case FlagCode.ca: return '🇨🇦';
      case FlagCode.br: return '🇧🇷';
      case FlagCode.kr: return '🇰🇷';
      case FlagCode.cn: return '🇨🇳';
      case FlagCode.au: return '🇦🇺';
      case FlagCode.es: return '🇪🇸';
      case FlagCode.mx: return '🇲🇽';
      case FlagCode.in_: return '🇮🇳';
      case FlagCode.ru: return '🇷🇺';
    }
  }

  /// ブランド選択
  Widget _buildBrandSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ブランド',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: BrandType.values.map((brand) {
            final isSelected = _selectedBrand == brand;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedBrand = brand;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: isSelected ? Border.all(color: Colors.white) : null,
                ),
                child: Text(
                  brand.name,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// シェイプ選択
  Widget _buildShapeSelector() {
    final shapes = [
      (1, '○'),
      (2, '□'),
      (3, '△'),
      (4, '★'),
      (5, '♥'),
      (6, '◇'),
      (7, '⬡'),
      (8, '+'),
      (9, '~'),
      (10, '●'),
      (11, '◎'),
      (12, '✿'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'シェイプ',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: shapes.map((shape) {
            final isSelected = _selectedShape == shape.$1;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedShape = shape.$1;
                });
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: isSelected ? Border.all(color: Colors.white) : null,
                ),
                child: Center(
                  child: Text(
                    shape.$2,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// 深呼吸情報
  Widget _buildBreathInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '深呼吸ガイド',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              _getBreathIcon(),
              color: _getBreathColor(),
              size: 32,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getBreathText(),
                  style: TextStyle(
                    color: _getBreathColor(),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '進捗: ${(_breathProgress * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: _breathProgress,
          backgroundColor: Colors.white24,
          valueColor: AlwaysStoppedAnimation<Color>(_getBreathColor()),
        ),
      ],
    );
  }

  /// 呼吸アイコンを取得
  IconData _getBreathIcon() {
    switch (_breathPhase) {
      case BreathPhase.inhale:
        return Icons.arrow_upward;
      case BreathPhase.hold:
        return Icons.pause;
      case BreathPhase.exhale:
        return Icons.arrow_downward;
      case BreathPhase.rest:
        return Icons.more_horiz;
    }
  }

  /// 呼吸色を取得
  Color _getBreathColor() {
    switch (_breathPhase) {
      case BreathPhase.inhale:
        return Colors.cyan;
      case BreathPhase.hold:
        return Colors.amber;
      case BreathPhase.exhale:
        return Colors.teal;
      case BreathPhase.rest:
        return Colors.grey;
    }
  }

  /// 呼吸テキストを取得
  String _getBreathText() {
    switch (_breathPhase) {
      case BreathPhase.inhale:
        return '吸う (4秒)';
      case BreathPhase.hold:
        return '止める (2秒)';
      case BreathPhase.exhale:
        return '吐く (4秒)';
      case BreathPhase.rest:
        return '休憩 (2秒)';
    }
  }
}
