package com.tasbal.domain.model;

import com.tasbal.domain.division.BalloonType;
import com.tasbal.domain.division.BalloonDisplayGroup;
import com.tasbal.domain.division.BalloonVisibility;

import java.time.OffsetDateTime;
import java.util.UUID;

/**
 * 風船ドメインモデル。
 *
 * <p>このクラスは{@link com.tasbal.domain.model.schema.Balloon}を継承し、
 * 風船のビジネスロジックとdivision enumへのアクセスを提供します。</p>
 *
 * <p>風船は「個人のタスク達成が、みんなの達成感につながる」を体現する
 * Tasbalの中心的な概念です。ユーザーがタスクを完了すると、
 * 選択中の風船に貢献が加算され、閾値に達すると風船が割れて達成感を共有します。</p>
 *
 * <h3>主な機能:</h3>
 * <ul>
 *   <li>風船タイプ（GLOBAL/LOCATION/BREATHING/USER/GUERRILLA）のenum変換</li>
 *   <li>表示グループ（PINNED/DRIFTING）のenum変換</li>
 *   <li>公開区分（SYSTEM/PRIVATE/PUBLIC）のenum変換</li>
 *   <li>スキーマモデルの全機能を継承</li>
 * </ul>
 *
 * @author Tasbal Team
 * @since 1.0.0
 * @see com.tasbal.domain.model.schema.Balloon
 * @see BalloonType
 * @see BalloonDisplayGroup
 * @see BalloonVisibility
 */
public class Balloon extends com.tasbal.domain.model.schema.Balloon {

    /**
     * 風船を構築します。
     *
     * @param id 風船ID
     * @param balloonType 風船タイプ区分値（1:GLOBAL, 2:LOCATION, 3:BREATHING, 4:USER, 5:GUERRILLA）
     * @param displayGroup 表示グループ区分値（1:PINNED, 2:DRIFTING）
     * @param visibility 公開区分値（1:SYSTEM, 2:PRIVATE, 3:PUBLIC）
     * @param ownerUserId オーナーユーザーID（USER風船の場合）
     * @param title 風船のタイトル
     * @param description 風船の説明
     * @param colorId 風船の色ID
     * @param tagIconId タグアイコンID
     * @param countryCode 国コード（LOCATION風船の場合）
     * @param isActive アクティブフラグ
     * @param createdAt 作成日時
     * @param updatedAt 更新日時
     */
    public Balloon(UUID id, Short balloonType, Short displayGroup, Short visibility,
                   UUID ownerUserId, String title, String description, Short colorId,
                   Short tagIconId, String countryCode, Boolean isActive,
                   OffsetDateTime createdAt, OffsetDateTime updatedAt) {
        super(id, balloonType, displayGroup, visibility, ownerUserId, title, description,
              colorId, tagIconId, countryCode, isActive, createdAt, updatedAt);
    }

    /**
     * 風船タイプをenum型で取得します。
     *
     * <p>データベースの数値区分値を{@link BalloonType} enumに変換して返します。
     * 変換に失敗した場合は{@link BalloonType#Global}がデフォルト値として返されます。</p>
     *
     * <h4>風船タイプの種類:</h4>
     * <ul>
     *   <li>GLOBAL: 全世界共通の風船</li>
     *   <li>LOCATION: 地域（国）ごとの風船</li>
     *   <li>BREATHING: 日ごとにリセットされる風船</li>
     *   <li>USER: ユーザーが作成した風船</li>
     *   <li>GUERRILLA: 期間限定イベント風船</li>
     * </ul>
     *
     * @return 風船タイプenum
     */
    public BalloonType getBalloonTypeEnum() {
        return BalloonType.fromValue(getBalloonType()).orElse(BalloonType.Global);
    }

    /**
     * 表示グループをenum型で取得します。
     *
     * <p>データベースの数値区分値を{@link BalloonDisplayGroup} enumに変換して返します。
     * 変換に失敗した場合は{@link BalloonDisplayGroup#Pinned}がデフォルト値として返されます。</p>
     *
     * @return 表示グループenum
     */
    public BalloonDisplayGroup getDisplayGroupEnum() {
        return BalloonDisplayGroup.fromValue(getDisplayGroup()).orElse(BalloonDisplayGroup.Pinned);
    }

    /**
     * 公開区分をenum型で取得します。
     *
     * <p>データベースの数値区分値を{@link BalloonVisibility} enumに変換して返します。
     * 変換に失敗した場合は{@link BalloonVisibility#System}がデフォルト値として返されます。</p>
     *
     * @return 公開区分enum
     */
    public BalloonVisibility getVisibilityEnum() {
        return BalloonVisibility.fromValue(getVisibility()).orElse(BalloonVisibility.System);
    }

    /**
     * 風船タイプをenum型で設定します。
     *
     * <p>enum値を数値区分値に変換してデータベースに保存します。</p>
     *
     * @param balloonTypeEnum 設定する風船タイプenum
     */
    public void setBalloonTypeEnum(BalloonType balloonTypeEnum) {
        setBalloonType((short) balloonTypeEnum.getValue());
    }

    /**
     * 表示グループをenum型で設定します。
     *
     * <p>enum値を数値区分値に変換してデータベースに保存します。</p>
     *
     * @param displayGroupEnum 設定する表示グループenum
     */
    public void setDisplayGroupEnum(BalloonDisplayGroup displayGroupEnum) {
        setDisplayGroup((short) displayGroupEnum.getValue());
    }

    /**
     * 公開区分をenum型で設定します。
     *
     * <p>enum値を数値区分値に変換してデータベースに保存します。</p>
     *
     * @param visibilityEnum 設定する公開区分enum
     */
    public void setVisibilityEnum(BalloonVisibility visibilityEnum) {
        setVisibility((short) visibilityEnum.getValue());
    }
}
