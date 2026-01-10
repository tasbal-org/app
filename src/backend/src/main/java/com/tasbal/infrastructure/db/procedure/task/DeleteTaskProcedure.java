package com.tasbal.infrastructure.db.procedure.task;

import com.tasbal.infrastructure.db.common.BaseStoredProcedure;
import com.tasbal.infrastructure.db.common.annotation.Parameter;
import com.tasbal.infrastructure.db.common.annotation.StoredProcedure;
import org.springframework.jdbc.core.RowMapper;

import java.util.UUID;

/**
 * タスク削除ストアドプロシージャ {@code sp_delete_task} の呼び出しクラス。
 *
 * <p>このクラスはタスクを論理削除します。
 * 物理削除ではなく、削除日時が設定されることで論理削除されます。</p>
 *
 * @author Tasbal Team
 * @since 1.0.0
 */
@StoredProcedure("sp_delete_task")
public class DeleteTaskProcedure extends BaseStoredProcedure<DeleteTaskProcedure.Result> {

    /** タスクID */
    @Parameter("p_task_id")
    private UUID taskId;

    /** ユーザーID */
    @Parameter("p_user_id")
    private UUID userId;

    /**
     * コンストラクタ。
     *
     * @param taskId タスクID
     * @param userId ユーザーID
     */
    public DeleteTaskProcedure(UUID taskId, UUID userId) {
        super(new ResultRowMapper());
        this.taskId = taskId;
        this.userId = userId;
    }

    /**
     * ストアドプロシージャの戻り値を表すクラス。
     */
    public static class Result {
        /** 削除成功フラグ */
        private Boolean success;

        public Boolean getSuccess() { return success; }
        public void setSuccess(Boolean success) { this.success = success; }
    }

    /**
     * ResultSetから Result へのマッピングを行う RowMapper。
     */
    private static class ResultRowMapper implements RowMapper<Result> {
        @Override
        public Result mapRow(java.sql.ResultSet rs, int rowNum) throws java.sql.SQLException {
            Result result = new Result();
            result.setSuccess(rs.getBoolean("success"));
            return result;
        }
    }
}
