package com.tasbal.infrastructure.db.procedure.task;

import com.tasbal.infrastructure.db.common.BaseStoredProcedure;
import com.tasbal.infrastructure.db.common.annotation.Parameter;
import com.tasbal.infrastructure.db.common.annotation.StoredProcedure;
import org.springframework.jdbc.core.RowMapper;

import java.time.OffsetDateTime;
import java.util.UUID;

/**
 * タスク作成ストアドプロシージャ {@code sp_create_task} の呼び出しクラス。
 *
 * <p>新しいタスクをデータベースに登録し、作成されたタスク情報を返します。</p>
 *
 * <h3>使用例:</h3>
 * <pre>{@code
 * CreateTaskProcedure procedure = new CreateTaskProcedure(
 *     userId,
 *     "散歩する",
 *     "10分だけでもOK",
 *     OffsetDateTime.now().plusDays(1)
 * );
 * CreateTaskProcedure.Result result = executor.executeForSingleRequired(procedure);
 * }</pre>
 *
 * @author Tasbal Team
 * @since 1.0.0
 * @see com.tasbal.backend.infrastructure.db.stored.StoredProcedureExecutor
 */
@StoredProcedure("sp_create_task")
public class CreateTaskProcedure extends BaseStoredProcedure<CreateTaskProcedure.Result> {

    /**
     * ユーザーID。
     */
    @Parameter("p_user_id")
    private UUID userId;

    /**
     * タスクのタイトル。
     */
    @Parameter("p_title")
    private String title;

    /**
     * タスクのメモ。
     */
    @Parameter("p_memo")
    private String memo;

    /**
     * タスクの期限日時。
     */
    @Parameter("p_due_at")
    private OffsetDateTime dueAt;

    /**
     * コンストラクタ。
     *
     * @param userId ユーザーID
     * @param title タスクのタイトル
     * @param memo タスクのメモ
     * @param dueAt タスクの期限日時
     */
    public CreateTaskProcedure(UUID userId, String title, String memo, OffsetDateTime dueAt) {
        super(new ResultRowMapper());
        this.userId = userId;
        this.title = title;
        this.memo = memo;
        this.dueAt = dueAt;
    }

    /**
     * {@code sp_create_task} ストアドプロシージャの戻り値を表すクラス。
     *
     * <p>作成されたタスクのすべての情報を保持します。</p>
     */
    public static class Result {
        /** タスクID */
        private UUID id;

        /** ユーザーID */
        private UUID userId;

        /** タスクのタイトル */
        private String title;

        /** タスクのメモ */
        private String memo;

        /** タスクの期限日時 */
        private OffsetDateTime dueAt;

        /** タスクのステータス（1:TODO, 2:IN_PROGRESS, 3:DONE） */
        private Short status;

        /** ピン留めフラグ */
        private Boolean pinned;

        /** 完了日時 */
        private OffsetDateTime completedAt;

        /** アーカイブ日時 */
        private OffsetDateTime archivedAt;

        /** 作成日時 */
        private OffsetDateTime createdAt;

        /** 更新日時 */
        private OffsetDateTime updatedAt;

        /** 削除日時（論理削除） */
        private OffsetDateTime deletedAt;

        /** @return タスクID */
        public UUID getId() { return id; }
        /** @param id タスクID */
        public void setId(UUID id) { this.id = id; }

        /** @return ユーザーID */
        public UUID getUserId() { return userId; }
        /** @param userId ユーザーID */
        public void setUserId(UUID userId) { this.userId = userId; }

        /** @return タスクのタイトル */
        public String getTitle() { return title; }
        /** @param title タスクのタイトル */
        public void setTitle(String title) { this.title = title; }

        /** @return タスクのメモ */
        public String getMemo() { return memo; }
        /** @param memo タスクのメモ */
        public void setMemo(String memo) { this.memo = memo; }

        /** @return タスクの期限日時 */
        public OffsetDateTime getDueAt() { return dueAt; }
        /** @param dueAt タスクの期限日時 */
        public void setDueAt(OffsetDateTime dueAt) { this.dueAt = dueAt; }

        /** @return タスクのステータス */
        public Short getStatus() { return status; }
        /** @param status タスクのステータス */
        public void setStatus(Short status) { this.status = status; }

        /** @return ピン留めフラグ */
        public Boolean getPinned() { return pinned; }
        /** @param pinned ピン留めフラグ */
        public void setPinned(Boolean pinned) { this.pinned = pinned; }

        /** @return 完了日時 */
        public OffsetDateTime getCompletedAt() { return completedAt; }
        /** @param completedAt 完了日時 */
        public void setCompletedAt(OffsetDateTime completedAt) { this.completedAt = completedAt; }

        /** @return アーカイブ日時 */
        public OffsetDateTime getArchivedAt() { return archivedAt; }
        /** @param archivedAt アーカイブ日時 */
        public void setArchivedAt(OffsetDateTime archivedAt) { this.archivedAt = archivedAt; }

        /** @return 作成日時 */
        public OffsetDateTime getCreatedAt() { return createdAt; }
        /** @param createdAt 作成日時 */
        public void setCreatedAt(OffsetDateTime createdAt) { this.createdAt = createdAt; }

        /** @return 更新日時 */
        public OffsetDateTime getUpdatedAt() { return updatedAt; }
        /** @param updatedAt 更新日時 */
        public void setUpdatedAt(OffsetDateTime updatedAt) { this.updatedAt = updatedAt; }

        /** @return 削除日時 */
        public OffsetDateTime getDeletedAt() { return deletedAt; }
        /** @param deletedAt 削除日時 */
        public void setDeletedAt(OffsetDateTime deletedAt) { this.deletedAt = deletedAt; }
    }

    private static class ResultRowMapper implements RowMapper<Result> {
        @Override
        public Result mapRow(java.sql.ResultSet rs, int rowNum) throws java.sql.SQLException {
            Result result = new Result();
            result.setId((UUID) rs.getObject("id"));
            result.setUserId((UUID) rs.getObject("user_id"));
            result.setTitle(rs.getString("title"));
            result.setMemo(rs.getString("memo"));
            result.setDueAt(rs.getObject("due_at", OffsetDateTime.class));
            result.setStatus(rs.getShort("status"));
            result.setPinned(rs.getBoolean("pinned"));
            result.setCompletedAt(rs.getObject("completed_at", OffsetDateTime.class));
            result.setArchivedAt(rs.getObject("archived_at", OffsetDateTime.class));
            result.setCreatedAt(rs.getObject("created_at", OffsetDateTime.class));
            result.setUpdatedAt(rs.getObject("updated_at", OffsetDateTime.class));
            result.setDeletedAt(rs.getObject("deleted_at", OffsetDateTime.class));
            return result;
        }
    }
}
