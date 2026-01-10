package com.tasbal.application.service;

import com.tasbal.domain.model.Task;
import com.tasbal.domain.repository.TaskRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.UUID;

/**
 * タスクアプリケーションサービス。
 *
 * <p>このクラスはタスクに関するユースケースを提供します。
 * タスクのCRUD操作、完了状態の切り替えを担当します。</p>
 *
 * <p>主な機能:</p>
 * <ul>
 *   <li>タスクの新規作成</li>
 *   <li>ユーザーのタスク一覧取得（ページネーション対応）</li>
 *   <li>タスクの詳細取得</li>
 *   <li>タスクの更新（タイトル、メモ、期限、ピン留め）</li>
 *   <li>タスクの完了状態切り替え</li>
 *   <li>タスクの削除</li>
 * </ul>
 *
 * @author Tasbal Team
 * @since 1.0.0
 * @see TaskRepository
 * @see Task
 */
@Service
@Transactional
public class TaskService {

    private final TaskRepository taskRepository;

    /**
     * コンストラクタ。
     *
     * @param taskRepository タスクリポジトリ
     */
    public TaskService(TaskRepository taskRepository) {
        this.taskRepository = taskRepository;
    }

    /**
     * 新しいタスクを作成します。
     *
     * @param userId タスクを作成するユーザーのID
     * @param title タスクのタイトル
     * @param memo タスクのメモ（詳細説明）
     * @param dueAt タスクの期限日時
     * @return 作成されたタスクオブジェクト
     */
    public Task createTask(UUID userId, String title, String memo, OffsetDateTime dueAt) {
        return taskRepository.create(userId, title, memo, dueAt);
    }

    /**
     * 指定ユーザーのタスク一覧を取得します。
     *
     * <p>ページネーションに対応し、指定された件数とオフセットでタスクを取得します。</p>
     *
     * @param userId ユーザーID
     * @param limit 取得する最大件数
     * @param offset 取得開始位置（スキップする件数）
     * @return タスクのリスト
     */
    public List<Task> getTasks(UUID userId, int limit, int offset) {
        return taskRepository.findByUserId(userId, limit, offset);
    }

    /**
     * タスクIDとユーザーIDでタスクを取得します。
     *
     * @param taskId タスクID
     * @param userId ユーザーID（所有者確認用）
     * @return タスクオブジェクト
     * @throws RuntimeException タスクが見つからない場合
     */
    public Task getTaskById(UUID taskId, UUID userId) {
        return taskRepository.findById(taskId, userId)
                .orElseThrow(() -> new RuntimeException("Task not found"));
    }

    /**
     * タスクを更新します。
     *
     * @param taskId 更新対象のタスクID
     * @param userId ユーザーID（所有者確認用）
     * @param title 新しいタイトル
     * @param memo 新しいメモ
     * @param dueAt 新しい期限日時
     * @param pinned ピン留めフラグ
     * @return 更新されたタスクオブジェクト
     */
    public Task updateTask(UUID taskId, UUID userId, String title, String memo, OffsetDateTime dueAt, Boolean pinned) {
        return taskRepository.update(taskId, userId, title, memo, dueAt, pinned);
    }

    /**
     * タスクの完了状態を切り替えます。
     *
     * @param taskId 対象のタスクID
     * @param userId ユーザーID（所有者確認用）
     * @param isDone 完了状態（trueで完了、falseで未完了）
     * @return 状態が更新されたタスクオブジェクト
     */
    public Task toggleTaskCompletion(UUID taskId, UUID userId, boolean isDone) {
        return taskRepository.toggleCompletion(taskId, userId, isDone);
    }

    /**
     * タスクを削除します。
     *
     * @param taskId 削除対象のタスクID
     * @param userId ユーザーID（所有者確認用）
     */
    public void deleteTask(UUID taskId, UUID userId) {
        taskRepository.delete(taskId, userId);
    }
}
