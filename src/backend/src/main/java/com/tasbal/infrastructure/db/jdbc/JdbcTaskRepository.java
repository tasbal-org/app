package com.tasbal.infrastructure.db.jdbc;

import com.tasbal.domain.model.Task;
import com.tasbal.domain.repository.TaskRepository;
import com.tasbal.infrastructure.db.common.StoredFunctionExecutor;
import com.tasbal.infrastructure.db.common.StoredProcedureExecutor;
import com.tasbal.infrastructure.db.function.task.GetTaskByIdFunction;
import com.tasbal.infrastructure.db.function.task.GetTasksFunction;
import com.tasbal.infrastructure.db.procedure.task.CreateTaskProcedure;
import com.tasbal.infrastructure.db.procedure.task.DeleteTaskProcedure;
import com.tasbal.infrastructure.db.procedure.task.ToggleTaskCompletionProcedure;
import com.tasbal.infrastructure.db.procedure.task.UpdateTaskProcedure;
import org.springframework.stereotype.Repository;

import java.time.OffsetDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * タスクリポジトリのJDBC実装。
 *
 * <p>このクラスは{@link TaskRepository}インターフェースを実装し、
 * ストアドファンクション・プロシージャを使用してタスクのデータアクセスを提供します。</p>
 *
 * <p>データベース操作は以下のルールに従います:</p>
 * <ul>
 *   <li>GET系操作: {@link StoredFunctionExecutor}経由でストアドファンクションを実行</li>
 *   <li>CREATE/UPDATE/DELETE系操作: {@link StoredProcedureExecutor}経由でストアドプロシージャを実行</li>
 * </ul>
 *
 * @author Tasbal Team
 * @since 1.0.0
 * @see TaskRepository
 * @see StoredFunctionExecutor
 * @see StoredProcedureExecutor
 */
@Repository
public class JdbcTaskRepository implements TaskRepository {

    private final StoredProcedureExecutor procedureExecutor;
    private final StoredFunctionExecutor functionExecutor;

