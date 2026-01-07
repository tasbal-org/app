package com.tasbal.backend.application.service;

import com.tasbal.backend.domain.model.Task;
import com.tasbal.backend.domain.repository.TaskRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.UUID;

@Service
@Transactional
public class TaskService {

    private final TaskRepository taskRepository;

    public TaskService(TaskRepository taskRepository) {
        this.taskRepository = taskRepository;
    }

    public Task createTask(UUID userId, String title, String memo, OffsetDateTime dueAt) {
        return taskRepository.create(userId, title, memo, dueAt);
    }

    public List<Task> getTasks(UUID userId, int limit, int offset) {
        return taskRepository.findByUserId(userId, limit, offset);
    }

    public Task getTaskById(UUID taskId, UUID userId) {
        return taskRepository.findById(taskId, userId)
                .orElseThrow(() -> new RuntimeException("Task not found"));
    }

    public Task updateTask(UUID taskId, UUID userId, String title, String memo, OffsetDateTime dueAt, Boolean pinned) {
        return taskRepository.update(taskId, userId, title, memo, dueAt, pinned);
    }

    public Task toggleTaskCompletion(UUID taskId, UUID userId, boolean isDone) {
        return taskRepository.toggleCompletion(taskId, userId, isDone);
    }

    public void deleteTask(UUID taskId, UUID userId) {
        taskRepository.delete(taskId, userId);
    }
}
