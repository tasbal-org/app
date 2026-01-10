package com.tasbal.infrastructure.db.function.user;

import com.tasbal.infrastructure.db.common.BaseStoredFunction;
import com.tasbal.infrastructure.db.common.annotation.Parameter;
import com.tasbal.infrastructure.db.common.annotation.StoredFunction;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.OffsetDateTime;
import java.util.UUID;

/**
 * ユーザー設定を取得するストアドファンクション。
 *
 * <p>このファンクションは、指定されたユーザーIDに対応するユーザー設定を
 * データベースから取得します。ユーザー設定には以下の情報が含まれます:</p>
 *
 * <ul>
 *   <li>国コード (country_code)</li>
 *   <li>レンダリング品質 (render_quality): 1=AUTO, 2=NORMAL, 3=LOW</li>
 *   <li>自動低電力モードフラグ (auto_low_power)</li>
 *   <li>更新日時 (updated_at)</li>
 * </ul>
 *
 * <h2>対応するSQL</h2>
 * <p>このクラスは、PostgreSQLの{@code sp_get_user_settings}ファンクションに対応します:</p>
 *
 * <pre>{@code
 * CREATE OR REPLACE FUNCTION sp_get_user_settings(p_user_id UUID)
 * RETURNS TABLE(
 *     user_id UUID,
 *     country_code VARCHAR,
 *     render_quality SMALLINT,
 *     auto_low_power BOOLEAN,
 *     updated_at TIMESTAMPTZ
 * ) AS $$
 * BEGIN
 *     RETURN QUERY
 *     SELECT us.user_id, us.country_code, us.render_quality,
 *            us.auto_low_power, us.updated_at
 *     FROM user_settings us
 *     WHERE us.user_id = p_user_id;
 * END;
 * $$ LANGUAGE plpgsql;
 * }</pre>
 *
 * <h2>使用例</h2>
 *
 * <h3>ユーザー設定を取得:</h3>
 * <pre>{@code
 * GetUserSettingsFunction function = new GetUserSettingsFunction(userId);
 * GetUserSettingsFunction.Result result = executor.executeForSingle(function);
 *
 * if (result == null) {
 *     throw new UserSettingsNotFoundException("User settings not found: " + userId);
 * }
 *
 * System.out.println("Country: " + result.getCountryCode());
 * System.out.println("Render quality: " + result.getRenderQuality());
 * }</pre>
 *
 * <h3>設定を使用した処理:</h3>
 * <pre>{@code
 * GetUserSettingsFunction function = new GetUserSettingsFunction(userId);
 * GetUserSettingsFunction.Result settings = executor.executeForSingleRequired(function);
 *
 * // レンダリング品質に応じた処理
 * switch (settings.getRenderQuality()) {
 *     case 1: // AUTO
 *         applyAutoRenderSettings();
 *         break;
 *     case 2: // NORMAL
 *         applyNormalRenderSettings();
 *         break;
 *     case 3: // LOW
 *         applyLowRenderSettings();
 *         break;
 * }
 * }</pre>
 *
 * <h2>制約とバリデーション</h2>
 * <ul>
 *   <li>userIdは必須です（nullは許可されません）</li>
 *   <li>対応するuser_settingsレコードが存在しない場合は0行を返します</li>
 *   <li>render_qualityは1～3の値を取ります（1=AUTO, 2=NORMAL, 3=LOW）</li>
 * </ul>
 *
 * <h2>戻り値</h2>
 * <p>ユーザー設定が見つかった場合は1行を返します。
 * 設定が存在しない場合は0行を返します。</p>
 *
 * @author Tasbal Team
 * @since 1.0.0
 * @see com.tasbal.backend.domain.model.UserSettings
 * @see com.tasbal.backend.domain.repository.UserSettingsRepository#findByUserId(UUID)
 */
@StoredFunction("sp_get_user_settings")
public class GetUserSettingsFunction extends BaseStoredFunction<GetUserSettingsFunction.Result> {

