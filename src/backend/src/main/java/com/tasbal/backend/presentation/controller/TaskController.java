package com.tasbal.backend.presentation.controller;

import com.tasbal.backend.application.service.TaskService;
import com.tasbal.backend.domain.model.Task;
import com.tasbal.backend.presentation.dto.TaskRequest;
import com.tasbal.backend.presentation.dto.TaskResponse;
import com.tasbal.backend.presentation.dto.ToggleDoneRequest;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/v1/tasks")
@Tag(name = "Tasks", description = "タスク管理API")
public class TaskController {

    private final TaskService taskService;

    public TaskController(TaskService taskService) {
        this.taskService = taskService;
    }

    @PostMapping
    @Operation(summary = "タスクを作成", description = "新しいタスクを作成します")
    public ResponseEntity<TaskResponse> createTask(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") UUID userId,
            @Valid @RequestBody TaskRequest request) {
        Task task = taskService.createTask(userId, request.getTitle(), request.getMemo(), request.getDueAt());
        return ResponseEntity.status(HttpStatus.CREATED).body(TaskResponse.from(task));
    }

    @GetMapping
    @Operation(summary = "タスク一覧を取得", description = "ユーザーのタスク一覧を取得します")
    public ResponseEntity<List<TaskResponse>> getTasks(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") UUID userId,
            @Parameter(description = "取得件数") @RequestParam(defaultValue = "20") int limit,
            @Parameter(description = "オフセット") @RequestParam(defaultValue = "0") int offset) {
        List<Task> tasks = taskService.getTasks(userId, limit, offset);
        List<TaskResponse> responses = tasks.stream()
                .map(TaskResponse::from)
                .collect(Collectors.toList());
        return ResponseEntity.ok(responses);
    }

    @GetMapping("/{taskId}")
    @Operation(summary = "タスクを取得", description = "指定されたIDのタスクを取得します")
    public ResponseEntity<TaskResponse> getTask(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") UUID userId,
            @Parameter(description = "タスクID") @PathVariable UUID taskId) {
        Task task = taskService.getTaskById(taskId, userId);
        return ResponseEntity.ok(TaskResponse.from(task));
    }

    @PutMapping("/{taskId}")
    @Operation(summary = "タスクを更新", description = "指定されたIDのタスクを更新します")
    public ResponseEntity<TaskResponse> updateTask(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") UUID userId,
            @Parameter(description = "タスクID") @PathVariable UUID taskId,
            @Valid @RequestBody TaskRequest request) {
        Task task = taskService.updateTask(taskId, userId, request.getTitle(), request.getMemo(), request.getDueAt(), null);
        return ResponseEntity.ok(TaskResponse.from(task));
    }

    @PostMapping("/{taskId}/toggle-done")
    @Operation(summary = "タスク完了を切替", description = "タスクの完了状態を切り替えます。完了時は風船への加算が行われます。")
    public ResponseEntity<TaskResponse> toggleDone(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") UUID userId,
            @Parameter(description = "タスクID") @PathVariable UUID taskId,
            @Valid @RequestBody ToggleDoneRequest request) {
        Task task = taskService.toggleTaskCompletion(taskId, userId, request.getIsDone());
        return ResponseEntity.ok(TaskResponse.from(task));
    }

    @DeleteMapping("/{taskId}")
    @Operation(summary = "タスクを削除", description = "指定されたIDのタスクを削除（論理削除）します")
    public ResponseEntity<Void> deleteTask(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") UUID userId,
            @Parameter(description = "タスクID") @PathVariable UUID taskId) {
        taskService.deleteTask(taskId, userId);
        return ResponseEntity.noContent().build();
    }
}
