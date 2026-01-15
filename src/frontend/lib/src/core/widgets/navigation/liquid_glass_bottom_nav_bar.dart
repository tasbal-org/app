/// Widget: LiquidGlassBottomNavBar
///
/// Liquid Glass効果を使用したボトムナビゲーションバー
/// ナビゲーションバー全体とボタンにLiquid Glass効果を適用
/// 選択ボタン変更時にアニメーションで移動
/// ドラッグでグラスを移動して選択を変更可能
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

import 'liquid_glass_action_button.dart';
import 'liquid_glass_nav_bar_item.dart';
import 'liquid_glass_nav_item.dart';

/// Liquid Glass効果のボトムナビゲーションバー
///
/// ナビゲーションバー全体とボタンにLiquid Glass効果を適用
class LiquidGlassBottomNavBar extends StatefulWidget {
  /// ナビゲーションアイテムのリスト
  final List<LiquidGlassNavItem> items;

  /// 現在選択されているインデックス
  final int currentIndex;

  /// アイテムタップ時のコールバック
  final ValueChanged<int> onTap;

  /// ダークモードかどうか
  final bool isDarkMode;

  /// 右側のアクションボタン（オプション）
  final Widget? actionButton;

  /// アクションボタンタップ時のコールバック
  final VoidCallback? onActionTap;

  const LiquidGlassBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.isDarkMode = false,
    this.actionButton,
    this.onActionTap,
  });

  @override
  State<LiquidGlassBottomNavBar> createState() =>
      _LiquidGlassBottomNavBarState();
}

