package com.tasbal.infrastructure.db.function.task;

import com.tasbal.infrastructure.db.common.BaseStoredFunction;
import com.tasbal.infrastructure.db.common.annotation.Parameter;
import com.tasbal.infrastructure.db.common.annotation.StoredFunction;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.OffsetDateTime;
import java.util.UUID;

/**
 * タスクIDとユーザーIDでタスクを取得するストアドファンクション。
 *
 * <p>このファンクションは、指定されたタスクIDとユーザーIDに紐づく単一のタスクを取得します。
 * セキュリティのため、ユーザーIDによる所有者チェックが必須です。</p>
 *
 * <ul>
 *   <li>タスクIDとユーザーIDによるタスクの取得</li>
 *   <li>所有者チェック（他人のタスクは取得不可）</li>
 *   <li>タグIDの配列を含む完全なタスク情報の取得</li>
 *   <li>論理削除されたタスクの除外（deleted_at IS NULL）</li>
 * </ul>
 *
 * <h2>対応するSQL</h2>
 * <p>このクラスは、PostgreSQLの{@code sp_get_task_by_id}ファンクションに対応します:</p>
 *
 * <pre>{@code
 * CREATE OR REPLACE FUNCTION sp_get_task_by_id(
 *     p_task_id UUID,
 *     p_user_id UUID
 * )
 * RETURNS TABLE(
 *     id UUID,
 *     user_id UUID,
 *     title VARCHAR,
 *     memo TEXT,
 *     due_at TIMESTAMPTZ,
 *     status SMALLINT,
 *     pinned BOOLEAN,
 *     completed_at TIMESTAMPTZ,
 *     archived_at TIMESTAMPTZ,
 *     created_at TIMESTAMPTZ,
 *     updated_at TIMESTAMPTZ,
 *     deleted_at TIMESTAMPTZ,
 *     tag_ids UUID[]
 * ) AS $$
 * BEGIN
 *     RETURN QUERY
 *     SELECT
 *         t.id,
 *         t.user_id,
 *         t.title,
 *         t.memo,
 *         t.due_at,
 *         t.status,
 *         t.pinned,
 *         t.completed_at,
 *         t.archived_at,
 *         t.created_at,
 *         t.updated_at,
 *         t.deleted_at,
 *         ARRAY(
 *             SELECT tt.tag_id
 *             FROM task_tags tt
 *             WHERE tt.task_id = t.id
 *         ) AS tag_ids
 *     FROM tasks t
 *     WHERE t.id = p_task_id
 *       AND t.user_id = p_user_id
 *       AND t.deleted_at IS NULL;
 * END;
 * $$ LANGUAGE plpgsql;
 * }</pre>
 *
 * <h2>使用例</h2>
 *
 * <h3>タスクIDとユーザーIDでタスクを取得:</h3>
 * <pre>{@code
 * GetTaskByIdFunction function = new GetTaskByIdFunction(taskId, userId);
 * Optional<GetTaskByIdFunction.Result> result = executor.executeForSingle(function);
 * if (result.isPresent()) {
 *     System.out.println("Task title: " + result.get().getTitle());
 * } else {
 *     System.out.println("Task not found or access denied");
 * }
 * }</pre>
 *
 * <h3>存在チェック:</h3>
 * <pre>{@code
 * GetTaskByIdFunction function = new GetTaskByIdFunction(taskId, userId);
 * boolean exists = executor.executeForSingle(function).isPresent();
 * if (!exists) {
 *     throw new TaskNotFoundException("Task not found: " + taskId);
 * }
 * }</pre>
 *
 * <h2>制約とバリデーション</h2>
 * <ul>
 *   <li>task_idとuser_idの両方が必須</li>
 *   <li>指定されたユーザーが所有するタスクのみ取得可能（所有者チェック）</li>
 *   <li>論理削除されたタスク（deleted_at IS NOT NULL）は結果に含まれない</li>
 *   <li>条件に一致するタスクが存在しない場合、空の結果セットが返される</li>
 * </ul>
 *
 * <h2>戻り値</h2>
 * <p>このファンクションは、0件または1件の行を返します。
 * 条件に一致するタスクが存在する場合、タスクの完全な情報と関連するタグIDの配列が含まれます。</p>
 *
 * <h2>セキュリティ考慮事項</h2>
 * <ul>
 *   <li>user_idによる所有者チェックが必須（他人のタスクは取得不可）</li>
 *   <li>論理削除されたタスクは取得不可</li>
 *   <li>タスクIDが存在しても、所有者が異なる場合は結果が返されない</li>
 * </ul>
 *
 * <h2>パフォーマンス考慮事項</h2>
 * <ul>
 *   <li>タグIDはサブクエリで取得されるが、単一タスクのため影響は軽微</li>
 *   <li>id（主キー）とuser_idにインデックスが設定されていることを前提とする</li>
 * </ul>
 *
 * @author Tasbal Team
 * @since 1.0.0
 * @see com.tasbal.backend.domain.model.Task
 * @see com.tasbal.backend.domain.repository.TaskRepository#findById(UUID, UUID)
 */
