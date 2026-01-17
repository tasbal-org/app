/// Task: TaskScreen
///
/// タスク一覧画面
/// タスク一覧の表示と操作を担当
/// Liquid Glass UIで実装
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:tasbal/src/core/di/injection.dart';
import 'package:tasbal/src/core/widgets/balloon/balloon_background.dart';
import 'package:tasbal/src/features/task/data/demo/demo_tasks.dart';
import 'package:tasbal/src/features/task/presentation/widgets/task.dart';
import 'package:tasbal/src/features/task/domain/use_cases/get_tasks_use_case.dart';
import 'package:tasbal/src/features/task/domain/use_cases/toggle_task_completion_use_case.dart';
import 'package:tasbal/src/features/task/presentation/redux/task_actions.dart';
import 'package:tasbal/src/features/task/presentation/redux/task_thunks.dart';
import 'package:tasbal/src/redux/app_state.dart';

/// タスク一覧画面
///
/// 設計書の仕様に基づくタスク一覧画面
/// - ヘッダー（今日の日付、状態チップ）
/// - 表示トグル（非表示、アーカイブ）
/// - タスク一覧（ピン留め優先）
/// - FAB（タスク追加）
class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  void initState() {
    super.initState();
    // 初回ロード時にタスク一覧を取得
    _fetchTasks();
  }

  /// タスク一覧を取得
  void _fetchTasks() {
    final store = StoreProvider.of<AppState>(context, listen: false);
    final useCase = sl<GetTasksUseCase>();

    store.dispatch(fetchTasksThunk(
      useCase: useCase,
      includeHidden: store.state.taskState.showHidden,
      includeExpired: store.state.taskState.showExpired,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BalloonBackground(
      debugMode: true, // デバッグモードON（風船の動きを確認）
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: _buildHeader(),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          children: [
            _buildToggleSection(),
            Expanded(
              child: StoreConnector<AppState, AppState>(
                converter: (store) => store.state,
                builder: (context, state) {
                  if (state.taskState.isLoading && state.taskState.tasks.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.taskState.tasks.isEmpty) {
                    return _buildEmptyState();
                  }

                  return _buildTaskList(state);
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showCreateTaskDialog,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  /// ヘッダー（今日の日付）
  Widget _buildHeader() {
    final now = DateTime.now();
    final dateStr = '${now.month}月${now.day}日';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dateStr,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        // TODO: 状態チップ（選択中の風船等）
      ],
    );
  }

  /// 表示トグルセクション
  Widget _buildToggleSection() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              LiquidGlassFilterChip(
                label: '非表示',
                isSelected: state.taskState.showHidden,
                isDarkMode: isDarkMode,
                icon: Icons.visibility_off_outlined,
                onSelected: (selected) {
                  StoreProvider.of<AppState>(context, listen: false)
                      .dispatch(ToggleShowHiddenAction(selected));
                  _fetchTasks();
                },
              ),
              const SizedBox(width: 10),
              LiquidGlassFilterChip(
                label: 'アーカイブ',
                isSelected: state.taskState.showExpired,
                isDarkMode: isDarkMode,
                icon: Icons.archive_outlined,
                onSelected: (selected) {
                  StoreProvider.of<AppState>(context, listen: false)
                      .dispatch(ToggleShowExpiredAction(selected));
                  _fetchTasks();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// タスク一覧
  Widget _buildTaskList(AppState state) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final pinnedTasks = state.taskState.pinnedTasks;
    final unpinnedTasks = state.taskState.unpinnedTasks;
    final completedTasks = state.taskState.completedTasks;

    return RefreshIndicator(
      onRefresh: () async {
        _fetchTasks();
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ピン留めタスク
          if (pinnedTasks.isNotEmpty)
            LiquidGlassTaskListSection(
              title: 'ピン留め',
              count: pinnedTasks.length,
              isDarkMode: isDarkMode,
              icon: Icons.push_pin,
              children: pinnedTasks
                  .map((task) => _buildTaskItem(task, isPinned: true))
                  .toList(),
            ),

          // 通常タスク
          if (unpinnedTasks.isNotEmpty)
            LiquidGlassTaskListSection(
              title: 'タスク',
              count: unpinnedTasks.length,
              isDarkMode: isDarkMode,
              icon: Icons.task_alt,
              children: unpinnedTasks
                  .map((task) => _buildTaskItem(task))
                  .toList(),
            ),

          // 完了タスク
          if (completedTasks.isNotEmpty)
            LiquidGlassTaskListSection(
              title: '完了',
              count: completedTasks.length,
              isDarkMode: isDarkMode,
              icon: Icons.check_circle_outline,
              children: completedTasks
                  .map((task) => _buildTaskItem(task))
                  .toList(),
            ),
        ],
      ),
    );
  }

  /// タスクアイテム
  Widget _buildTaskItem(dynamic task, {bool isPinned = false}) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return LiquidGlassTaskCard(
      id: task.id,
      title: task.title,
      memo: task.memo,
      isCompleted: task.isCompleted,
      isPinned: isPinned,
      isDarkMode: isDarkMode,
      onCompletionChanged: (completed) => _toggleTaskCompletion(task.id, completed),
      onTap: () {
        // タスク詳細画面へ遷移（将来実装）
        debugPrint('Task tapped: ${task.title}');
      },
    );
  }

  /// 空の状態
  Widget _buildEmptyState() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: LiquidGlass.withOwnLayer(
          settings: LiquidGlassSettings(
            thickness: isDarkMode ? 6 : 10,
            glassColor: isDarkMode
                ? const Color(0x18FFFFFF)
                : const Color(0x30FFFFFF),
            lightIntensity: isDarkMode ? 0.4 : 0.8,
            saturation: 1.0,
            blur: isDarkMode ? 10.0 : 14.0,
          ),
          shape: LiquidRoundedSuperellipse(borderRadius: 28),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.task_alt,
                  size: 64,
                  color: isDarkMode
                      ? Colors.white.withValues(alpha: 0.5)
                      : Colors.black.withValues(alpha: 0.4),
                ),
                const SizedBox(height: 16),
                Text(
                  'タスクがありません',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode
                        ? Colors.white.withValues(alpha: 0.7)
                        : Colors.black.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '＋ボタンでタスクを追加できます',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode
                        ? Colors.white.withValues(alpha: 0.5)
                        : Colors.black.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// タスク完了切替
  void _toggleTaskCompletion(String id, bool completed) {
    final store = StoreProvider.of<AppState>(context, listen: false);
    final useCase = sl<ToggleTaskCompletionUseCase>();

    store.dispatch(toggleTaskCompletionThunk(
      useCase: useCase,
      id: id,
      completed: completed,
    ));
  }

  /// タスク作成ダイアログを表示
  void _showCreateTaskDialog() {
    // TODO: タスク作成ダイアログの実装
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('タスク作成ダイアログは未実装です')),
    );
  }
}

/// タスク画面のコンテンツ部分（AppShell内で使用）
///
/// ヘッダーやボトムナビなしのコンテンツのみ
class TaskScreenContent extends StatefulWidget {
  /// ダークモード
  final bool isDarkMode;

  /// グラス効果を強化するか
  final bool enhancedGlass;

  const TaskScreenContent({
    super.key,
    this.isDarkMode = false,
    this.enhancedGlass = true,
  });

  @override
  State<TaskScreenContent> createState() => _TaskScreenContentState();
}

class _TaskScreenContentState extends State<TaskScreenContent> {
  @override
  void initState() {
    super.initState();
    // 初回ロード時にタスク一覧を取得
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchTasks();
    });
  }

  /// タスク一覧を取得
  void _fetchTasks() {
    final store = StoreProvider.of<AppState>(context, listen: false);

    // デバッグモードではデモデータを使用
    if (kDebugMode) {
      store.dispatch(LoadDemoTasksAction(DemoTasks.visible));
      return;
    }

    final useCase = sl<GetTasksUseCase>();
    store.dispatch(fetchTasksThunk(
      useCase: useCase,
      includeHidden: store.state.taskState.showHidden,
      includeExpired: store.state.taskState.showExpired,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildToggleSection(),
        Expanded(
          child: StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder: (context, state) {
              if (state.taskState.isLoading && state.taskState.tasks.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.taskState.tasks.isEmpty) {
                return _buildEmptyState();
              }

              return _buildTaskList(state);
            },
          ),
        ),
      ],
    );
  }

  /// 表示トグルセクション
  Widget _buildToggleSection() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              LiquidGlassFilterChip(
                label: '非表示',
                isSelected: state.taskState.showHidden,
                isDarkMode: isDarkMode,
                icon: Icons.visibility_off_outlined,
                onSelected: (selected) {
                  StoreProvider.of<AppState>(context, listen: false)
                      .dispatch(ToggleShowHiddenAction(selected));
                  _fetchTasks();
                },
              ),
              const SizedBox(width: 10),
              LiquidGlassFilterChip(
                label: 'アーカイブ',
                isSelected: state.taskState.showExpired,
                isDarkMode: isDarkMode,
                icon: Icons.archive_outlined,
                onSelected: (selected) {
                  StoreProvider.of<AppState>(context, listen: false)
                      .dispatch(ToggleShowExpiredAction(selected));
                  _fetchTasks();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// タスク一覧
  Widget _buildTaskList(AppState state) {
    final isDarkMode = widget.isDarkMode;
    final enhancedGlass = widget.enhancedGlass;
    final pinnedTasks = state.taskState.pinnedTasks;
    final unpinnedTasks = state.taskState.unpinnedTasks;
    final completedTasks = state.taskState.completedTasks;

    return RefreshIndicator(
      onRefresh: () async {
        _fetchTasks();
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ピン留めタスク
          if (pinnedTasks.isNotEmpty)
            LiquidGlassTaskListSection(
              title: 'ピン留め',
              count: pinnedTasks.length,
              isDarkMode: isDarkMode,
              icon: Icons.push_pin,
              enhancedGlass: enhancedGlass,
              children: pinnedTasks
                  .map((task) => _buildTaskItem(task, isPinned: true))
                  .toList(),
            ),

          // 通常タスク
          if (unpinnedTasks.isNotEmpty)
            LiquidGlassTaskListSection(
              title: 'タスク',
              count: unpinnedTasks.length,
              isDarkMode: isDarkMode,
              icon: Icons.task_alt,
              enhancedGlass: enhancedGlass,
              children: unpinnedTasks
                  .map((task) => _buildTaskItem(task))
                  .toList(),
            ),

          // 完了タスク
          if (completedTasks.isNotEmpty)
            LiquidGlassTaskListSection(
              title: '完了',
              count: completedTasks.length,
              isDarkMode: isDarkMode,
              icon: Icons.check_circle_outline,
              enhancedGlass: enhancedGlass,
              children: completedTasks
                  .map((task) => _buildTaskItem(task))
                  .toList(),
            ),
        ],
      ),
    );
  }

  /// タスクアイテム
  Widget _buildTaskItem(dynamic task, {bool isPinned = false}) {
    final isDarkMode = widget.isDarkMode;

    return LiquidGlassTaskCard(
      id: task.id,
      title: task.title,
      memo: task.memo,
      isCompleted: task.isCompleted,
      isPinned: isPinned,
      isDarkMode: isDarkMode,
      onCompletionChanged: (completed) => _toggleTaskCompletion(task.id, completed),
      onTap: () {
        // タスク詳細画面へ遷移（将来実装）
        debugPrint('Task tapped: ${task.title}');
      },
    );
  }

  /// 空の状態
  Widget _buildEmptyState() {
    final isDarkMode = widget.isDarkMode;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: LiquidGlass.withOwnLayer(
          settings: LiquidGlassSettings(
            thickness: isDarkMode ? 6 : 10,
            glassColor: isDarkMode
                ? const Color(0x18FFFFFF)
                : const Color(0x30FFFFFF),
            lightIntensity: isDarkMode ? 0.4 : 0.8,
            saturation: 1.0,
            blur: isDarkMode ? 10.0 : 14.0,
          ),
          shape: LiquidRoundedSuperellipse(borderRadius: 28),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.task_alt,
                  size: 64,
                  color: isDarkMode
                      ? Colors.white.withValues(alpha: 0.5)
                      : Colors.black.withValues(alpha: 0.4),
                ),
                const SizedBox(height: 16),
                Text(
                  'タスクがありません',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode
                        ? Colors.white.withValues(alpha: 0.7)
                        : Colors.black.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '＋ボタンでタスクを追加できます',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode
                        ? Colors.white.withValues(alpha: 0.5)
                        : Colors.black.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// タスク完了切替
  void _toggleTaskCompletion(String id, bool completed) {
    final store = StoreProvider.of<AppState>(context, listen: false);
    final useCase = sl<ToggleTaskCompletionUseCase>();

    store.dispatch(toggleTaskCompletionThunk(
      useCase: useCase,
      id: id,
      completed: completed,
    ));
  }
}