    /**
     * コンストラクタ。
     *
     * @param procedureExecutor ストアドプロシージャ実行クラス
     * @param functionExecutor ストアドファンクション実行クラス
     */
    public JdbcTaskRepository(
            StoredProcedureExecutor procedureExecutor,
            StoredFunctionExecutor functionExecutor) {
        this.procedureExecutor = procedureExecutor;
        this.functionExecutor = functionExecutor;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Task create(UUID userId, String title, String memo, OffsetDateTime dueAt) {
        CreateTaskProcedure procedure = new CreateTaskProcedure(userId, title, memo, dueAt);
        CreateTaskProcedure.Result result = procedureExecutor.executeForSingle(procedure);
        return result != null ? mapToTask(result) : null;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<Task> findByUserId(UUID userId, int limit, int offset) {
        GetTasksFunction function = new GetTasksFunction(userId, limit, offset);
        List<GetTasksFunction.Result> results = functionExecutor.execute(function);
        return results.stream()
                .map(this::mapToTaskWithTags)
                .toList();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Optional<Task> findById(UUID taskId, UUID userId) {
        GetTaskByIdFunction function = new GetTaskByIdFunction(taskId, userId);
        GetTaskByIdFunction.Result result = functionExecutor.executeForSingle(function);
        return result != null ? Optional.of(mapToTaskWithTags(result)) : Optional.empty();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Task update(UUID taskId, UUID userId, String title, String memo, OffsetDateTime dueAt, Boolean pinned) {
        UpdateTaskProcedure procedure = new UpdateTaskProcedure(taskId, userId, title, memo, dueAt, pinned);
        UpdateTaskProcedure.Result result = procedureExecutor.executeForSingle(procedure);
        return result != null ? mapToTask(result) : null;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Task toggleCompletion(UUID taskId, UUID userId, boolean isDone) {
        ToggleTaskCompletionProcedure procedure = new ToggleTaskCompletionProcedure(taskId, userId, isDone);
        ToggleTaskCompletionProcedure.Result result = procedureExecutor.executeForSingle(procedure);
        return result != null ? mapToTask(result) : null;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void delete(UUID taskId, UUID userId) {
        DeleteTaskProcedure procedure = new DeleteTaskProcedure(taskId, userId);
        procedureExecutor.execute(procedure);
    }

    /**
     * {@link CreateTaskProcedure.Result}をドメインモデル{@link Task}に変換します。
     *
     * @param result ストアドプロシージャの実行結果
     * @return ドメインモデルのTaskオブジェクト
     */
    private Task mapToTask(CreateTaskProcedure.Result result) {
        return new Task(
                result.getId(),
                result.getUserId(),
                result.getTitle(),
                result.getMemo(),
                result.getDueAt(),
                result.getStatus(),
                result.getPinned(),
                result.getCompletedAt(),
                result.getArchivedAt(),
                result.getCreatedAt(),
                result.getUpdatedAt(),
                result.getDeletedAt(),
                null
        );
    }

    /**
     * {@link GetTasksFunction.Result}をドメインモデル{@link Task}に変換します。
     *
     * @param result ストアドファンクションの実行結果
     * @return ドメインモデルのTaskオブジェクト（タグID付き）
     */
    private Task mapToTaskWithTags(GetTasksFunction.Result result) {
        Task task = new Task(
                result.getId(),
                result.getUserId(),
                result.getTitle(),
                result.getMemo(),
                result.getDueAt(),
                result.getStatus(),
                result.getPinned(),
                result.getCompletedAt(),
                result.getArchivedAt(),
                result.getCreatedAt(),
                result.getUpdatedAt(),
                result.getDeletedAt(),
                null
        );

        if (result.getTagIds() != null) {
            task.setTagIds(Arrays.asList(result.getTagIds()));
        }

        return task;
    }

    /**
     * {@link GetTaskByIdFunction.Result}をドメインモデル{@link Task}に変換します。
     *
     * @param result ストアドファンクションの実行結果
     * @return ドメインモデルのTaskオブジェクト（タグID付き）
     */
    private Task mapToTaskWithTags(GetTaskByIdFunction.Result result) {
        Task task = new Task(
                result.getId(),
                result.getUserId(),
                result.getTitle(),
                result.getMemo(),
                result.getDueAt(),
                result.getStatus(),
                result.getPinned(),
                result.getCompletedAt(),
                result.getArchivedAt(),
                result.getCreatedAt(),
                result.getUpdatedAt(),
                result.getDeletedAt(),
                null
        );

        if (result.getTagIds() != null) {
            task.setTagIds(Arrays.asList(result.getTagIds()));
        }

        return task;
    }

    /**
     * {@link UpdateTaskProcedure.Result}をドメインモデル{@link Task}に変換します。
     *
     * @param result ストアドプロシージャの実行結果
     * @return ドメインモデルのTaskオブジェクト
     */
    private Task mapToTask(UpdateTaskProcedure.Result result) {
        return new Task(
                result.getId(),
                result.getUserId(),
                result.getTitle(),
                result.getMemo(),
                result.getDueAt(),
                result.getStatus(),
                result.getPinned(),
                result.getCompletedAt(),
                result.getArchivedAt(),
                result.getCreatedAt(),
                result.getUpdatedAt(),
                result.getDeletedAt(),
                null
        );
    }

    /**
     * {@link ToggleTaskCompletionProcedure.Result}をドメインモデル{@link Task}に変換します。
     *
     * @param result ストアドプロシージャの実行結果
     * @return ドメインモデルのTaskオブジェクト
     */
    private Task mapToTask(ToggleTaskCompletionProcedure.Result result) {
        return new Task(
                result.getId(),
                result.getUserId(),
                result.getTitle(),
                result.getMemo(),
                result.getDueAt(),
                result.getStatus(),
                result.getPinned(),
                result.getCompletedAt(),
                result.getArchivedAt(),
                result.getCreatedAt(),
                result.getUpdatedAt(),
                result.getDeletedAt(),
                null
        );
    }
}
