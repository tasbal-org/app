package com.tasbal.infrastructure.db.procedure.task;

import com.tasbal.infrastructure.db.common.BaseStoredProcedure;
import com.tasbal.infrastructure.db.common.annotation.Parameter;
import com.tasbal.infrastructure.db.common.annotation.StoredProcedure;
import org.springframework.jdbc.core.RowMapper;

import java.time.OffsetDateTime;
import java.util.UUID;

/**
 * タスク更新ストアドプロシージャ {@code sp_update_task} の呼び出しクラス。
 *
 * <p>このクラスは既存のタスクの情報を更新します。
 * タイトル、メモ、期限日時、ピン留めフラグを更新できます。</p>
 *
 * @author Tasbal Team
 * @since 1.0.0
 */
@StoredProcedure("sp_update_task")
public class UpdateTaskProcedure extends BaseStoredProcedure<UpdateTaskProcedure.Result> {

    /** タスクID */
    @Parameter("p_task_id")
    private UUID taskId;

    /** ユーザーID */
    @Parameter("p_user_id")
    private UUID userId;

    /** タスクのタイトル */
    @Parameter("p_title")
    private String title;

    /** タスクのメモ */
    @Parameter("p_memo")
    private String memo;

    /** タスクの期限日時 */
    @Parameter("p_due_at")
    private OffsetDateTime dueAt;

    /** ピン留めフラグ */
    @Parameter("p_pinned")
    private Boolean pinned;

    /**
     * コンストラクタ。
     *
     * @param taskId タスクID
     * @param userId ユーザーID
     * @param title タスクのタイトル
     * @param memo タスクのメモ
     * @param dueAt タスクの期限日時
     * @param pinned ピン留めフラグ
     */
    public UpdateTaskProcedure(UUID taskId, UUID userId, String title, String memo,
                               OffsetDateTime dueAt, Boolean pinned) {
        super(new ResultRowMapper());
        this.taskId = taskId;
        this.userId = userId;
        this.title = title;
        this.memo = memo;
        this.dueAt = dueAt;
        this.pinned = pinned;
    }

    /**
     * ストアドプロシージャの戻り値を表すクラス。
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

        /** タスクのステータス */
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

        /** 削除日時 */
        private OffsetDateTime deletedAt;

        public UUID getId() { return id; }
        public void setId(UUID id) { this.id = id; }
        public UUID getUserId() { return userId; }
        public void setUserId(UUID userId) { this.userId = userId; }
        public String getTitle() { return title; }
        public void setTitle(String title) { this.title = title; }
        public String getMemo() { return memo; }
        public void setMemo(String memo) { this.memo = memo; }
        public OffsetDateTime getDueAt() { return dueAt; }
        public void setDueAt(OffsetDateTime dueAt) { this.dueAt = dueAt; }
        public Short getStatus() { return status; }
        public void setStatus(Short status) { this.status = status; }
        public Boolean getPinned() { return pinned; }
        public void setPinned(Boolean pinned) { this.pinned = pinned; }
        public OffsetDateTime getCompletedAt() { return completedAt; }
        public void setCompletedAt(OffsetDateTime completedAt) { this.completedAt = completedAt; }
        public OffsetDateTime getArchivedAt() { return archivedAt; }
        public void setArchivedAt(OffsetDateTime archivedAt) { this.archivedAt = archivedAt; }
        public OffsetDateTime getCreatedAt() { return createdAt; }
        public void setCreatedAt(OffsetDateTime createdAt) { this.createdAt = createdAt; }
        public OffsetDateTime getUpdatedAt() { return updatedAt; }
        public void setUpdatedAt(OffsetDateTime updatedAt) { this.updatedAt = updatedAt; }
        public OffsetDateTime getDeletedAt() { return deletedAt; }
        public void setDeletedAt(OffsetDateTime deletedAt) { this.deletedAt = deletedAt; }
    }

    /**
     * ResultSetから Result へのマッピングを行う RowMapper。
     */
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
