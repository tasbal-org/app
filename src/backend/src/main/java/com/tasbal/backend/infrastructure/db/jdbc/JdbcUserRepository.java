package com.tasbal.backend.infrastructure.db.jdbc;

import com.tasbal.backend.domain.model.User;
import com.tasbal.backend.domain.model.UserSettings;
import com.tasbal.backend.domain.repository.UserRepository;
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
public class JdbcUserRepository implements UserRepository {

    private static final String SELECT_FROM = "SELECT * FROM ";

    private final JdbcTemplate jdbcTemplate;

    public JdbcUserRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public User createGuest(String handle) {
        String sql;
        List<User> results;
        if (handle == null) {
            sql = SELECT_FROM + StoredProcedures.SP_CREATE_GUEST_USER + "()";
            results = jdbcTemplate.query(sql, userRowMapper());
        } else {
            sql = SELECT_FROM + StoredProcedures.SP_CREATE_GUEST_USER + "(?)";
            results = jdbcTemplate.query(sql, userRowMapper(), handle);
        }
        return results.isEmpty() ? null : results.get(0);
    }

    @Override
    public Optional<User> findById(UUID userId) {
        String sql = SELECT_FROM + StoredProcedures.SP_GET_USER_BY_ID + "(?)";
        List<User> results = jdbcTemplate.query(sql, userRowMapper(), userId);
        return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
    }

    @Override
    public Optional<UserSettings> findSettingsByUserId(UUID userId) {
        String sql = SELECT_FROM + StoredProcedures.SP_GET_USER_SETTINGS + "(?)";
        List<UserSettings> results = jdbcTemplate.query(sql, userSettingsRowMapper(), userId);
        return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
    }

    @Override
    public UserSettings updateSettings(UUID userId, String countryCode, Short renderQuality, Boolean autoLowPower) {
        String sql = SELECT_FROM + StoredProcedures.SP_UPDATE_USER_SETTINGS + "(?, ?, ?, ?)";
        List<UserSettings> results = jdbcTemplate.query(sql, userSettingsRowMapper(), userId, countryCode, renderQuality, autoLowPower);
        return results.isEmpty() ? null : results.get(0);
    }

    private RowMapper<User> userRowMapper() {
        return (rs, rowNum) -> new User(
                rs.getObject("id", UUID.class),
                rs.getString("handle"),
                rs.getShort("plan"),
                rs.getBoolean("is_guest"),
                rs.getShort("auth_state"),
                getOffsetDateTime(rs, "created_at"),
                getOffsetDateTime(rs, "updated_at"),
                getOffsetDateTime(rs, "last_login_at"),
                getOffsetDateTime(rs, "deleted_at")
        );
    }

    private RowMapper<UserSettings> userSettingsRowMapper() {
        return (rs, rowNum) -> new UserSettings(
                rs.getObject("user_id", UUID.class),
                rs.getString("country_code"),
                rs.getShort("render_quality"),
                rs.getBoolean("auto_low_power"),
                getOffsetDateTime(rs, "updated_at")
        );
    }

    private OffsetDateTime getOffsetDateTime(ResultSet rs, String columnName) throws SQLException {
        Timestamp timestamp = rs.getTimestamp(columnName);
        return timestamp != null ? OffsetDateTime.ofInstant(timestamp.toInstant(), java.time.ZoneOffset.UTC) : null;
    }
}
