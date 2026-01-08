package com.tasbal.backend.infrastructure.db.procedure.user;

import com.tasbal.backend.infrastructure.db.common.BaseStoredProcedure;
import com.tasbal.backend.infrastructure.db.common.annotation.Parameter;
import com.tasbal.backend.infrastructure.db.common.annotation.StoredProcedure;
import org.springframework.jdbc.core.RowMapper;

import java.time.OffsetDateTime;
import java.util.UUID;

/**
 * ユーザー設定更新ストアドプロシージャ {@code sp_update_user_settings} の呼び出しクラス。
 *
 * <p>このクラスはユーザーの設定情報を更新します。
 * 国コード、レンダリング品質、自動低電力モードフラグを更新できます。</p>
 *
 * @author Tasbal Team
 * @since 1.0.0
 */
@StoredProcedure("sp_update_user_settings")
public class UpdateUserSettingsProcedure extends BaseStoredProcedure<UpdateUserSettingsProcedure.Result> {

    /** ユーザーID */
    @Parameter("p_user_id")
    private UUID userId;

    /** 国コード */
    @Parameter("p_country_code")
    private String countryCode;

    /** レンダリング品質（1:AUTO 2:NORMAL 3:LOW） */
    @Parameter("p_render_quality")
    private Short renderQuality;

    /** 自動低電力モードフラグ */
    @Parameter("p_auto_low_power")
    private Boolean autoLowPower;

    /**
     * コンストラクタ。
     *
     * @param userId ユーザーID
     * @param countryCode 国コード
     * @param renderQuality レンダリング品質（1:AUTO 2:NORMAL 3:LOW）
     * @param autoLowPower 自動低電力モードフラグ
     */
    public UpdateUserSettingsProcedure(UUID userId, String countryCode, Short renderQuality,
                                       Boolean autoLowPower) {
        super(new ResultRowMapper());
        this.userId = userId;
        this.countryCode = countryCode;
        this.renderQuality = renderQuality;
        this.autoLowPower = autoLowPower;
    }

    /**
     * ストアドプロシージャの戻り値を表すクラス。
     */
    public static class Result {
        /** ユーザーID */
        private UUID userId;

        /** 国コード */
        private String countryCode;

        /** レンダリング品質（1:AUTO 2:NORMAL 3:LOW） */
        private Short renderQuality;

        /** 自動低電力モードフラグ */
        private Boolean autoLowPower;

        /** 更新日時 */
        private OffsetDateTime updatedAt;

        public UUID getUserId() { return userId; }
        public void setUserId(UUID userId) { this.userId = userId; }
        public String getCountryCode() { return countryCode; }
        public void setCountryCode(String countryCode) { this.countryCode = countryCode; }
        public Short getRenderQuality() { return renderQuality; }
        public void setRenderQuality(Short renderQuality) { this.renderQuality = renderQuality; }
        public Boolean getAutoLowPower() { return autoLowPower; }
        public void setAutoLowPower(Boolean autoLowPower) { this.autoLowPower = autoLowPower; }
        public OffsetDateTime getUpdatedAt() { return updatedAt; }
        public void setUpdatedAt(OffsetDateTime updatedAt) { this.updatedAt = updatedAt; }
    }

    /**
     * ResultSetから Result へのマッピングを行う RowMapper。
     */
    private static class ResultRowMapper implements RowMapper<Result> {
        @Override
        public Result mapRow(java.sql.ResultSet rs, int rowNum) throws java.sql.SQLException {
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
