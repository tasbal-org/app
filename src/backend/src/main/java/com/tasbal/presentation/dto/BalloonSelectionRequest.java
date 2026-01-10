package com.tasbal.presentation.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;

import java.util.UUID;

/**
 * 風船選択リクエストDTO。
 *
 * <p>このクラスはユーザーが作業対象とする風船を選択する際のリクエストを表現します。
 * 選択された風船IDが必須項目として定義されています。</p>
 *
 * @author Tasbal Team
 * @since 1.0.0
 */
@Schema(description = "風船選択リクエスト")
public class BalloonSelectionRequest {

    @NotNull(message = "balloonId is required")
    @Schema(description = "選択する風船のID", example = "123e4567-e89b-12d3-a456-426614174000", required = true)
    private UUID balloonId;

    /**
     * デフォルトコンストラクタ。
     */
    public BalloonSelectionRequest() {
    }

    /**
     * 風船IDを指定してインスタンスを構築します。
     *
     * @param balloonId 選択する風船のID
     */
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
