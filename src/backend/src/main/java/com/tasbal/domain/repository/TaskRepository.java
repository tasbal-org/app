package com.tasbal.domain.repository;

import com.tasbal.domain.model.Task;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * タスクのリポジトリインターフェース。
 *
 * <p>このインターフェースは、タスクエンティティの永続化層へのアクセスを定義します。
 * Tasbalアプリケーションにおけるタスクの作成、更新、検索、削除、完了状態の切り替えを提供します。</p>
 *
 * <p>実装クラスは、ストアドプロシージャ・ストアドファンクションを経由して
 * データベースアクセスを行う必要があります。</p>
 *
 * @author Tasbal Team
 * @since 1.0.0
 * @see Task
 */
public interface TaskRepository {
    /**
     * 新しいタスクを作成します。
     *
     * @param userId タスクを作成するユーザーのID
     * @param title タスクのタイトル
     * @param memo タスクのメモ
     * @param dueAt タスクの期限日時
     * @return 作成されたタスクオブジェクト
     */
    Task create(UUID userId, String title, String memo, OffsetDateTime dueAt);

    /**
     * 指定されたユーザーのタスク一覧を取得します。
     *
     * @param userId 対象ユーザーのID
     * @param limit 取得する最大件数
     * @param offset 取得開始位置（ページネーション用）
     * @return タスクのリスト
     */
    List<Task> findByUserId(UUID userId, int limit, int offset);

    /**
     * 指定されたIDのタスクを取得します。
     *
     * @param taskId 取得するタスクのID
     * @param userId タスクの所有者のユーザーID（権限チェック用）
     * @return タスクオブジェクト（存在しない場合は空のOptional）
     */
    Optional<Task> findById(UUID taskId, UUID userId);

    /**
     * タスクの情報を更新します。
     *
     * @param taskId 更新するタスクのID
     * @param userId タスクの所有者のユーザーID（権限チェック用）
     * @param title 新しいタイトル
     * @param memo 新しいメモ
     * @param dueAt 新しい期限日時
     * @param pinned ピン留め状態
     * @return 更新後のタスクオブジェクト
     */
    Task update(UUID taskId, UUID userId, String title, String memo, OffsetDateTime dueAt, Boolean pinned);

    /**
     * タスクの完了状態を切り替えます。
     *
     * @param taskId 対象タスクのID
     * @param userId タスクの所有者のユーザーID（権限チェック用）
     * @param isDone 完了状態（true: 完了、false: 未完了）
     * @return 更新後のタスクオブジェクト
     */
    Task toggleCompletion(UUID taskId, UUID userId, boolean isDone);

    /**
     * タスクを削除します。
     *
     * @param taskId 削除するタスクのID
     * @param userId タスクの所有者のユーザーID（権限チェック用）
     */
    void delete(UUID taskId, UUID userId);
}
