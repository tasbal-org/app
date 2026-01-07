package com.tasbal.backend.infrastructure.db.stored.balloon;

import com.tasbal.backend.infrastructure.db.stored.BaseStoredProcedure;
import com.tasbal.backend.infrastructure.db.stored.annotation.Parameter;
import com.tasbal.backend.infrastructure.db.stored.annotation.StoredProcedure;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import java.time.OffsetDateTime;
import java.util.UUID;

@StoredProcedure("sp_create_balloon")
public class CreateBalloonProcedure extends BaseStoredProcedure<CreateBalloonProcedure.Result> {

    @Parameter("p_owner_user_id")
    private UUID ownerUserId;

    @Parameter("p_title")
    private String title;

    @Parameter("p_description")
    private String description;

    @Parameter("p_color_id")
    private Short colorId;

    @Parameter("p_tag_icon_id")
    private Short tagIconId;

    @Parameter("p_is_public")
    private Boolean isPublic;

    public CreateBalloonProcedure(
            UUID ownerUserId,
            String title,
            String description,
            Short colorId,
            Short tagIconId,
            Boolean isPublic) {
        super(new ResultRowMapper());
        this.ownerUserId = ownerUserId;
        this.title = title;
        this.description = description;
        this.colorId = colorId;
        this.tagIconId = tagIconId;
        this.isPublic = isPublic;
    }

    public static class Result {
        private UUID id;
        private Short balloonType;
        private Short displayGroup;
        private Short visibility;
        private UUID ownerUserId;
        private String title;
        private String description;
        private Short colorId;
        private Short tagIconId;
        private String countryCode;
        private Boolean isActive;
        private OffsetDateTime createdAt;
        private OffsetDateTime updatedAt;

        public UUID getId() { return id; }
        public void setId(UUID id) { this.id = id; }
        public Short getBalloonType() { return balloonType; }
        public void setBalloonType(Short balloonType) { this.balloonType = balloonType; }
        public Short getDisplayGroup() { return displayGroup; }
        public void setDisplayGroup(Short displayGroup) { this.displayGroup = displayGroup; }
        public Short getVisibility() { return visibility; }
        public void setVisibility(Short visibility) { this.visibility = visibility; }
        public UUID getOwnerUserId() { return ownerUserId; }
        public void setOwnerUserId(UUID ownerUserId) { this.ownerUserId = ownerUserId; }
        public String getTitle() { return title; }
        public void setTitle(String title) { this.title = title; }
        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
        public Short getColorId() { return colorId; }
        public void setColorId(Short colorId) { this.colorId = colorId; }
        public Short getTagIconId() { return tagIconId; }
        public void setTagIconId(Short tagIconId) { this.tagIconId = tagIconId; }
        public String getCountryCode() { return countryCode; }
        public void setCountryCode(String countryCode) { this.countryCode = countryCode; }
        public Boolean getIsActive() { return isActive; }
        public void setIsActive(Boolean isActive) { this.isActive = isActive; }
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
            result.setBalloonType(rs.getShort("balloon_type"));
            result.setDisplayGroup(rs.getShort("display_group"));
            result.setVisibility(rs.getShort("visibility"));
            result.setOwnerUserId((UUID) rs.getObject("owner_user_id"));
            result.setTitle(rs.getString("title"));
            result.setDescription(rs.getString("description"));
            result.setColorId(rs.getShort("color_id"));
            result.setTagIconId(rs.getShort("tag_icon_id"));
            result.setCountryCode(rs.getString("country_code"));
            result.setIsActive(rs.getBoolean("is_active"));
            result.setCreatedAt(rs.getObject("created_at", OffsetDateTime.class));
            result.setUpdatedAt(rs.getObject("updated_at", OffsetDateTime.class));
            return result;
        }
    }
}
