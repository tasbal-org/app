package com.tasbal.backend.domain.model;

import java.time.OffsetDateTime;
import java.util.UUID;

public class Balloon {
    private final UUID id;
    private Short balloonType; // 1:GLOBAL 2:LOCATION 3:BREATHING 4:USER 5:GUERRILLA
    private Short displayGroup; // 1:PINNED 2:DRIFTING
    private Short visibility; // 1:SYSTEM 2:PRIVATE 3:PUBLIC
    private UUID ownerUserId;
    private String title;
    private String description;
    private Short colorId;
    private Short tagIconId;
    private String countryCode;
    private Boolean isActive;
    private final OffsetDateTime createdAt;
    private OffsetDateTime updatedAt;

    public Balloon(UUID id, Short balloonType, Short displayGroup, Short visibility,
                   UUID ownerUserId, String title, String description, Short colorId,
                   Short tagIconId, String countryCode, Boolean isActive,
                   OffsetDateTime createdAt, OffsetDateTime updatedAt) {
        this.id = id;
        this.balloonType = balloonType;
        this.displayGroup = displayGroup;
        this.visibility = visibility;
        this.ownerUserId = ownerUserId;
        this.title = title;
        this.description = description;
        this.colorId = colorId;
        this.tagIconId = tagIconId;
        this.countryCode = countryCode;
        this.isActive = isActive;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters
    public UUID getId() {
        return id;
    }

    public Short getBalloonType() {
        return balloonType;
    }

    public Short getDisplayGroup() {
        return displayGroup;
    }

    public Short getVisibility() {
        return visibility;
    }

    public UUID getOwnerUserId() {
        return ownerUserId;
    }

    public String getTitle() {
        return title;
    }

    public String getDescription() {
        return description;
    }

    public Short getColorId() {
        return colorId;
    }

    public Short getTagIconId() {
        return tagIconId;
    }

    public String getCountryCode() {
        return countryCode;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public OffsetDateTime getCreatedAt() {
        return createdAt;
    }

    public OffsetDateTime getUpdatedAt() {
        return updatedAt;
    }

    // Setters
    public void setTitle(String title) {
        this.title = title;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setVisibility(Short visibility) {
        this.visibility = visibility;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    public void setUpdatedAt(OffsetDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}
