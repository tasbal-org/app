package com.tasbal.backend.infrastructure.db.stored.task;

import com.tasbal.backend.infrastructure.db.stored.BaseStoredProcedure;
import com.tasbal.backend.infrastructure.db.stored.annotation.Parameter;
import com.tasbal.backend.infrastructure.db.stored.annotation.StoredProcedure;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import java.time.OffsetDateTime;
import java.util.UUID;

@StoredProcedure("sp_get_tasks")
public class GetTasksProcedure extends BaseStoredProcedure<GetTasksProcedure.Result> {

    @Parameter("p_user_id")
    private UUID userId;

    @Parameter("p_limit")
    private Integer limit;

    @Parameter("p_offset")
    private Integer offset;

    public GetTasksProcedure(UUID userId, Integer limit, Integer offset) {
        super(new ResultRowMapper());
        this.userId = userId;
        this.limit = limit;
        this.offset = offset;
    }

    public static class Result {
        private UUID id;
        private UUID userId;
        private String title;
        private String memo;
        private OffsetDateTime dueAt;
        private Short status;
        private Boolean pinned;
        private OffsetDateTime completedAt;
        private OffsetDateTime archivedAt;
        private OffsetDateTime createdAt;
        private OffsetDateTime updatedAt;
        private OffsetDateTime deletedAt;
        private UUID[] tagIds;

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
        public UUID[] getTagIds() { return tagIds; }
        public void setTagIds(UUID[] tagIds) { this.tagIds = tagIds; }
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

            java.sql.Array tagIdsArray = rs.getArray("tag_ids");
            if (tagIdsArray != null) {
                result.setTagIds((UUID[]) tagIdsArray.getArray());
            }

            return result;
        }
    }
}
