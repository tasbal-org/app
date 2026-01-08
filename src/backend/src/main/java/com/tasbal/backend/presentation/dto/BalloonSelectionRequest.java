package com.tasbal.backend.presentation.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;

import java.util.UUID;

@Schema(description = "風船選択リクエスト")
public class BalloonSelectionRequest {

    @NotNull(message = "balloonId is required")
    @Schema(description = "選択する風船のID", example = "123e4567-e89b-12d3-a456-426614174000", required = true)
    private UUID balloonId;

    public BalloonSelectionRequest() {
    }

    public BalloonSelectionRequest(UUID balloonId) {
        this.balloonId = balloonId;
    }

    public UUID getBalloonId() {
        return balloonId;
    }

    public void setBalloonId(UUID balloonId) {
        this.balloonId = balloonId;
    }
}
