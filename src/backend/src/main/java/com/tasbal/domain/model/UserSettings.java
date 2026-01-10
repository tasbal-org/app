package com.tasbal.domain.model;

import com.tasbal.domain.division.RenderQuality;

import java.time.OffsetDateTime;
import java.util.UUID;

/**
 * ユーザー設定ドメインモデル。
 *
 * <p>このクラスは{@link com.tasbal.domain.model.schema.UserSettings}を継承し、
 * ユーザー設定のビジネスロジックとdivision enumへのアクセスを提供します。</p>
 *
 * <p>ユーザーごとの個別設定（描画品質、省電力モード、地域設定など）を管理します。
 * スキーマモデルではShort型で保持されている描画品質を、
 * このドメインモデルでは型安全なenumとして扱えるようにします。</p>
 *
 * <h3>主な機能:</h3>
 * <ul>
 *   <li>描画品質（AUTO/NORMAL/LOW）のenum変換</li>
 *   <li>省電力モードの自動切り替え設定</li>
 *   <li>国コードによる地域設定</li>
 *   <li>スキーマモデルの全機能を継承</li>
 * </ul>
 *
 * @author Tasbal Team
 * @since 1.0.0
 * @see com.tasbal.domain.model.schema.UserSettings
 * @see RenderQuality
 */
public class UserSettings extends com.tasbal.domain.model.schema.UserSettings {

    /**
     * ユーザー設定を構築します。
     *
     * @param userId ユーザーID（設定の所有者）
     * @param countryCode 国コード（ISO 3166-1 alpha-2形式、例: "JP", "US"）
     * @param renderQuality 描画品質区分値（1:AUTO, 2:NORMAL, 3:LOW）
     * @param autoLowPower 省電力モード自動切り替えフラグ
     * @param updatedAt 更新日時
     */
    public UserSettings(UUID userId, String countryCode, Short renderQuality,
                        Boolean autoLowPower, OffsetDateTime updatedAt) {
        super(userId, countryCode, renderQuality, autoLowPower, updatedAt);
    }

    /**
     * 描画品質をenum型で取得します。
     *
     * <p>データベースの数値区分値を{@link RenderQuality} enumに変換して返します。
     * 変換に失敗した場合は{@link RenderQuality#Auto}がデフォルト値として返されます。</p>
     *
     * <h4>描画品質の種類:</h4>
     * <ul>
     *   <li>AUTO: デバイスの性能に応じて自動調整</li>
     *   <li>NORMAL: 標準品質（バランス重視）</li>
     *   <li>LOW: 低品質（パフォーマンス重視）</li>
     * </ul>
     *
     * @return 描画品質enum
     */
    public RenderQuality getRenderQualityEnum() {
        return RenderQuality.fromValue(getRenderQuality()).orElse(RenderQuality.Auto);
    }

    /**
     * 描画品質をenum型で設定します。
     *
     * <p>enum値を数値区分値に変換してデータベースに保存します。</p>
     *
     * @param renderQualityEnum 設定する描画品質enum
     */
    public void setRenderQualityEnum(RenderQuality renderQualityEnum) {
        setRenderQuality((short) renderQualityEnum.getValue());
    }
}
