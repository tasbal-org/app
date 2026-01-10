package com.tasbal.presentation.dto;

import io.swagger.v3.oas.annotations.media.Schema;

import java.util.UUID;

/**
 * 風船選択情報のレスポンスDTO。
 *
 * <p>このクラスはAPI経由でクライアントに返却される
 * 現在選択されている風船の情報を表現します。</p>
 *
 * @author Tasbal Team
 * @since 1.0.0
 */
@Schema(description = "風船選択レスポンス")
public class BalloonSelectionResponse {

    @Schema(description = "選択中の風船ID", example = "123e4567-e89b-12d3-a456-426614174000")
    private UUID balloonId;

    /**
     * デフォルトコンストラクタ。
     */
    public BalloonSelectionResponse() {
    }

    /**
     * 風船IDを指定してインスタンスを構築します。
     *
     * @param balloonId 選択中の風船ID
     */
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