@StoredFunction("sp_get_task_by_id")
public class GetTaskByIdFunction extends BaseStoredFunction<GetTaskByIdFunction.Result> {

    /**
     * タスクID。
     *
     * <p>取得するタスクのIDです。</p>
     */
    @Parameter("p_task_id")
    private UUID taskId;

    /**
     * ユーザーID。
     *
     * <p>タスクの所有者のユーザーIDです。
     * このユーザーIDがタスクの所有者と一致しない場合、結果は返されません。</p>
     */
    @Parameter("p_user_id")
    private UUID userId;

    /**
     * コンストラクタ。
     *
     * @param taskId タスクID（必須）
     * @param userId ユーザーID（必須、所有者チェックに使用）
     */
    public GetTaskByIdFunction(UUID taskId, UUID userId) {
        super(new ResultRowMapper());
        this.taskId = taskId;
        this.userId = userId;
    }

    /**
     * ストアドファンクションの実行結果を表すクラス。
     *
     * <p>このクラスは、{@code sp_get_task_by_id}ファンクションの
     * RETURNS TABLE定義に対応しています。</p>
     *
     * <p>タスクの完全な情報と、関連するタグIDの配列が含まれます。
     * タグIDは、task_tagsテーブルから取得されたUUID配列として返されます。</p>
     */
    public static class Result {
        private UUID id;
        private UUID userId;
        private String title;
        private String memo;
        private OffsetDateTime dueAt;
        private Short status;
        private Boolean pinned;
        private OffsetDateTime completedAt;
        private OffsetDateTime archivedAt;
        private OffsetDateTime createdAt;
        private OffsetDateTime updatedAt;
        private OffsetDateTime deletedAt;
        private UUID[] tagIds;

        /**
         * タスクIDを取得します。
         *
         * @return タスクID (UUID)
         */
        public UUID getId() {
            return id;
        }

        /**
         * タスクIDを設定します。
         *
         * @param id タスクID
         */
        public void setId(UUID id) {
            this.id = id;
        }

        /**
         * ユーザーIDを取得します。
         *
         * <p>このタスクの所有者のユーザーIDです。</p>
         *
         * @return ユーザーID (UUID)
         */
        public UUID getUserId() {
            return userId;
        }

        /**
         * ユーザーIDを設定します。
         *
         * @param userId ユーザーID
         */
        public void setUserId(UUID userId) {
            this.userId = userId;
        }

        /**
         * タスクのタイトルを取得します。
         *
         * @return タイトル
         */
        public String getTitle() {
            return title;
        }

        /**
         * タスクのタイトルを設定します。
         *
         * @param title タイトル
         */
        public void setTitle(String title) {
            this.title = title;
        }

        /**
         * タスクのメモを取得します。
         *
         * @return メモ（nullの場合あり）
         */
        public String getMemo() {
            return memo;
        }

        /**
         * タスクのメモを設定します。
         *
         * @param memo メモ
         */
        public void setMemo(String memo) {
            this.memo = memo;
        }

        /**
         * タスクの期限日時を取得します。
         *
         * @return 期限日時（nullの場合あり）
         */
        public OffsetDateTime getDueAt() {
            return dueAt;
        }

        /**
         * タスクの期限日時を設定します。
         *
         * @param dueAt 期限日時
         */
        public void setDueAt(OffsetDateTime dueAt) {
            this.dueAt = dueAt;
        }

        /**
         * タスクのステータスを取得します。
         *
         * <p>ステータス値:</p>
         * <ul>
         *   <li>1: TODO（未完了）</li>
         *   <li>2: COMPLETED（完了）</li>
         *   <li>3: ARCHIVED（アーカイブ済み）</li>
         * </ul>
         *
         * @return ステータス
         */
        public Short getStatus() {
            return status;
        }

        /**
         * タスクのステータスを設定します。
         *
         * @param status ステータス
         */
        public void setStatus(Short status) {
            this.status = status;
        }

        /**
         * タスクがピン留めされているかを取得します。
         *
         * @return ピン留め状態
         */
        public Boolean getPinned() {
            return pinned;
        }

        /**
         * タスクのピン留め状態を設定します。
         *
         * @param pinned ピン留め状態
         */
        public void setPinned(Boolean pinned) {
            this.pinned = pinned;
        }

