package com.tasbal.backend.infrastructure.db.jdbc;

import com.tasbal.backend.domain.model.Task;
import com.tasbal.backend.domain.repository.TaskRepository;
import com.tasbal.backend.infrastructure.db.stored.StoredProcedures;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.Array;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.OffsetDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public class JdbcTaskRepository implements TaskRepository {

    private static final String SELECT_FROM = "SELECT * FROM ";

    private final JdbcTemplate jdbcTemplate;

    public JdbcTaskRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public Task create(UUID userId, String title, String memo, OffsetDateTime dueAt) {
        String sql = SELECT_FROM + StoredProcedures.SP_CREATE_TASK + "(?, ?, ?, ?)";
        List<Task> results = jdbcTemplate.query(sql, taskRowMapper(), userId, title, memo,
                dueAt != null ? Timestamp.from(dueAt.toInstant()) : null);
        return results.isEmpty() ? null : results.get(0);
    }

    @Override
    public List<Task> findByUserId(UUID userId, int limit, int offset) {
        String sql = SELECT_FROM + StoredProcedures.SP_GET_TASKS + "(?, ?, ?)";
        return jdbcTemplate.query(sql, taskWithTagsRowMapper(), userId, limit, offset);
    }

    @Override
    public Optional<Task> findById(UUID taskId, UUID userId) {
        String sql = SELECT_FROM + StoredProcedures.SP_GET_TASK_BY_ID + "(?, ?)";
        List<Task> results = jdbcTemplate.query(sql, taskWithTagsRowMapper(), taskId, userId);
        return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
    }

    @Override
    public Task update(UUID taskId, UUID userId, String title, String memo, OffsetDateTime dueAt, Boolean pinned) {
        String sql = SELECT_FROM + StoredProcedures.SP_UPDATE_TASK + "(?, ?, ?, ?, ?, ?)";
        List<Task> results = jdbcTemplate.query(sql, taskRowMapper(), taskId, userId, title, memo,
                dueAt != null ? Timestamp.from(dueAt.toInstant()) : null, pinned);
        return results.isEmpty() ? null : results.get(0);
    }

    @Override
    public Task toggleCompletion(UUID taskId, UUID userId, boolean isDone) {
        String sql = SELECT_FROM + StoredProcedures.SP_TOGGLE_TASK_COMPLETION + "(?, ?, ?)";
        List<Task> results = jdbcTemplate.query(sql, taskToggleRowMapper(), taskId, userId, isDone);
        return results.isEmpty() ? null : results.get(0);
    }

    @Override
    public void delete(UUID taskId, UUID userId) {
        String sql = SELECT_FROM + StoredProcedures.SP_DELETE_TASK + "(?, ?)";
        jdbcTemplate.query(sql, (rs, rowNum) -> rs.getObject("id", UUID.class), taskId, userId);
    }

    private RowMapper<Task> taskRowMapper() {
        return (rs, rowNum) -> new Task(
                rs.getObject("id", UUID.class),
                rs.getObject("user_id", UUID.class),
                rs.getString("title"),
                rs.getString("memo"),
                getOffsetDateTime(rs, "due_at"),
                rs.getShort("status"),
                rs.getBoolean("pinned"),
                getOffsetDateTime(rs, "completed_at"),
                getOffsetDateTime(rs, "archived_at"),
                getOffsetDateTime(rs, "created_at"),
                getOffsetDateTime(rs, "updated_at"),
                getOffsetDateTime(rs, "deleted_at"),
                null
        );
    }

    private RowMapper<Task> taskWithTagsRowMapper() {
        return (rs, rowNum) -> {
            Task task = taskRowMapper().mapRow(rs, rowNum);
            if (task != null) {
                Array tagIdsArray = rs.getArray("tag_ids");
                if (tagIdsArray != null) {
                    UUID[] tagIds = (UUID[]) tagIdsArray.getArray();
                    task.setTagIds(Arrays.asList(tagIds));
                }
            }
            return task;
        };
    }

    private RowMapper<Task> taskToggleRowMapper() {
        return (rs, rowNum) -> {
            Task task = taskRowMapper().mapRow(rs, rowNum);
            if (task != null) {
                // popped_balloon_ids は別途処理可能だが、今はタスク情報のみ返す
            }
            return task;
        };
    }

    private OffsetDateTime getOffsetDateTime(ResultSet rs, String columnName) throws SQLException {
        Timestamp timestamp = rs.getTimestamp(columnName);
        return timestamp != null ? OffsetDateTime.ofInstant(timestamp.toInstant(), java.time.ZoneOffset.UTC) : null;
    }
}
