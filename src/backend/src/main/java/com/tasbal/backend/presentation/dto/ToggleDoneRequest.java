package com.tasbal.backend.presentation.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;

@Schema(description = "タスク完了切替リクエスト")
public class ToggleDoneRequest {

    @NotNull(message = "isDone is required")
    @Schema(description = "完了状態", example = "true", required = true)
    private Boolean isDone;

    // Constructors
    public ToggleDoneRequest() {
    }

    public ToggleDoneRequest(Boolean isDone) {
        this.isDone = isDone;
    }

    // Getters and Setters
    public Boolean getIsDone() {
        return isDone;
    }

    public void setIsDone(Boolean isDone) {
        this.isDone = isDone;
    }
}
