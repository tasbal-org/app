package com.tasbal.backend.domain.model;

import java.time.OffsetDateTime;
import java.util.UUID;

public class UserSettings {
    private final UUID userId;
    private String countryCode;
    private Short renderQuality; // 1:AUTO 2:NORMAL 3:LOW
    private Boolean autoLowPower;
    private OffsetDateTime updatedAt;

    public UserSettings(UUID userId, String countryCode, Short renderQuality,
                        Boolean autoLowPower, OffsetDateTime updatedAt) {
        this.userId = userId;
        this.countryCode = countryCode;
        this.renderQuality = renderQuality;
        this.autoLowPower = autoLowPower;
        this.updatedAt = updatedAt;
    }

    // Getters
    public UUID getUserId() {
        return userId;
    }

    public String getCountryCode() {
        return countryCode;
    }

    public Short getRenderQuality() {
        return renderQuality;
    }

    public Boolean getAutoLowPower() {
        return autoLowPower;
    }

    public OffsetDateTime getUpdatedAt() {
        return updatedAt;
    }

    // Setters
    public void setCountryCode(String countryCode) {
        this.countryCode = countryCode;
    }

    public void setRenderQuality(Short renderQuality) {
        this.renderQuality = renderQuality;
    }

    public void setAutoLowPower(Boolean autoLowPower) {
        this.autoLowPower = autoLowPower;
    }

    public void setUpdatedAt(OffsetDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}
