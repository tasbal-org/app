package com.tasbal.backend.presentation.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

import java.time.OffsetDateTime;

public class TaskRequest {

    @NotBlank(message = "Title is required")
    @Size(max = 500, message = "Title must be less than 500 characters")
    private String title;

    private String memo;
    private OffsetDateTime dueAt;

    // Constructors
    public TaskRequest() {
    }

    public TaskRequest(String title, String memo, OffsetDateTime dueAt) {
        this.title = title;
        this.memo = memo;
        this.dueAt = dueAt;
    }

    // Getters and Setters
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
}
