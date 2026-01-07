package com.tasbal.backend.presentation.dto;

import jakarta.validation.constraints.NotNull;

public class ToggleDoneRequest {

    @NotNull(message = "isDone is required")
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
