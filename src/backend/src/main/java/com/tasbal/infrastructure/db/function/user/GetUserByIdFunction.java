package com.tasbal.infrastructure.db.function.user;

import com.tasbal.infrastructure.db.common.BaseStoredFunction;
import com.tasbal.infrastructure.db.common.annotation.Parameter;
import com.tasbal.infrastructure.db.common.annotation.StoredFunction;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.OffsetDateTime;
import java.util.UUID;

/**
 * ユーザー情報を取得するストアドファンクション。
 *
 * <p>このファンクションは、指定されたユーザーIDに対応するユーザー情報を
 * データベースから取得します。削除されていないユーザーのみを対象とします。</p>
 *
 * <h2>対応するSQL</h2>
 * <p>このクラスは、PostgreSQLの{@code sp_get_user_by_id}ファンクションに対応します:</p>
 *
 * <pre>{@code
 * CREATE OR REPLACE FUNCTION sp_get_user_by_id(p_user_id UUID)
 * RETURNS TABLE(
 *     id UUID,
 *     handle VARCHAR,
 *     plan SMALLINT,
 *     is_guest BOOLEAN,
 *     auth_state SMALLINT,
 *     created_at TIMESTAMPTZ,
 *     updated_at TIMESTAMPTZ,
 *     last_login_at TIMESTAMPTZ,
 *     deleted_at TIMESTAMPTZ
 * ) AS $$
 * BEGIN
 *     RETURN QUERY
 *     SELECT u.id, u.handle, u.plan, u.is_guest, u.auth_state,
 *            u.created_at, u.updated_at, u.last_login_at, u.deleted_at
 *     FROM users u
 *     WHERE u.id = p_user_id AND u.deleted_at IS NULL;
 * END;
 * $$ LANGUAGE plpgsql;
 * }</pre>
 *
 * <h2>使用例</h2>
 *
 * <h3>ユーザー情報を取得:</h3>
 * <pre>{@code
 * GetUserByIdFunction function = new GetUserByIdFunction(userId);
 * GetUserByIdFunction.Result result = executor.executeForSingle(function);
 *
 * if (result == null) {
 *     throw new UserNotFoundException("User not found: " + userId);
 * }
 *
 * User user = mapToUser(result);
 * }</pre>
 *
 * <h2>戻り値</h2>
 * <p>ユーザーが見つかった場合は1行を返します。
 * ユーザーが存在しない、または削除されている場合は0行を返します。</p>
 *
 * @author Tasbal Team
 * @since 1.0.0
 * @see com.tasbal.backend.domain.model.User
 * @see com.tasbal.backend.domain.repository.UserRepository#findById(UUID)
 */
@StoredFunction("sp_get_user_by_id")
public class GetUserByIdFunction extends BaseStoredFunction<GetUserByIdFunction.Result> {

    /**
     * 取得対象のユーザーID。
     */
    @Parameter("p_user_id")
    private UUID userId;

    /**
     * コンストラクタ。
     *
     * @param userId 取得対象のユーザーID
     * @throws IllegalArgumentException userIdがnullの場合
     */
    public GetUserByIdFunction(UUID userId) {
        super(new ResultRowMapper());
        if (userId == null) {
            throw new IllegalArgumentException("userId must not be null");
        }
        this.userId = userId;
    }

    /**
     * ストアドファンクションの実行結果を表すクラス。
     *
     * <p>このクラスは、{@code sp_get_user_by_id}ファンクションの
     * RETURNS TABLE定義に対応しています。</p>
     */
    public static class Result {
        private UUID id;
        private String handle;
        private Short plan;
        private Boolean isGuest;
        private Short authState;
        private OffsetDateTime createdAt;
        private OffsetDateTime updatedAt;
        private OffsetDateTime lastLoginAt;
        private OffsetDateTime deletedAt;

        /**
         * ユーザーIDを取得します。
         *
         * @return ユーザーID (UUID)
         */
        public UUID getId() {
            return id;
        }

        /**
         * ユーザーIDを設定します。
         *
         * @param id ユーザーID
         */
        public void setId(UUID id) {
            this.id = id;
        }

