/// Task: HomeScreen
///
/// ホーム画面（タスク一覧画面）
/// タスク一覧の表示と操作を担当
library;

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tasbal/src/core/di/injection.dart';
import 'package:tasbal/src/core/widgets/balloon/balloon_background.dart';
import 'package:tasbal/src/features/task/domain/use_cases/get_tasks_use_case.dart';
import 'package:tasbal/src/features/task/domain/use_cases/toggle_task_completion_use_case.dart';
import 'package:tasbal/src/features/task/presentation/redux/task_actions.dart';
import 'package:tasbal/src/features/task/presentation/redux/task_thunks.dart';
import 'package:tasbal/src/redux/app_state.dart';

/// ホーム画面（タスク画面）
///
/// 設計書の仕様に基づくタスク一覧画面
/// - ヘッダー（今日の日付、状態チップ）
/// - 表示トグル（非表示、アーカイブ）
/// - タスク一覧（ピン留め優先）
/// - FAB（タスク追加）
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              FilterChip(
                label: const Text('非表示'),
                selected: state.taskState.showHidden,
                onSelected: (selected) {
                  StoreProvider.of<AppState>(context, listen: false)
                      .dispatch(ToggleShowHiddenAction(selected));
                  _fetchTasks();
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('アーカイブ'),
                selected: state.taskState.showExpired,
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
          if (pinnedTasks.isNotEmpty) ...[
            ...pinnedTasks.map((task) => _buildTaskItem(task, isPinned: true)),
            const SizedBox(height: 8),
          ],

          // 通常タスク
          ...unpinnedTasks.map((task) => _buildTaskItem(task)),

          // 完了タスク
          if (completedTasks.isNotEmpty) ...[
            const Divider(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                '完了',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            ...completedTasks.map((task) => _buildTaskItem(task)),
          ],
        ],
      ),
    );
  }

  /// タスクアイテム
  Widget _buildTaskItem(dynamic task, {bool isPinned = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (checked) => _toggleTaskCompletion(task.id, checked ?? false),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            color: task.isCompleted ? Colors.grey : null,
          ),
        ),
        subtitle: task.memo != null ? Text(task.memo!) : null,
        trailing: isPinned
            ? const Icon(Icons.push_pin, size: 16, color: Colors.grey)
            : null,
      ),
    );
  }

  /// 空の状態
  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'タスクがありません',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            '＋ボタンでタスクを追加できます',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
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