        /**
         * タスクの完了日時を取得します。
         *
         * @return 完了日時（未完了の場合はnull）
         */
        public OffsetDateTime getCompletedAt() {
            return completedAt;
        }

        /**
         * タスクの完了日時を設定します。
         *
         * @param completedAt 完了日時
         */
        public void setCompletedAt(OffsetDateTime completedAt) {
            this.completedAt = completedAt;
        }

        /**
         * タスクのアーカイブ日時を取得します。
         *
         * @return アーカイブ日時（アーカイブされていない場合はnull）
         */
        public OffsetDateTime getArchivedAt() {
            return archivedAt;
        }

        /**
         * タスクのアーカイブ日時を設定します。
         *
         * @param archivedAt アーカイブ日時
         */
        public void setArchivedAt(OffsetDateTime archivedAt) {
            this.archivedAt = archivedAt;
        }

        /**
         * タスクの作成日時を取得します。
         *
         * @return 作成日時
         */
        public OffsetDateTime getCreatedAt() {
            return createdAt;
        }

        /**
         * タスクの作成日時を設定します。
         *
         * @param createdAt 作成日時
         */
        public void setCreatedAt(OffsetDateTime createdAt) {
            this.createdAt = createdAt;
        }

        /**
         * タスクの更新日時を取得します。
         *
         * @return 更新日時
         */
        public OffsetDateTime getUpdatedAt() {
            return updatedAt;
        }

        /**
         * タスクの更新日時を設定します。
         *
         * @param updatedAt 更新日時
         */
        public void setUpdatedAt(OffsetDateTime updatedAt) {
            this.updatedAt = updatedAt;
        }

        /**
         * タスクの論理削除日時を取得します。
         *
         * @return 論理削除日時（削除されていない場合はnull）
         */
        public OffsetDateTime getDeletedAt() {
            return deletedAt;
        }

        /**
         * タスクの論理削除日時を設定します。
         *
         * @param deletedAt 論理削除日時
         */
        public void setDeletedAt(OffsetDateTime deletedAt) {
            this.deletedAt = deletedAt;
        }

        /**
         * タスクに関連付けられたタグIDの配列を取得します。
         *
         * <p>task_tagsテーブルから取得されたタグIDの配列です。
         * タグが関連付けられていない場合は、空の配列またはnullが返されます。</p>
         *
         * @return タグIDの配列（UUID[]）
         */
        public UUID[] getTagIds() {
            return tagIds;
        }

        /**
         * タスクに関連付けられたタグIDの配列を設定します。
         *
         * @param tagIds タグIDの配列
         */
        public void setTagIds(UUID[] tagIds) {
            this.tagIds = tagIds;
        }
    }

    /**
     * ResultSetから{@link Result}オブジェクトへのマッピングを行うRowMapper。
     *
     * <p>PostgreSQLのRETURNS TABLE定義に従って、各カラムを
     * Javaオブジェクトのプロパティにマッピングします。</p>
     *
     * <p>特に、tag_idsカラムはPostgreSQLのUUID配列型であり、
     * {@link java.sql.Array}を経由してUUID[]に変換されます。</p>
     */
    private static class ResultRowMapper implements RowMapper<Result> {

        /**
         * ResultSetの1行を{@link Result}オブジェクトにマッピングします。
         *
         * @param rs ResultSet
         * @param rowNum 行番号（0始まり）
         * @return マッピングされたResultオブジェクト
         * @throws SQLException ResultSetからのデータ取得に失敗した場合
         */
        @Override
        public Result mapRow(ResultSet rs, int rowNum) throws SQLException {
            Result result = new Result();
            result.setId((UUID) rs.getObject("id"));
            result.setUserId((UUID) rs.getObject("user_id"));
            result.setTitle(rs.getString("title"));
            result.setMemo(rs.getString("memo"));
            result.setDueAt(rs.getObject("due_at", OffsetDateTime.class));
            result.setStatus(rs.getShort("status"));
            result.setPinned(rs.getBoolean("pinned"));
            result.setCompletedAt(rs.getObject("completed_at", OffsetDateTime.class));
            result.setArchivedAt(rs.getObject("archived_at", OffsetDateTime.class));
            result.setCreatedAt(rs.getObject("created_at", OffsetDateTime.class));
            result.setUpdatedAt(rs.getObject("updated_at", OffsetDateTime.class));
            result.setDeletedAt(rs.getObject("deleted_at", OffsetDateTime.class));

            java.sql.Array tagIdsArray = rs.getArray("tag_ids");
            if (tagIdsArray != null) {
                result.setTagIds((UUID[]) tagIdsArray.getArray());
            }

            return result;
        }
    }
}
