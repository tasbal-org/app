package com.tasbal.presentation.dto;

import com.tasbal.domain.model.Task;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.UUID;

/**
 * タスク情報のレスポンスDTO。
 *
 * <p>このクラスはAPI経由でクライアントに返却されるタスク情報を表現します。
 * ドメインモデルの{@link Task}から必要な情報を抽出し、
 * クライアントが利用しやすい形式に変換します。</p>
 *
 * <h3>主な特徴:</h3>
 * <ul>
 *   <li>タスク状態は表示名（文字列）として返却</li>
 *   <li>完了判定フラグ（isDone）を提供</li>
 *   <li>内部の区分値は公開しない</li>
 * </ul>
 *
 * @author Tasbal Team
 * @since 1.0.0
 * @see Task
 */
public class TaskResponse {
    // 識別情報
    private UUID id;
    private UUID userId;

    // タスク基本情報
    private String title;
    private String memo;
    private OffsetDateTime dueAt;
    private String status;
    private Boolean pinned;
    private Boolean isDone;

    // タイムスタンプ
    private OffsetDateTime completedAt;
    private OffsetDateTime createdAt;
    private OffsetDateTime updatedAt;

    // 関連情報
    private List<UUID> tagIds;

    /**
     * ドメインモデルからレスポンスDTOを生成します。
     *
     * <p>このメソッドは{@link Task}ドメインモデルから
     * クライアント向けのレスポンスDTOを構築します。
     * タスク状態は表示名に変換され、完了判定フラグも設定されます。</p>
     *
     * @param task タスクドメインモデル
     * @return 構築されたTaskResponseオブジェクト
     */
    public static TaskResponse from(Task task) {
        TaskResponse response = new TaskResponse();
        response.id = task.getId();
        response.userId = task.getUserId();
        response.title = task.getTitle();
        response.memo = task.getMemo();
        response.dueAt = task.getDueAt();
        response.status = task.getStatusEnum().getDisplayName();
        response.pinned = task.getPinned();
        response.isDone = task.isDone();
        response.completedAt = task.getCompletedAt();
        response.createdAt = task.getCreatedAt();
        response.updatedAt = task.getUpdatedAt();
        response.tagIds = task.getTagIds();
        return response;
    }

    // Getters and Setters
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getUserId() {
        return userId;
    }

    public void setUserId(UUID userId) {
        this.userId = userId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }

    public OffsetDateTime getDueAt() {
        return dueAt;
    }

    public void setDueAt(OffsetDateTime dueAt) {
        this.dueAt = dueAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Boolean getPinned() {
        return pinned;
    }

    public void setPinned(Boolean pinned) {
        this.pinned = pinned;
    }

    public Boolean getIsDone() {
        return isDone;
    }

    public void setIsDone(Boolean isDone) {
        this.isDone = isDone;
    }

    public OffsetDateTime getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(OffsetDateTime completedAt) {
        this.completedAt = completedAt;
    }

    public OffsetDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(OffsetDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public OffsetDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(OffsetDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public List<UUID> getTagIds() {
        return tagIds;
    }

    public void setTagIds(List<UUID> tagIds) {
        this.tagIds = tagIds;
    }
}
