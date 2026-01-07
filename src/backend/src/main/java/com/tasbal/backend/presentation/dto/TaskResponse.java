package com.tasbal.backend.presentation.dto;

import com.tasbal.backend.domain.model.Task;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.UUID;

public class TaskResponse {
    private UUID id;
    private UUID userId;
    private String title;
    private String memo;
    private OffsetDateTime dueAt;
    private Short status;
    private Boolean pinned;
    private Boolean isDone;
    private OffsetDateTime completedAt;
    private OffsetDateTime createdAt;
    private OffsetDateTime updatedAt;
    private List<UUID> tagIds;

    public static TaskResponse from(Task task) {
        TaskResponse response = new TaskResponse();
        response.id = task.getId();
        response.userId = task.getUserId();
        response.title = task.getTitle();
        response.memo = task.getMemo();
        response.dueAt = task.getDueAt();
        response.status = task.getStatus();
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

    public Short getStatus() {
        return status;
    }

    public void setStatus(Short status) {
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