        /**
         * ユーザーハンドルを取得します。
         *
         * @return ユーザーハンドル
         */
        public String getHandle() {
            return handle;
        }

        /**
         * ユーザーハンドルを設定します。
         *
         * @param handle ユーザーハンドル
         */
        public void setHandle(String handle) {
            this.handle = handle;
        }

        /**
         * プランIDを取得します。
         *
         * @return プランID (1=FREE, 2=PRO)
         */
        public Short getPlan() {
            return plan;
        }

        /**
         * プランIDを設定します。
         *
         * @param plan プランID
         */
        public void setPlan(Short plan) {
            this.plan = plan;
        }

        /**
         * ゲストユーザーフラグを取得します。
         *
         * @return ゲストユーザーの場合true
         */
        public Boolean getIsGuest() {
            return isGuest;
        }

        /**
         * ゲストユーザーフラグを設定します。
         *
         * @param isGuest ゲストユーザーフラグ
         */
        public void setIsGuest(Boolean isGuest) {
            this.isGuest = isGuest;
        }

        /**
         * 認証状態を取得します。
         *
         * @return 認証状態 (1=GUEST, 2=AUTHENTICATED)
         */
        public Short getAuthState() {
            return authState;
        }

        /**
         * 認証状態を設定します。
         *
         * @param authState 認証状態
         */
        public void setAuthState(Short authState) {
            this.authState = authState;
        }

        /**
         * 作成日時を取得します。
         *
         * @return 作成日時
         */
        public OffsetDateTime getCreatedAt() {
            return createdAt;
        }

        /**
         * 作成日時を設定します。
         *
         * @param createdAt 作成日時
         */
        public void setCreatedAt(OffsetDateTime createdAt) {
            this.createdAt = createdAt;
        }

        /**
         * 更新日時を取得します。
         *
         * @return 更新日時
         */
        public OffsetDateTime getUpdatedAt() {
            return updatedAt;
        }

        /**
         * 更新日時を設定します。
         *
         * @param updatedAt 更新日時
         */
        public void setUpdatedAt(OffsetDateTime updatedAt) {
            this.updatedAt = updatedAt;
        }

        /**
         * 最終ログイン日時を取得します。
         *
         * @return 最終ログイン日時。未ログインの場合null
         */
        public OffsetDateTime getLastLoginAt() {
            return lastLoginAt;
        }

        /**
         * 最終ログイン日時を設定します。
         *
         * @param lastLoginAt 最終ログイン日時
         */
        public void setLastLoginAt(OffsetDateTime lastLoginAt) {
            this.lastLoginAt = lastLoginAt;
        }

        /**
         * 削除日時を取得します。
         *
         * <p>このファンクションは削除されていないユーザーのみを返すため、
         * 通常はnullです。</p>
         *
         * @return 削除日時。削除されていない場合null
         */
        public OffsetDateTime getDeletedAt() {
            return deletedAt;
        }

        /**
         * 削除日時を設定します。
         *
         * @param deletedAt 削除日時
         */
        public void setDeletedAt(OffsetDateTime deletedAt) {
            this.deletedAt = deletedAt;
        }
    }

    /**
     * ResultSetから{@link Result}オブジェクトへのマッピングを行うRowMapper。
     *
     * <p>PostgreSQLのRETURNS TABLE定義に従って、各カラムを
     * Javaオブジェクトのプロパティにマッピングします。</p>
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
            result.setHandle(rs.getString("handle"));
            result.setPlan(rs.getShort("plan"));
            result.setIsGuest(rs.getBoolean("is_guest"));
            result.setAuthState(rs.getShort("auth_state"));
            result.setCreatedAt(rs.getObject("created_at", OffsetDateTime.class));
            result.setUpdatedAt(rs.getObject("updated_at", OffsetDateTime.class));
            result.setLastLoginAt(rs.getObject("last_login_at", OffsetDateTime.class));
            result.setDeletedAt(rs.getObject("deleted_at", OffsetDateTime.class));
            return result;
        }
    }
}