    /**
     * 取得対象のユーザーID。
     */
    @Parameter("p_user_id")
    private UUID userId;

    /**
     * コンストラクタ。
     *
     * @param userId 取得対象のユーザーID
     * @throws IllegalArgumentException userIdがnullの場合
     */
    public GetUserSettingsFunction(UUID userId) {
        super(new ResultRowMapper());
        if (userId == null) {
            throw new IllegalArgumentException("userId must not be null");
        }
        this.userId = userId;
    }

    /**
     * ストアドファンクションの実行結果を表すクラス。
     *
     * <p>このクラスは、{@code sp_get_user_settings}ファンクションの
     * RETURNS TABLE定義に対応しています。</p>
     */
    public static class Result {
        private UUID userId;
        private String countryCode;
        private Short renderQuality;
        private Boolean autoLowPower;
        private OffsetDateTime updatedAt;

        /**
         * ユーザーIDを取得します。
         *
         * @return ユーザーID (UUID)
         */
        public UUID getUserId() {
            return userId;
        }

        /**
         * ユーザーIDを設定します。
         *
         * @param userId ユーザーID
         */
        public void setUserId(UUID userId) {
            this.userId = userId;
        }

        /**
         * 国コードを取得します。
         *
         * @return 国コード (例: "JP", "US")
         */
        public String getCountryCode() {
            return countryCode;
        }

        /**
         * 国コードを設定します。
         *
         * @param countryCode 国コード
         */
        public void setCountryCode(String countryCode) {
            this.countryCode = countryCode;
        }

        /**
         * レンダリング品質を取得します。
         *
         * @return レンダリング品質 (1=AUTO, 2=NORMAL, 3=LOW)
         */
        public Short getRenderQuality() {
            return renderQuality;
        }

        /**
         * レンダリング品質を設定します。
         *
         * @param renderQuality レンダリング品質
         */
        public void setRenderQuality(Short renderQuality) {
            this.renderQuality = renderQuality;
        }

        /**
         * 自動低電力モードフラグを取得します。
         *
         * @return 自動低電力モードが有効な場合true
         */
        public Boolean getAutoLowPower() {
            return autoLowPower;
        }

        /**
         * 自動低電力モードフラグを設定します。
         *
         * @param autoLowPower 自動低電力モードフラグ
         */
        public void setAutoLowPower(Boolean autoLowPower) {
            this.autoLowPower = autoLowPower;
        }

        /**
         * 更新日時を取得します。
         *
         * @return 更新日時
         */
        public OffsetDateTime getUpdatedAt() {
            return updatedAt;
        }

        /**
         * 更新日時を設定します。
         *
         * @param updatedAt 更新日時
         */
        public void setUpdatedAt(OffsetDateTime updatedAt) {
            this.updatedAt = updatedAt;
        }
    }

    /**
     * ResultSetから{@link Result}オブジェクトへのマッピングを行うRowMapper。
     *
     * <p>PostgreSQLのRETURNS TABLE定義に従って、各カラムを
     * Javaオブジェクトのプロパティにマッピングします。</p>
     */
    private static class ResultRowMapper implements RowMapper<Result> {

        /**
         * ResultSetの1行を{@link Result}オブジェクトにマッピングします。
         *
         * @param rs ResultSet
         * @param rowNum 行番号（0始まり）
         * @return マッピングされたResultオブジェクト
         * @throws SQLException ResultSetからのデータ取得に失敗した場合
         */
        @Override
        public Result mapRow(ResultSet rs, int rowNum) throws SQLException {
            Result result = new Result();
            result.setUserId((UUID) rs.getObject("user_id"));
            result.setCountryCode(rs.getString("country_code"));
            result.setRenderQuality(rs.getShort("render_quality"));
            result.setAutoLowPower(rs.getBoolean("auto_low_power"));
            result.setUpdatedAt(rs.getObject("updated_at", OffsetDateTime.class));
            return result;
        }
    }
}
