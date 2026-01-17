/// Task Data: Demo Tasks
///
/// デモ用のタスクデータ
/// 開発・テスト時に使用するサンプルデータ
library;

import 'package:tasbal/src/enums/task_state.dart';
import 'package:tasbal/src/features/task/domain/entities/task.dart';

/// デモ用タスクデータ
///
/// 様々な状態のタスクを含むサンプルデータ
class DemoTasks {
  DemoTasks._();

  /// 全てのデモタスク
  static List<Task> get all => [
        ...pinned,
        ...active,
        ...completed,
        ...hidden,
        ...expired,
      ];

  /// 表示用タスク（通常・完了・ピン留め）
  static List<Task> get visible => [
        ...pinned,
        ...active,
        ...completed,
      ];

  /// ピン留めタスク
  static List<Task> get pinned => [
        Task(
          id: 'demo-1',
          title: '毎日の運動を続ける',
          memo: '30分のウォーキングまたはストレッチ',
          state: TaskState.Active,
          isPinned: true,
          tags: ['健康', '習慣'],
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
          updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Task(
          id: 'demo-2',
          title: '水を1日2リットル飲む',
          state: TaskState.Active,
          isPinned: true,
          tags: ['健康'],
          createdAt: DateTime.now().subtract(const Duration(days: 14)),
          updatedAt: DateTime.now(),
        ),
      ];

  /// アクティブなタスク
  static List<Task> get active => [
        Task(
          id: 'demo-3',
          title: '買い物リストを作成する',
          memo: '週末の買い出し用',
          state: TaskState.Active,
          dueAt: DateTime.now().add(const Duration(days: 2)),
          tags: ['買い物'],
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
        ),
        Task(
          id: 'demo-4',
          title: 'プロジェクト資料を準備する',
          memo: '来週のミーティング用のスライド作成',
          state: TaskState.Active,
          dueAt: DateTime.now().add(const Duration(days: 5)),
          tags: ['仕事', '重要'],
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
        ),
        Task(
          id: 'demo-5',
          title: '本を読む',
          memo: '「習慣の力」を1章読む',
          state: TaskState.Active,
          tags: ['自己啓発', '読書'],
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Task(
          id: 'demo-6',
          title: 'メールの整理',
          state: TaskState.Active,
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        Task(
          id: 'demo-7',
          title: '部屋の掃除',
          memo: 'デスク周りと床の掃除',
          state: TaskState.Active,
          dueAt: DateTime.now().add(const Duration(hours: 20)),
          tags: ['家事'],
          createdAt: DateTime.now().subtract(const Duration(hours: 8)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 8)),
        ),
      ];

  /// 完了したタスク
  static List<Task> get completed => [
        Task(
          id: 'demo-8',
          title: '朝食を食べる',
          state: TaskState.Completed,
          createdAt: DateTime.now().subtract(const Duration(hours: 6)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 4)),
          completedAt: DateTime.now().subtract(const Duration(hours: 4)),
        ),
        Task(
          id: 'demo-9',
          title: 'ゴミ出し',
          memo: '燃えるゴミの日',
          state: TaskState.Completed,
          tags: ['家事'],
          createdAt: DateTime.now().subtract(const Duration(hours: 10)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 7)),
          completedAt: DateTime.now().subtract(const Duration(hours: 7)),
        ),
        Task(
          id: 'demo-10',
          title: '薬を飲む',
          state: TaskState.Completed,
          tags: ['健康'],
          createdAt: DateTime.now().subtract(const Duration(hours: 8)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
          completedAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
      ];

  /// 非表示のタスク
  static List<Task> get hidden => [
        Task(
          id: 'demo-11',
          title: '後で読む記事',
          memo: 'ブックマークした技術記事',
          state: TaskState.Hidden,
          tags: ['読書'],
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
          updatedAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ];

  /// 期限切れ（アーカイブ）のタスク
  static List<Task> get expired => [
        Task(
          id: 'demo-12',
          title: '先週のレポート提出',
          memo: '完了済みだがアーカイブ',
          state: TaskState.Expired,
          dueAt: DateTime.now().subtract(const Duration(days: 7)),
          tags: ['仕事'],
          createdAt: DateTime.now().subtract(const Duration(days: 14)),
          updatedAt: DateTime.now().subtract(const Duration(days: 7)),
          completedAt: DateTime.now().subtract(const Duration(days: 8)),
        ),
      ];
}
