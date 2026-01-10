package com.tasbal.domain.model.schema;

import java.time.OffsetDateTime;
import java.util.UUID;

/**
 * 風船スキーマモデル。
 *
 * <p>このクラスはデータベースのballoonsテーブルと1:1で対応するスキーマ層のモデルです。
 * 風船タイプ、表示グループ、公開区分などの区分値は数値（Short型）のまま保持します。</p>
 *
 * @author Tasbal Team
 * @since 1.0.0
 */
public class Balloon {
    // 識別子
    private final UUID id;

    // 風船の分類・表示設定
    private Short balloonType;
    private Short displayGroup;
    private Short visibility;

    // 基本情報
    private UUID ownerUserId;
    private String title;
    private String description;

    // 表示設定
    private Short colorId;
    private Short tagIconId;
    private String countryCode;
    private Boolean isActive;

    // タイムスタンプ
    private final OffsetDateTime createdAt;
    private OffsetDateTime updatedAt;

    /**
     * コンストラクタ。
     *
     * @param id 風船ID
     * @param balloonType 風船タイプ区分
     * @param displayGroup 表示グループ区分
     * @param visibility 公開区分
     * @param ownerUserId オーナーユーザーID
     * @param title タイトル
     * @param description 説明
     * @param colorId カラーID
     * @param tagIconId タグアイコンID
     * @param countryCode 国コード
     * @param isActive 有効フラグ
     * @param createdAt 作成日時
     * @param updatedAt 更新日時
     */
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
    public void setBalloonType(Short balloonType) {
        this.balloonType = balloonType;
    }

    public void setDisplayGroup(Short displayGroup) {
        this.displayGroup = displayGroup;
    }

    public void setVisibility(Short visibility) {
        this.visibility = visibility;
    }

    public void setOwnerUserId(UUID ownerUserId) {
        this.ownerUserId = ownerUserId;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setColorId(Short colorId) {
        this.colorId = colorId;
    }

    public void setTagIconId(Short tagIconId) {
        this.tagIconId = tagIconId;
    }

    public void setCountryCode(String countryCode) {
        this.countryCode = countryCode;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    public void setUpdatedAt(OffsetDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}
