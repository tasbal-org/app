package com.tasbal.domain.model.schema;

import java.time.OffsetDateTime;
import java.util.UUID;

/**
 * ユーザー設定スキーマモデル。
 *
 * <p>このクラスはデータベースのuser_settingsテーブルと1:1で対応するスキーマ層のモデルです。
 * 描画品質などの区分値は数値（Short型）のまま保持します。</p>
 *
 * @author Tasbal Team
 * @since 1.0.0
 */
public class UserSettings {
    // 識別子
    private final UUID userId;

    // 基本設定
    private String countryCode;
    private Short renderQuality;
    private Boolean autoLowPower;

    // タイムスタンプ
    private OffsetDateTime updatedAt;

    /**
     * コンストラクタ。
     *
     * @param userId ユーザーID
     * @param countryCode 国コード
     * @param renderQuality 描画品質区分
     * @param autoLowPower 自動省電力モードフラグ
     * @param updatedAt 更新日時
     */
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
