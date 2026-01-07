package com.tasbal.backend.infrastructure.db.jdbc;

import com.tasbal.backend.domain.model.Balloon;
import com.tasbal.backend.domain.repository.BalloonRepository;
import com.tasbal.backend.infrastructure.db.stored.StoredProcedures;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public class JdbcBalloonRepository implements BalloonRepository {

    private static final String SELECT_FROM = "SELECT * FROM ";

    private final JdbcTemplate jdbcTemplate;

    public JdbcBalloonRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public Balloon create(UUID ownerUserId, String title, String description, Short colorId, Short tagIconId, Boolean isPublic) {
        String sql = SELECT_FROM + StoredProcedures.SP_CREATE_BALLOON + "(?, ?, ?, ?, ?, ?)";
        List<Balloon> results = jdbcTemplate.query(sql, balloonRowMapper(), ownerUserId, title, description, colorId, tagIconId, isPublic);
        return results.isEmpty() ? null : results.get(0);
    }

    @Override
    public List<Balloon> findPublicBalloons(int limit, int offset) {
        String sql = SELECT_FROM + StoredProcedures.SP_GET_PUBLIC_BALLOONS + "(?, ?)";
        return jdbcTemplate.query(sql, balloonRowMapper(), limit, offset);
    }

    @Override
    public Optional<UUID> findSelectedBalloon(UUID userId) {
        String sql = SELECT_FROM + StoredProcedures.SP_GET_BALLOON_SELECTION + "(?)";
        List<UUID> results = jdbcTemplate.query(sql, (rs, rowNum) -> rs.getObject("balloon_id", UUID.class), userId);
        return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
    }

    @Override
    public void setSelection(UUID userId, UUID balloonId) {
        String sql = SELECT_FROM + StoredProcedures.SP_SET_BALLOON_SELECTION + "(?, ?)";
        jdbcTemplate.query(sql, (rs, rowNum) -> rs.getObject("balloon_id", UUID.class), userId, balloonId);
    }

    private RowMapper<Balloon> balloonRowMapper() {
        return (rs, rowNum) -> new Balloon(
                rs.getObject("id", UUID.class),
                rs.getShort("balloon_type"),
                rs.getShort("display_group"),
                rs.getShort("visibility"),
                rs.getObject("owner_user_id", UUID.class),
                rs.getString("title"),
                rs.getString("description"),
                getShortOrNull(rs, "color_id"),
                getShortOrNull(rs, "tag_icon_id"),
                rs.getString("country_code"),
                rs.getBoolean("is_active"),
                getOffsetDateTime(rs, "created_at"),
                getOffsetDateTime(rs, "updated_at")
        );
    }

    private Short getShortOrNull(ResultSet rs, String columnName) throws SQLException {
        short value = rs.getShort(columnName);
        return rs.wasNull() ? null : value;
    }

    private OffsetDateTime getOffsetDateTime(ResultSet rs, String columnName) throws SQLException {
        Timestamp timestamp = rs.getTimestamp(columnName);
        return timestamp != null ? OffsetDateTime.ofInstant(timestamp.toInstant(), java.time.ZoneOffset.UTC) : null;
    }
}
