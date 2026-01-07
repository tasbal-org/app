package com.tasbal.backend.domain.repository;

import com.tasbal.backend.domain.model.Task;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface TaskRepository {
    Task create(UUID userId, String title, String memo, OffsetDateTime dueAt);

    List<Task> findByUserId(UUID userId, int limit, int offset);

    Optional<Task> findById(UUID taskId, UUID userId);

    Task update(UUID taskId, UUID userId, String title, String memo, OffsetDateTime dueAt, Boolean pinned);

    Task toggleCompletion(UUID taskId, UUID userId, boolean isDone);

    void delete(UUID taskId, UUID userId);
}
