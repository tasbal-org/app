/// Widget: AppShell
///
/// アプリケーションのメインシェルウィジェット
/// 3タブ構成（タスク / 風船 / 設定）とLiquid Glassボトムナビゲーション
library;

import 'package:flutter/material.dart';
import 'package:tasbal/src/core/widgets/balloon/balloon_background.dart';
import 'package:tasbal/src/core/widgets/header/header.dart';
import 'package:tasbal/src/core/widgets/navigation/navigation.dart';
import 'package:tasbal/src/features/task/presentation/screens/task_screen.dart';

/// アプリシェル
///
/// 設計書に基づく3タブ構成:
/// - タスク: タスク一覧画面
/// - 風船: 風船管理画面
/// - 設定: 設定画面
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  /// 現在選択されているタブのインデックス
  int _currentIndex = 0;

  /// ダークモードの状態（デモ用）
  bool _isDarkMode = false;

  /// ナビゲーションアイテム（設計書に基づく3タブ構成）
  final List<LiquidGlassNavItem> _navItems = const [
    LiquidGlassNavItem(
      icon: Icons.check_box_outlined,
      activeIcon: Icons.check_box,
      label: 'タスク',
    ),
    LiquidGlassNavItem(
      icon: Icons.bubble_chart_outlined,
      activeIcon: Icons.bubble_chart,
      label: '風船',
    ),
    LiquidGlassNavItem(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      label: '設定',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: BalloonBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: LiquidGlassHeader(
            title: _navItems[_currentIndex].label,
            isDarkMode: _isDarkMode,
            actions: [
              // ダークモードトグル（デモ用）
              IconButton(
                icon: Icon(
                  _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  color: _isDarkMode ? Colors.white : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _isDarkMode = !_isDarkMode;
                  });
                },
              ),
              // プロフィールアイコン
              CircleAvatar(
                radius: 18,
                backgroundColor: _isDarkMode
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.grey.shade300,
                child: Icon(
                  Icons.person,
                  size: 20,
                  color: _isDarkMode ? Colors.white70 : Colors.grey.shade600,
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              // メインコンテンツエリア（タブごとの画面）
              Padding(
                padding: const EdgeInsets.only(bottom: 100), // ボトムナビの高さ分
                child: _buildTabContent(),
              ),
              // ボトムナビゲーションバー
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: LiquidGlassBottomNavBar(
                  items: _navItems,
                  currentIndex: _currentIndex,
                  isDarkMode: _isDarkMode,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  // 独立した+ボタン
                  actionButton: Icon(
                    Icons.add,
                    size: 28,
                    color: _isDarkMode ? Colors.white : const Color(0xFF007AFF),
                  ),
                  onActionTap: () {
                    // TODO: 新規タスク作成画面を開く
                    debugPrint('+ ボタンがタップされました');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// タブごとのコンテンツを構築
  Widget _buildTabContent() {
    switch (_currentIndex) {
      case 0:
        // タスク画面（グラス強化モード適用）
        return TaskScreenContent(
          isDarkMode: _isDarkMode,
          enhancedGlass: true, // モード5: グラス強化を常に適用
        );
      case 1:
        // 風船画面（プレースホルダー）
        return Center(
          child: Text(
            '風船画面',
            style: TextStyle(
              color: _isDarkMode ? Colors.white70 : Colors.grey,
              fontSize: 16,
            ),
          ),
        );
      case 2:
        // 設定画面（プレースホルダー）
        return Center(
          child: Text(
            '設定画面',
            style: TextStyle(
              color: _isDarkMode ? Colors.white70 : Colors.grey,
              fontSize: 16,
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
