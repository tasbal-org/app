package com.tasbal.domain.model;

import com.tasbal.domain.division.TaskStatus;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.UUID;

/**
 * タスクドメインモデル。
 *
 * <p>このクラスは{@link com.tasbal.domain.model.schema.Task}を継承し、
 * タスクのビジネスロジックとdivision enumへのアクセスを提供します。</p>
 *
 * <p>スキーマモデルではShort型で保持されているタスク状態を、
 * このドメインモデルでは型安全なenumとして扱えるようにします。</p>
 *
 * <h3>主な機能:</h3>
 * <ul>
 *   <li>タスク状態（TODO/DOING/DONE）のenum変換</li>
 *   <li>完了判定メソッド（{@link #isDone()}）のenum対応</li>
 *   <li>スキーマモデルの全機能を継承</li>
 * </ul>
 *
 * @author Tasbal Team
 * @since 1.0.0
 * @see com.tasbal.domain.model.schema.Task
 * @see TaskStatus
 */
public class Task extends com.tasbal.domain.model.schema.Task {

    /**
     * タスクを構築します。
     *
     * @param id タスクID
     * @param userId ユーザーID（タスクの所有者）
     * @param title タスクのタイトル
     * @param memo タスクのメモ
     * @param dueAt 期限日時
     * @param status タスク状態区分値（1:TODO, 2:DOING, 3:DONE）
     * @param pinned ピン留めフラグ
     * @param completedAt 完了日時
     * @param archivedAt アーカイブ日時
     * @param createdAt 作成日時
     * @param updatedAt 更新日時
     * @param deletedAt 削除日時（論理削除）
     * @param tagIds 紐づくタグのIDリスト
     */
    public Task(UUID id, UUID userId, String title, String memo, OffsetDateTime dueAt,
                Short status, Boolean pinned, OffsetDateTime completedAt, OffsetDateTime archivedAt,
                OffsetDateTime createdAt, OffsetDateTime updatedAt, OffsetDateTime deletedAt,
                List<UUID> tagIds) {
        super(id, userId, title, memo, dueAt, status, pinned, completedAt, archivedAt,
              createdAt, updatedAt, deletedAt, tagIds);
    }

    /**
     * タスク状態をenum型で取得します。
     *
     * <p>データベースの数値区分値を{@link TaskStatus} enumに変換して返します。
     * 変換に失敗した場合は{@link TaskStatus#Todo}がデフォルト値として返されます。</p>
     *
     * @return タスク状態enum
     */
    public TaskStatus getStatusEnum() {
        return TaskStatus.fromValue(getStatus()).orElse(TaskStatus.Todo);
    }

    /**
     * タスク状態をenum型で設定します。
     *
     * <p>enum値を数値区分値に変換してデータベースに保存します。</p>
     *
     * @param statusEnum 設定するタスク状態enum
     */
    public void setStatusEnum(TaskStatus statusEnum) {
        setStatus((short) statusEnum.getValue());
    }

    /**
     * タスクが完了状態かを判定します。
     *
     * <p>タスク状態enumが{@link TaskStatus#Done}の場合にtrueを返します。
     * このメソッドはスキーマモデルのメソッドをオーバーライドし、
     * enum比較を使用した型安全な実装を提供します。</p>
     *
     * @return タスクが完了状態の場合true
     */
    @Override
    public boolean isDone() {
        return getStatusEnum() == TaskStatus.Done;
    }
}
