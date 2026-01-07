package com.tasbal.backend.domain.model;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.UUID;

public class Task {
    private final UUID id;
    private final UUID userId;
    private String title;
    private String memo;
    private OffsetDateTime dueAt;
    private Short status; // 1:TODO 2:DOING 3:DONE
    private Boolean pinned;
    private OffsetDateTime completedAt;
    private OffsetDateTime archivedAt;
    private final OffsetDateTime createdAt;
    private OffsetDateTime updatedAt;
    private OffsetDateTime deletedAt;
    private List<UUID> tagIds;

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

    public void setPinned(Boolean pinned) {
        this.pinned = pinned;
    }

    public void setStatus(Short status) {
        this.status = status;
    }

    public void setCompletedAt(OffsetDateTime completedAt) {
        this.completedAt = completedAt;
    }

    public void setUpdatedAt(OffsetDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public void setTagIds(List<UUID> tagIds) {
        this.tagIds = tagIds;
    }

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
