package com.tasbal.backend.presentation.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public class BalloonRequest {

    @NotBlank(message = "Title is required")
    @Size(max = 100, message = "Title must be less than 100 characters")
    private String title;

    private String description;

    @NotNull(message = "colorId is required")
    private Short colorId;

    private Short tagIconId;

    @NotNull(message = "isPublic is required")
    private Boolean isPublic;

    // Constructors
    public BalloonRequest() {
    }

    public BalloonRequest(String title, String description, Short colorId, Short tagIconId, Boolean isPublic) {
        this.title = title;
        this.description = description;
        this.colorId = colorId;
        this.tagIconId = tagIconId;
        this.isPublic = isPublic;
    }

    // Getters and Setters
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
}
