package com.tasbal.presentation.dto;

import com.tasbal.domain.division.BalloonVisibility;
import com.tasbal.domain.model.Balloon;

import java.time.OffsetDateTime;
import java.util.UUID;

/**
 * 風船情報のレスポンスDTO。
 *
 * <p>このクラスはAPI経由でクライアントに返却される風船情報を表現します。
 * ドメインモデルの{@link Balloon}から必要な情報を抽出し、
 * クライアントが利用しやすい形式に変換します。</p>
 *
 * <h3>主な特徴:</h3>
 * <ul>
 *   <li>風船タイプは表示名（文字列）として返却</li>
 *   <li>公開区分はboolean値（isPublic）として返却</li>
 *   <li>内部の区分値は公開しない</li>
 * </ul>
 *
 * @author Tasbal Team
 * @since 1.0.0
 * @see Balloon
 */
public class BalloonResponse {
    // 識別情報
    private UUID id;
    private UUID ownerUserId;

    // 基本情報
    private String type;
    private String title;
    private String description;

    // 表示設定
    private Short colorId;
    private Short tagIconId;
    private Boolean isPublic;

    // タイムスタンプ
    private OffsetDateTime createdAt;

    /**
     * ドメインモデルからレスポンスDTOを生成します。
     *
     * <p>このメソッドは{@link Balloon}ドメインモデルから
     * クライアント向けのレスポンスDTOを構築します。
     * 風船タイプは表示名に変換され、公開区分はboolean値として設定されます。</p>
     *
     * @param balloon 風船ドメインモデル
     * @return 構築されたBalloonResponseオブジェクト
     */
    public static BalloonResponse from(Balloon balloon) {
        BalloonResponse response = new BalloonResponse();
        response.id = balloon.getId();
        response.type = balloon.getBalloonTypeEnum().getDisplayName();
        response.title = balloon.getTitle();
        response.description = balloon.getDescription();
        response.colorId = balloon.getColorId();
        response.tagIconId = balloon.getTagIconId();
        response.isPublic = balloon.getVisibilityEnum() == BalloonVisibility.Public_;
        response.ownerUserId = balloon.getOwnerUserId();
        response.createdAt = balloon.getCreatedAt();
        return response;
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
