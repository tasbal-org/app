package com.tasbal.backend.presentation.dto;

import com.tasbal.backend.domain.model.User;

import java.time.OffsetDateTime;
import java.util.UUID;

public class UserResponse {
    private UUID id;
    private String handle;
    private String plan;
    private Boolean isGuest;
    private OffsetDateTime createdAt;

    public static UserResponse from(User user) {
        UserResponse response = new UserResponse();
        response.id = user.getId();
        response.handle = user.getHandle();
        response.plan = user.getPlan() == 1 ? "FREE" : "PRO";
        response.isGuest = user.getIsGuest();
        response.createdAt = user.getCreatedAt();
        return response;
    }

    // Getters and Setters
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getHandle() {
        return handle;
    }

    public void setHandle(String handle) {
        this.handle = handle;
    }

    public String getPlan() {
        return plan;
    }

    public void setPlan(String plan) {
        this.plan = plan;
    }

    public Boolean getIsGuest() {
        return isGuest;
    }

    public void setIsGuest(Boolean isGuest) {
        this.isGuest = isGuest;
    }

    public OffsetDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(OffsetDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
