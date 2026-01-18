/// Core Widget: SwipeableCard
///
/// スワイプ可能なカードコンポーネント
/// 左右スワイプでアクションボタンを表示する汎用ウィジェット
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'swipe_action_button.dart';

/// スワイプアクションの設定
///
/// スワイプ時に表示されるアクションの情報を定義
class SwipeAction {
  /// アイコン
  final IconData icon;

  /// ラベル
  final String label;

  /// 背景色
  final Color backgroundColor;

  /// アイコン・テキストの色
  final Color foregroundColor;

  /// タップ時のコールバック
  final VoidCallback? onTap;

  const SwipeAction({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    this.foregroundColor = Colors.white,
    this.onTap,
  });
}

/// スワイプ可能なカード
///
/// 任意の子ウィジェットをスワイプ可能にする汎用コンポーネント
/// - 右スワイプ: 左側にアクションを表示
/// - 左スワイプ: 右側にアクションを表示
class SwipeableCard extends StatefulWidget {
  /// カードの子ウィジェット
  final Widget child;

  /// 右スワイプ時のアクション（左側に表示）
  final SwipeAction? leftAction;

  /// 左スワイプ時のアクション（右側に表示）
  final List<SwipeAction> rightActions;

  /// カードのボーダー半径
  final double borderRadius;

  /// 右スナップ位置（正の値）
  final double rightSnapPosition;

  /// 左スナップ位置（負の値）
  final double leftSnapPosition;

  /// スワイプ開始のしきい値
  final double swipeStartThreshold;

  /// アニメーション時間
  final Duration animationDuration;

  /// ハプティックフィードバックを有効にするか
  final bool enableHapticFeedback;

  /// スワイプが閉じられた時のコールバック
  final VoidCallback? onSwipeClosed;

  const SwipeableCard({
    super.key,
    required this.child,
    this.leftAction,
    this.rightActions = const [],
    this.borderRadius = 14,
    this.rightSnapPosition = 100,
    this.leftSnapPosition = -140,
    this.swipeStartThreshold = 40,
    this.animationDuration = const Duration(milliseconds: 200),
    this.enableHapticFeedback = true,
    this.onSwipeClosed,
  });

  @override
  State<SwipeableCard> createState() => _SwipeableCardState();
}

class _SwipeableCardState extends State<SwipeableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _dragExtent = 0;
  bool _isSnapped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragExtent += details.delta.dx;
      if (_isSnapped && details.delta.dx.abs() > 0) {
        _isSnapped = false;
      }
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond.dx;

    // 右スワイプ
    if (_dragExtent > widget.swipeStartThreshold || velocity > 500) {
      if (widget.leftAction != null) {
        if (widget.enableHapticFeedback) {
          HapticFeedback.lightImpact();
        }
        _animateToSnapRight();
      } else {
        _animateBack();
      }
    }
    // 左スワイプ
    else if (_dragExtent < -widget.swipeStartThreshold || velocity < -500) {
      if (widget.rightActions.isNotEmpty) {
        if (widget.enableHapticFeedback) {
          HapticFeedback.lightImpact();
        }
        _animateToSnapLeft();
      } else {
        _animateBack();
      }
    }
    // それ以外
    else {
      _animateBack();
    }
  }

  void _animateBack() {
    final startValue = _dragExtent;
    _controller.reset();
    _isSnapped = false;

    void listener() {
      setState(() {
        _dragExtent = startValue * (1 - _controller.value);
      });
    }

    _controller.addListener(listener);
    _controller.forward().then((_) {
      _controller.removeListener(listener);
      widget.onSwipeClosed?.call();
    });
  }

  void _animateToSnapLeft() {
    final startValue = _dragExtent;
    _controller.reset();

    void listener() {
      setState(() {
        _dragExtent = startValue +
            (widget.leftSnapPosition - startValue) * _controller.value;
      });
    }

    _controller.addListener(listener);
    _controller.forward().then((_) {
      _controller.removeListener(listener);
      _isSnapped = true;
    });
  }

  void _animateToSnapRight() {
    final startValue = _dragExtent;
    _controller.reset();

    void listener() {
      setState(() {
        _dragExtent = startValue +
            (widget.rightSnapPosition - startValue) * _controller.value;
      });
    }

    _controller.addListener(listener);
    _controller.forward().then((_) {
      _controller.removeListener(listener);
      _isSnapped = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 右スワイプ時（左アクション表示）
        if (_dragExtent > 0 && widget.leftAction != null)
          ..._buildLeftActionLayers(),
        // 左スワイプ時（右アクション表示）
        if (_dragExtent < 0 && widget.rightActions.isNotEmpty)
          ..._buildRightActionLayers(),
        // 前面のカード
        _buildCard(),
      ],
    );
  }

  /// 左側アクションレイヤーを構築（右スワイプ時）
  List<Widget> _buildLeftActionLayers() {
    final action = widget.leftAction!;
    return [
      // 下地レイヤー
      Positioned.fill(
        child: Container(
          decoration: BoxDecoration(
            color: action.backgroundColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        ),
      ),
      // ボタンレイヤー
      Positioned(
        top: 0,
        bottom: 0,
        left: 0,
        width: _dragExtent,
        child: GestureDetector(
          onTap: () {
            action.onTap?.call();
            _animateBack();
          },
          child: Container(
            decoration: BoxDecoration(
              color: action.backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(widget.borderRadius),
                bottomLeft: Radius.circular(widget.borderRadius),
              ),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  action.icon,
                  color: action.foregroundColor,
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  action.label,
                  style: TextStyle(
                    color: action.foregroundColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
              ],
            ),
          ),
        ),
      ),
    ];
  }

  /// 右側アクションレイヤーを構築（左スワイプ時）
  List<Widget> _buildRightActionLayers() {
    // 一番左のアクションの色を下地に使用
    final baseColor = widget.rightActions.first.backgroundColor;

    return [
      // 下地レイヤー
      Positioned.fill(
        child: Container(
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        ),
      ),
      // ボタンレイヤー
      Positioned(
        top: 0,
        bottom: 0,
        right: 0,
        width: -_dragExtent,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(widget.borderRadius),
            bottomRight: Radius.circular(widget.borderRadius),
          ),
          child: Row(
            children: widget.rightActions
                .map((action) => Expanded(
                      child: SwipeActionButton(
                        icon: action.icon,
                        label: action.label,
                        backgroundColor: action.backgroundColor,
                        foregroundColor: action.foregroundColor,
                        onTap: () {
                          action.onTap?.call();
                          _animateBack();
                        },
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    ];
  }

  /// カードを構築
  Widget _buildCard() {
    return GestureDetector(
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      onTap: () {
        if (_isSnapped) {
          _animateBack();
        }
      },
      child: Transform.translate(
        offset: Offset(_dragExtent, 0),
        child: widget.child,
      ),
    );
  }
}
