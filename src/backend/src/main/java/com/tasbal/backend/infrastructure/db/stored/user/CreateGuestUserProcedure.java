package com.tasbal.backend.infrastructure.db.stored.user;

import com.tasbal.backend.infrastructure.db.stored.BaseStoredProcedure;
import com.tasbal.backend.infrastructure.db.stored.annotation.Parameter;
import com.tasbal.backend.infrastructure.db.stored.annotation.StoredProcedure;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import java.time.OffsetDateTime;
import java.util.UUID;

@StoredProcedure("sp_create_guest_user")
public class CreateGuestUserProcedure extends BaseStoredProcedure<CreateGuestUserProcedure.Result> {

    @Parameter("p_handle")
    private String handle;

    public CreateGuestUserProcedure(String handle) {
        super(new ResultRowMapper());
        this.handle = handle;
    }

    public static class Result {
        private UUID id;
        private String handle;
        private Short plan;
        private Boolean isGuest;
        private Short authState;
        private OffsetDateTime createdAt;
        private OffsetDateTime updatedAt;

        public UUID getId() { return id; }
        public void setId(UUID id) { this.id = id; }
        public String getHandle() { return handle; }
        public void setHandle(String handle) { this.handle = handle; }
        public Short getPlan() { return plan; }
        public void setPlan(Short plan) { this.plan = plan; }
        public Boolean getIsGuest() { return isGuest; }
        public void setIsGuest(Boolean isGuest) { this.isGuest = isGuest; }
        public Short getAuthState() { return authState; }
        public void setAuthState(Short authState) { this.authState = authState; }
        public OffsetDateTime getCreatedAt() { return createdAt; }
        public void setCreatedAt(OffsetDateTime createdAt) { this.createdAt = createdAt; }
        public OffsetDateTime getUpdatedAt() { return updatedAt; }
        public void setUpdatedAt(OffsetDateTime updatedAt) { this.updatedAt = updatedAt; }
    }

    private static class ResultRowMapper implements RowMapper<Result> {
        @Override
        public Result mapRow(java.sql.ResultSet rs, int rowNum) throws java.sql.SQLException {
            Result result = new Result();
            result.setId((UUID) rs.getObject("id"));
            result.setHandle(rs.getString("handle"));
            result.setPlan(rs.getShort("plan"));
            result.setIsGuest(rs.getBoolean("is_guest"));
            result.setAuthState(rs.getShort("auth_state"));
            result.setCreatedAt(rs.getObject("created_at", OffsetDateTime.class));
            result.setUpdatedAt(rs.getObject("updated_at", OffsetDateTime.class));
            return result;
        }
    }
}
