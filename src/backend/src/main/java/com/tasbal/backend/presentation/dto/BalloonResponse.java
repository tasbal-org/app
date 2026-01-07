package com.tasbal.backend.presentation.dto;

import com.tasbal.backend.domain.model.Balloon;

import java.time.OffsetDateTime;
import java.util.UUID;

public class BalloonResponse {
    private UUID id;
    private String type;
    private String title;
    private String description;
    private Short colorId;
    private Short tagIconId;
    private Boolean isPublic;
    private UUID ownerUserId;
    private OffsetDateTime createdAt;

    public static BalloonResponse from(Balloon balloon) {
        BalloonResponse response = new BalloonResponse();
        response.id = balloon.getId();
        response.type = mapBalloonType(balloon.getBalloonType());
        response.title = balloon.getTitle();
        response.description = balloon.getDescription();
        response.colorId = balloon.getColorId();
        response.tagIconId = balloon.getTagIconId();
        response.isPublic = balloon.getVisibility() == 3; // 3:PUBLIC
        response.ownerUserId = balloon.getOwnerUserId();
        response.createdAt = balloon.getCreatedAt();
        return response;
    }

    private static String mapBalloonType(Short balloonType) {
        if (balloonType == null) return "UNKNOWN";
        switch (balloonType) {
            case 1: return "GLOBAL";
            case 2: return "LOCATION";
            case 3: return "BREATHING";
            case 4: return "USER";
            case 5: return "GUERRILLA";
            default: return "UNKNOWN";
        }
    }

    // Getters and Setters
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Short getColorId() {
        return colorId;
    }

    public void setColorId(Short colorId) {
        this.colorId = colorId;
    }

    public Short getTagIconId() {
        return tagIconId;
    }

    public void setTagIconId(Short tagIconId) {
        this.tagIconId = tagIconId;
    }

    public Boolean getIsPublic() {
        return isPublic;
    }

    public void setIsPublic(Boolean isPublic) {
        this.isPublic = isPublic;
    }

    public UUID getOwnerUserId() {
        return ownerUserId;
    }

    public void setOwnerUserId(UUID ownerUserId) {
        this.ownerUserId = ownerUserId;
    }

    public OffsetDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(OffsetDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
