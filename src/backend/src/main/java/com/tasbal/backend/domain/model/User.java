package com.tasbal.backend.domain.model;

import java.time.OffsetDateTime;
import java.util.UUID;

public class User {
    private final UUID id;
    private String handle;
    private Short plan; // 1:FREE 2:PRO
    private Boolean isGuest;
    private Short authState; // 1:GUEST 2:LINKED 3:DISABLED
    private final OffsetDateTime createdAt;
    private OffsetDateTime updatedAt;
    private OffsetDateTime lastLoginAt;
    private OffsetDateTime deletedAt;

    public User(UUID id, String handle, Short plan, Boolean isGuest, Short authState,
                OffsetDateTime createdAt, OffsetDateTime updatedAt, OffsetDateTime lastLoginAt,
                OffsetDateTime deletedAt) {
        this.id = id;
        this.handle = handle;
        this.plan = plan;
        this.isGuest = isGuest;
        this.authState = authState;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.lastLoginAt = lastLoginAt;
        this.deletedAt = deletedAt;
    }

    // Getters
    public UUID getId() {
        return id;
    }

    public String getHandle() {
        return handle;
    }

    public Short getPlan() {
        return plan;
    }

    public Boolean getIsGuest() {
        return isGuest;
    }

    public Short getAuthState() {
        return authState;
    }

    public OffsetDateTime getCreatedAt() {
        return createdAt;
    }

    public OffsetDateTime getUpdatedAt() {
        return updatedAt;
    }

    public OffsetDateTime getLastLoginAt() {
        return lastLoginAt;
    }

    public OffsetDateTime getDeletedAt() {
        return deletedAt;
    }

    // Setters
    public void setHandle(String handle) {
        this.handle = handle;
    }

    public void setPlan(Short plan) {
        this.plan = plan;
    }

    public void setAuthState(Short authState) {
        this.authState = authState;
    }

    public void setUpdatedAt(OffsetDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public void setLastLoginAt(OffsetDateTime lastLoginAt) {
        this.lastLoginAt = lastLoginAt;
    }
}
