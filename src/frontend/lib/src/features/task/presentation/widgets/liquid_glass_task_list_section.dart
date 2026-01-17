/// Widget: LiquidGlassTaskListSection
///
/// Liquid Glass効果を使用したタスクリストセクション
/// セクションヘッダーとタスクリストをグループ化
/// アコーディオン機能で折りたたみ可能
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

/// Liquid Glass効果のタスクリストセクション
///
/// セクションヘッダーとその中のタスクアイテムをまとめて表示
/// タップで折りたたみ/展開が可能
class LiquidGlassTaskListSection extends StatefulWidget {
  /// セクションタイトル
  final String title;

  /// タスク数
  final int count;

  /// ダークモードかどうか
  final bool isDarkMode;

  /// アイコン（オプション）
  final IconData? icon;

  /// 子ウィジェット（タスクアイテムのリスト）
  final List<Widget> children;

  /// 初期展開状態
  final bool initiallyExpanded;

  /// グラス効果を強化するか（視認性モード5）
  final bool enhancedGlass;

  const LiquidGlassTaskListSection({
    super.key,
    required this.title,
    this.count = 0,
    this.isDarkMode = false,
    this.icon,
    required this.children,
    this.initiallyExpanded = true,
    this.enhancedGlass = false,
  });

  @override
  State<LiquidGlassTaskListSection> createState() =>
      _LiquidGlassTaskListSectionState();
}

class _LiquidGlassTaskListSectionState
    extends State<LiquidGlassTaskListSection>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _iconTurns = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _heightFactor = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    HapticFeedback.selectionClick();
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  /// グラス設定を取得
  LiquidGlassSettings _getGlassSettings() {
    if (widget.enhancedGlass) {
      // 視認性モード5: グラス効果を強化
      return LiquidGlassSettings(
        thickness: widget.isDarkMode ? 12 : 18,
        glassColor: widget.isDarkMode
            ? const Color(0x60000000) // より暗い背景
            : const Color(0x80FFFFFF), // より明るい背景
        lightIntensity: widget.isDarkMode ? 0.3 : 0.6,
        saturation: 0.8,
        blur: widget.isDarkMode ? 30.0 : 35.0, // 強いブラー
      );
    }
    // 通常モード
    return LiquidGlassSettings(
      thickness: widget.isDarkMode ? 6 : 10,
      glassColor: widget.isDarkMode
          ? const Color(0x20FFFFFF)
          : const Color(0x40FFFFFF),
      lightIntensity: widget.isDarkMode ? 0.5 : 0.9,
      saturation: 1.0,
      blur: widget.isDarkMode ? 12.0 : 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: LiquidGlass.withOwnLayer(
        settings: _getGlassSettings(),
        shape: LiquidRoundedSuperellipse(borderRadius: 24),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // セクションヘッダー（タップで開閉）
              GestureDetector(
                onTap: _toggleExpansion,
                behavior: HitTestBehavior.opaque,
                child: _buildHeader(),
              ),
              // アニメーション付きコンテンツ
              ClipRect(
                child: AnimatedBuilder(
                  animation: _heightFactor,
                  builder: (context, child) {
                    return Align(
                      alignment: Alignment.topCenter,
                      heightFactor: _heightFactor.value,
                      child: child,
                    );
                  },
                  child: widget.children.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widget.children,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// セクションヘッダー
  Widget _buildHeader() {
    return Row(
      children: [
        if (widget.icon != null) ...[
          Icon(
            widget.icon,
            size: 16,
            color: widget.isDarkMode
                ? Colors.white.withValues(alpha: 0.8)
                : Colors.black.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 6),
        ],
        Text(
          widget.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: widget.isDarkMode
                ? Colors.white.withValues(alpha: 0.9)
                : Colors.black.withValues(alpha: 0.8),
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: widget.isDarkMode
                ? Colors.white.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.08),
          ),
          child: Text(
            '${widget.count}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: widget.isDarkMode
                  ? Colors.white.withValues(alpha: 0.8)
                  : Colors.black.withValues(alpha: 0.6),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // 開閉アイコン
        RotationTransition(
          turns: _iconTurns,
          child: Icon(
            Icons.keyboard_arrow_down,
            size: 24,
            color: widget.isDarkMode
                ? Colors.white.withValues(alpha: 0.6)
                : Colors.black.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}
