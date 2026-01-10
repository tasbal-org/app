package com.tasbal.presentation.controller;

import com.tasbal.application.service.TaskService;
import com.tasbal.domain.model.Task;
import com.tasbal.presentation.dto.TaskRequest;
import com.tasbal.presentation.dto.TaskResponse;
import com.tasbal.presentation.dto.ToggleDoneRequest;
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

/**
 * タスク管理REST APIコントローラー。
 *
 * <p>このコントローラーはタスク（Task）に関するHTTPエンドポイントを提供します。
 * タスクはユーザーが達成すべき個々の作業項目であり、
 * 完了時に選択中の風船に達成度を加算します。</p>
 *
 * <h3>主な責務:</h3>
 * <ul>
 *   <li>タスクのCRUD操作</li>
 *   <li>タスク完了状態の切り替え</li>
 *   <li>ユーザーごとのタスク一覧取得</li>
 *   <li>HTTPリクエストのバリデーション</li>
 *   <li>DTOとドメインモデル間の変換</li>
 * </ul>
 *
 * <h3>主な機能:</h3>
 * <ul>
 *   <li>新しいタスクの作成</li>
 *   <li>タスクの一覧取得（ページネーション対応）</li>
 *   <li>タスクの詳細取得</li>
 *   <li>タスクの更新</li>
 *   <li>タスクの完了状態切り替え（風船への加算を含む）</li>
 *   <li>タスクの論理削除</li>
 * </ul>
 *
 * @author Tasbal Team
 * @since 1.0.0
 * @see TaskService
 * @see TaskRequest
 * @see TaskResponse
 */
@RestController
@RequestMapping("/api/v1/tasks")
@Tag(name = "Tasks", description = "タスク管理API")
public class TaskController {

    private final TaskService taskService;

    /**
     * コンストラクタインジェクション。
     *
     * @param taskService タスクビジネスロジックを提供するサービス
     */
    public TaskController(TaskService taskService) {
        this.taskService = taskService;
    }

    /**
     * 新しいタスクを作成します。
     *
     * <p>ユーザーが新しいタスクを作成します。
     * タスクにはタイトル、メモ、期限を指定できます。
     * 作成されたタスクは自動的にそのユーザーに関連付けられます。</p>
     *
     * @param userId リクエストヘッダーから取得されたユーザーID
     * @param request タスク作成リクエスト（タイトル、メモ、期限）
     * @return 作成されたタスクのレスポンスDTO（ステータス: 201 CREATED）
     */
    @PostMapping
    @Operation(summary = "タスクを作成", description = "新しいタスクを作成します")
    public ResponseEntity<TaskResponse> createTask(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") UUID userId,
            @Valid @RequestBody TaskRequest request) {
        Task task = taskService.createTask(userId, request.getTitle(), request.getMemo(), request.getDueAt());
        return ResponseEntity.status(HttpStatus.CREATED).body(TaskResponse.from(task));
    }

    /**
     * タスク一覧を取得します。
     *
     * <p>指定されたユーザーのタスク一覧を取得します。
     * ページネーションに対応しており、取得件数とオフセットを指定できます。</p>
     *
     * @param userId リクエストヘッダーから取得されたユーザーID
     * @param limit 取得件数（デフォルト: 20）
     * @param offset 取得開始位置のオフセット（デフォルト: 0）
     * @return タスクのレスポンスDTOリスト
     */
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

    /**
     * 指定されたIDのタスクを取得します。
     *
     * <p>タスクIDを指定して、該当するタスクの詳細情報を取得します。
     * 権限チェックが行われ、他ユーザーのタスクは取得できません。</p>
     *
     * @param userId リクエストヘッダーから取得されたユーザーID
     * @param taskId 取得するタスクのID
     * @return タスクのレスポンスDTO
     */
    @GetMapping("/{taskId}")
    @Operation(summary = "タスクを取得", description = "指定されたIDのタスクを取得します")
    public ResponseEntity<TaskResponse> getTask(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") UUID userId,
            @Parameter(description = "タスクID") @PathVariable UUID taskId) {
        Task task = taskService.getTaskById(taskId, userId);
        return ResponseEntity.ok(TaskResponse.from(task));
    }

    /**
     * 指定されたIDのタスクを更新します。
     *
     * <p>タスクIDを指定して、該当するタスクの情報を更新します。
     * タイトル、メモ、期限を変更できます。
     * 権限チェックが行われ、他ユーザーのタスクは更新できません。</p>
     *
     * @param userId リクエストヘッダーから取得されたユーザーID
     * @param taskId 更新するタスクのID
     * @param request タスク更新リクエスト（タイトル、メモ、期限）
     * @return 更新されたタスクのレスポンスDTO
     */
    @PutMapping("/{taskId}")
    @Operation(summary = "タスクを更新", description = "指定されたIDのタスクを更新します")
    public ResponseEntity<TaskResponse> updateTask(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") UUID userId,
            @Parameter(description = "タスクID") @PathVariable UUID taskId,
            @Valid @RequestBody TaskRequest request) {
        Task task = taskService.updateTask(taskId, userId, request.getTitle(), request.getMemo(), request.getDueAt(), null);
        return ResponseEntity.ok(TaskResponse.from(task));
    }

    /**
     * タスクの完了状態を切り替えます。
     *
     * <p>タスクIDを指定して、該当するタスクの完了状態を切り替えます。
     * タスクを完了状態にすると、選択中の風船に達成度が加算されます。
     * 未完了に戻すことも可能です。
     * 権限チェックが行われ、他ユーザーのタスクは操作できません。</p>
     *
     * @param userId リクエストヘッダーから取得されたユーザーID
     * @param taskId 対象タスクのID
     * @param request 完了状態（true: 完了、false: 未完了）
     * @return 更新されたタスクのレスポンスDTO
     */
    @PostMapping("/{taskId}/toggle-done")
    @Operation(summary = "タスク完了を切替", description = "タスクの完了状態を切り替えます。完了時は風船への加算が行われます。")
    public ResponseEntity<TaskResponse> toggleDone(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") UUID userId,
            @Parameter(description = "タスクID") @PathVariable UUID taskId,
            @Valid @RequestBody ToggleDoneRequest request) {
        Task task = taskService.toggleTaskCompletion(taskId, userId, request.getIsDone());
        return ResponseEntity.ok(TaskResponse.from(task));
    }

    /**
     * 指定されたIDのタスクを削除します。
     *
     * <p>タスクIDを指定して、該当するタスクを論理削除します。
     * 物理的にデータベースから削除されるわけではなく、削除フラグが立てられます。
     * 権限チェックが行われ、他ユーザーのタスクは削除できません。</p>
     *
     * @param userId リクエストヘッダーから取得されたユーザーID
     * @param taskId 削除するタスクのID
     * @return レスポンスボディなし（ステータス: 204 NO CONTENT）
     */
    @DeleteMapping("/{taskId}")
    @Operation(summary = "タスクを削除", description = "指定されたIDのタスクを削除（論理削除）します")
    public ResponseEntity<Void> deleteTask(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") UUID userId,
            @Parameter(description = "タスクID") @PathVariable UUID taskId) {
        taskService.deleteTask(taskId, userId);
        return ResponseEntity.noContent().build();
    }
}
