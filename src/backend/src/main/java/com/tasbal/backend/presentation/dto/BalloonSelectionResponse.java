package com.tasbal.backend.presentation.dto;

import io.swagger.v3.oas.annotations.media.Schema;

import java.util.UUID;

@Schema(description = "風船選択レスポンス")
public class BalloonSelectionResponse {

    @Schema(description = "選択中の風船ID", example = "123e4567-e89b-12d3-a456-426614174000")
    private UUID balloonId;

    public BalloonSelectionResponse() {
    }

    public BalloonSelectionResponse(UUID balloonId) {
        this.balloonId = balloonId;
    }

    public UUID getBalloonId() {
        return balloonId;
    }

    public void setBalloonId(UUID balloonId) {
        this.balloonId = balloonId;
    }
}
