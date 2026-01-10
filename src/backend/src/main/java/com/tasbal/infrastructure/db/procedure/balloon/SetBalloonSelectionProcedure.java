package com.tasbal.infrastructure.db.procedure.balloon;

import com.tasbal.infrastructure.db.common.BaseStoredProcedure;
import com.tasbal.infrastructure.db.common.annotation.Parameter;
import com.tasbal.infrastructure.db.common.annotation.StoredProcedure;
import org.springframework.jdbc.core.RowMapper;

import java.util.UUID;

/**
 * バルーン選択設定ストアドプロシージャ {@code sp_set_balloon_selection} の呼び出しクラス。
 *
 * <p>このクラスはユーザーが選択するバルーンを設定します。</p>
 *
 * @author Tasbal Team
 * @since 1.0.0
 */
@StoredProcedure("sp_set_balloon_selection")
public class SetBalloonSelectionProcedure extends BaseStoredProcedure<SetBalloonSelectionProcedure.Result> {

    /** ユーザーID */
    @Parameter("p_user_id")
    private UUID userId;

    /** バルーンID */
    @Parameter("p_balloon_id")
    private UUID balloonId;

    /**
     * コンストラクタ。
     *
     * @param userId ユーザーID
     * @param balloonId バルーンID
     */
    public SetBalloonSelectionProcedure(UUID userId, UUID balloonId) {
        super(new ResultRowMapper());
        this.userId = userId;
        this.balloonId = balloonId;
    }

    /**
     * ストアドプロシージャの戻り値を表すクラス。
     */
    public static class Result {
        /** バルーンID（設定確認用） */
        private UUID balloonId;

        public UUID getBalloonId() { return balloonId; }
        public void setBalloonId(UUID balloonId) { this.balloonId = balloonId; }
    }

    /**
     * ResultSetから Result へのマッピングを行う RowMapper。
     */
    private static class ResultRowMapper implements RowMapper<Result> {
        @Override
        public Result mapRow(java.sql.ResultSet rs, int rowNum) throws java.sql.SQLException {
            Result result = new Result();
            result.setBalloonId((UUID) rs.getObject("balloon_id"));
            return result;
        }
    }
}