class _LiquidGlassBottomNavBarState extends State<LiquidGlassBottomNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _positionAnimation;

  /// バーの左右パディング
  static const double _horizontalPadding = 8.0;

  /// インジケーターの上下パディング
  static const double _verticalPadding = 6.0;

  /// ドラッグ中かどうか
  bool _isDragging = false;

  /// ドラッグ中のインデックス位置（小数点を含む）
  double _dragIndex = 0.0;

  /// 前回のドラッグ位置
  double _lastDragX = 0.0;

  /// バーの幅（LayoutBuilderから取得）
  double _totalWidth = 0.0;

  @override
  void initState() {
    super.initState();
    _dragIndex = widget.currentIndex.toDouble();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _positionAnimation = AlwaysStoppedAnimation(widget.currentIndex.toDouble());
  }

  @override
  void didUpdateWidget(LiquidGlassBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex && !_isDragging) {
      // ドラッグ中でない場合のみアニメーション
      _positionAnimation = Tween<double>(
        begin: _positionAnimation.value,
        end: widget.currentIndex.toDouble(),
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ));
      _animationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// 選択インジケーターのX位置を計算
  double _calculateIndicatorPosition(double animatedIndex, double totalWidth) {
    final itemCount = widget.items.length;
    final availableWidth = totalWidth - (_horizontalPadding * 2);
    final itemWidth = availableWidth / itemCount;
    return _horizontalPadding + (itemWidth * animatedIndex);
  }

  /// インジケーターの幅を計算
  double _calculateIndicatorWidth(double totalWidth) {
    final itemCount = widget.items.length;
    final availableWidth = totalWidth - (_horizontalPadding * 2);
    return availableWidth / itemCount;
  }

  /// ドラッグ開始
  void _onDragStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
      _lastDragX = details.localPosition.dx;
      _dragIndex = _positionAnimation.value;
    });
  }

  /// ドラッグ更新
  void _onDragUpdate(DragUpdateDetails details) {
    if (!_isDragging) return;

    final itemCount = widget.items.length;
    final availableWidth = _totalWidth - (_horizontalPadding * 2);
    final itemWidth = availableWidth / itemCount;

    // ドラッグ量をインデックスの変化に変換
    final deltaX = details.localPosition.dx - _lastDragX;
    final deltaIndex = deltaX / itemWidth;

    setState(() {
      _lastDragX = details.localPosition.dx;
      _dragIndex = (_dragIndex + deltaIndex).clamp(0.0, itemCount - 1.0);
      _positionAnimation = AlwaysStoppedAnimation(_dragIndex);
    });
  }

  /// ドラッグ終了
  void _onDragEnd(DragEndDetails details) {
    if (!_isDragging) return;

    // 最も近いインデックスにスナップ
    final targetIndex = _dragIndex.round().clamp(0, widget.items.length - 1);

    setState(() {
      _isDragging = false;
    });

    // 触感フィードバック
    HapticFeedback.selectionClick();

    // スナップアニメーション
    _positionAnimation = Tween<double>(
      begin: _dragIndex,
      end: targetIndex.toDouble(),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward(from: 0);

    // 選択を更新
    if (targetIndex != widget.currentIndex) {
      widget.onTap(targetIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    // アクションボタンがある場合は右側にスペースを確保
    final hasActionButton = widget.actionButton != null;
    const actionButtonSpacing = 8.0;

    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 34, // Safe area bottom
      ),
      child: Row(
        children: [
          // メインのナビゲーションバー
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                _totalWidth = constraints.maxWidth;

                return GestureDetector(
                  // ドラッグでグラスを移動
                  onHorizontalDragStart: _onDragStart,
                  onHorizontalDragUpdate: _onDragUpdate,
                  onHorizontalDragEnd: _onDragEnd,
                  child: LiquidGlassLayer(
                    settings: LiquidGlassSettings(
                      thickness: widget.isDarkMode ? 8 : 12,
                      glassColor: widget.isDarkMode
                          ? const Color(0x25FFFFFF)
                          : const Color(0x40FFFFFF),
                      lightIntensity: widget.isDarkMode ? 0.6 : 1.0,
                      saturation: 1.1,
                      blur: widget.isDarkMode ? 12.0 : 16.0,
                    ),
                    child: LiquidGlassBlendGroup(
                      blend: 15.0,
                      child: SizedBox(
                        height: 64,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // ベースのナビゲーションバー
                            Positioned.fill(
                              child: LiquidGlass.grouped(
                                shape:
                                    LiquidRoundedSuperellipse(borderRadius: 32),
                                child: const SizedBox.expand(),
                              ),
                            ),

                            // アニメーションする選択インジケーター
                            AnimatedBuilder(
                              animation: _positionAnimation,
                              builder: (context, child) {
                                final xPosition = _calculateIndicatorPosition(
                                  _positionAnimation.value,
                                  _totalWidth,
                                );
                                final indicatorWidth =
                                    _calculateIndicatorWidth(_totalWidth);
                                final indicatorHeight =
                                    64.0 - (_verticalPadding * 2);

                                return Positioned(
                                  left: xPosition,
                                  top: _verticalPadding,
                                  bottom: _verticalPadding,
                                  width: indicatorWidth,
                                  child: LiquidGlass.withOwnLayer(
                                    settings: const LiquidGlassSettings(
                                      thickness: 15,
                                      blur: 8,
                                    ),
                                    // border-radiusを高さの半分にして完全な丸みに
                                    shape: LiquidRoundedSuperellipse(
                                        borderRadius: indicatorHeight / 2),
                                    child: GlassGlow(
                                      glowColor: widget.isDarkMode
                                          ? Colors.white.withValues(alpha: 0.15)
                                          : const Color(0xFF007AFF)
                                              .withValues(alpha: 0.2),
                                      glowRadius: 0.6,
                                      child: const SizedBox.expand(),
                                    ),
                                  ),
                                );
                              },
                            ),

                            // ナビゲーションアイテム（タップ領域）
                            Positioned.fill(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: _horizontalPadding,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: List.generate(widget.items.length,
                                      (index) {
                                    final item = widget.items[index];
                                    // ドラッグ中は近いインデックスをハイライト
                                    final isSelected = _isDragging
                                        ? _dragIndex.round() == index
                                        : widget.currentIndex == index;

                                    return LiquidGlassNavBarItem(
                                      item: item,
                                      isSelected: isSelected,
                                      isDarkMode: widget.isDarkMode,
                                      onTap: () => widget.onTap(index),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 右側のアクションボタン（独立したLiquid Glass）
          if (hasActionButton) ...[
            const SizedBox(width: actionButtonSpacing),
            LiquidGlassActionButton(
              isDarkMode: widget.isDarkMode,
              onTap: widget.onActionTap,
              child: widget.actionButton!,
            ),
          ],
        ],
      ),
    );
  }
}
