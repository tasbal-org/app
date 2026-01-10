package com.tasbal.domain.model.schema;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.UUID;

/**
 * タスクスキーマモデル。
 *
 * <p>このクラスはデータベースのtasksテーブルと1:1で対応するスキーマ層のモデルです。
 * タスク状態などの区分値は数値（Short型）のまま保持します。</p>
 *
 * @author Tasbal Team
 * @since 1.0.0
 */
public class Task {
    // 識別子
    private final UUID id;
    private final UUID userId;

    // タスク基本情報
    private String title;
    private String memo;
    private OffsetDateTime dueAt;
    private Short status;
    private Boolean pinned;

    // タイムスタンプ
    private OffsetDateTime completedAt;
    private OffsetDateTime archivedAt;
    private final OffsetDateTime createdAt;
    private OffsetDateTime updatedAt;
    private OffsetDateTime deletedAt;

    // 関連情報
    private List<UUID> tagIds;

    /**
     * コンストラクタ。
     *
     * @param id タスクID
     * @param userId ユーザーID
     * @param title タイトル
     * @param memo メモ
     * @param dueAt 期限日時
     * @param status ステータス区分
     * @param pinned ピン留めフラグ
     * @param completedAt 完了日時
     * @param archivedAt アーカイブ日時
     * @param createdAt 作成日時
     * @param updatedAt 更新日時
     * @param deletedAt 削除日時
     * @param tagIds タグIDリスト
     */
    public Task(UUID id, UUID userId, String title, String memo, OffsetDateTime dueAt,
                Short status, Boolean pinned, OffsetDateTime completedAt, OffsetDateTime archivedAt,
                OffsetDateTime createdAt, OffsetDateTime updatedAt, OffsetDateTime deletedAt,
                List<UUID> tagIds) {
        this.id = id;
        this.userId = userId;
        this.title = title;
        this.memo = memo;
        this.dueAt = dueAt;
        this.status = status;
        this.pinned = pinned;
        this.completedAt = completedAt;
        this.archivedAt = archivedAt;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.deletedAt = deletedAt;
        this.tagIds = tagIds;
    }

    // Getters
    public UUID getId() {
        return id;
    }

    public UUID getUserId() {
        return userId;
    }

    public String getTitle() {
        return title;
    }

    public String getMemo() {
        return memo;
    }

    public OffsetDateTime getDueAt() {
        return dueAt;
    }

    public Short getStatus() {
        return status;
    }

    public Boolean getPinned() {
        return pinned;
    }

    public OffsetDateTime getCompletedAt() {
        return completedAt;
    }

    public OffsetDateTime getArchivedAt() {
        return archivedAt;
    }

    public OffsetDateTime getCreatedAt() {
        return createdAt;
    }

    public OffsetDateTime getUpdatedAt() {
        return updatedAt;
    }

    public OffsetDateTime getDeletedAt() {
        return deletedAt;
    }

    public List<UUID> getTagIds() {
        return tagIds;
    }

    // Setters
    public void setTitle(String title) {
        this.title = title;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }

    public void setDueAt(OffsetDateTime dueAt) {
        this.dueAt = dueAt;
    }

    public void setStatus(Short status) {
        this.status = status;
    }

    public void setPinned(Boolean pinned) {
        this.pinned = pinned;
    }

    public void setCompletedAt(OffsetDateTime completedAt) {
        this.completedAt = completedAt;
    }

    public void setArchivedAt(OffsetDateTime archivedAt) {
        this.archivedAt = archivedAt;
    }

    public void setUpdatedAt(OffsetDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public void setDeletedAt(OffsetDateTime deletedAt) {
        this.deletedAt = deletedAt;
    }

    public void setTagIds(List<UUID> tagIds) {
        this.tagIds = tagIds;
    }

    // Business logic methods
    public boolean isDone() {
        return status != null && status == 3;
    }

    public boolean isArchived() {
        return archivedAt != null;
    }

    public boolean isDeleted() {
        return deletedAt != null;
    }
}
