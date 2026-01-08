package com.tasbal.backend.infrastructure.db.function.user;

import com.tasbal.backend.infrastructure.db.common.BaseStoredFunction;
import com.tasbal.backend.infrastructure.db.common.annotation.Parameter;
import com.tasbal.backend.infrastructure.db.common.annotation.StoredFunction;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.OffsetDateTime;
import java.util.UUID;

/**
 * ゲストユーザーを作成するストアドファンクション。
 *
 * <p>このファンクションは、新しいゲストユーザーをデータベースに作成します。
 * ゲストユーザーは、本登録前のユーザーで、以下の特徴があります:</p>
 *
 * <ul>
 *   <li>is_guest = true</li>
 *   <li>auth_state = 1 (GUEST)</li>
 *   <li>plan = 1 (FREE)</li>
 *   <li>handleが指定されない場合は、自動的にランダムなhandleが生成される</li>
 *   <li>user_settingsレコードが自動的に作成される</li>
 * </ul>
 *
 * <h2>対応するSQL</h2>
 * <p>このクラスは、PostgreSQLの{@code sp_create_guest_user}ファンクションに対応します:</p>
 *
 * <pre>{@code
 * CREATE OR REPLACE FUNCTION sp_create_guest_user(p_handle VARCHAR DEFAULT NULL)
 * RETURNS TABLE(
 *     id UUID,
 *     handle VARCHAR,
 *     plan SMALLINT,
 *     is_guest BOOLEAN,
 *     auth_state SMALLINT,
 *     created_at TIMESTAMPTZ,
 *     updated_at TIMESTAMPTZ
 * ) AS $$
 * DECLARE
 *     v_user_id UUID;
 *     v_handle VARCHAR;
 * BEGIN
 *     IF p_handle IS NULL THEN
 *         v_handle := 'guest_' || substr(md5(random()::text), 1, 8);
 *     ELSE
 *         v_handle := p_handle;
 *     END IF;
 *
 *     INSERT INTO users (handle, is_guest, auth_state, plan)
 *     VALUES (v_handle, true, 1, 1)
 *     RETURNING users.id INTO v_user_id;
 *
 *     INSERT INTO user_settings (user_id) VALUES (v_user_id);
 *
 *     RETURN QUERY
 *     SELECT u.id, u.handle, u.plan, u.is_guest, u.auth_state, u.created_at, u.updated_at
 *     FROM users u
 *     WHERE u.id = v_user_id;
 * END;
 * $$ LANGUAGE plpgsql;
 * }</pre>
 *
 * <h2>使用例</h2>
 *
 * <h3>ランダムなhandleでゲストユーザーを作成:</h3>
 * <pre>{@code
 * CreateGuestUserFunction function = new CreateGuestUserFunction(null);
 * CreateGuestUserFunction.Result result = executor.executeForSingleRequired(function);
 * System.out.println("Created user: " + result.getHandle()); // 例: "guest_a1b2c3d4"
 * }</pre>
 *
 * <h3>指定したhandleでゲストユーザーを作成:</h3>
 * <pre>{@code
 * CreateGuestUserFunction function = new CreateGuestUserFunction("my_custom_handle");
 * CreateGuestUserFunction.Result result = executor.executeForSingleRequired(function);
 * System.out.println("Created user: " + result.getHandle()); // "my_custom_handle"
 * }</pre>
 *
 * <h2>制約とバリデーション</h2>
 * <ul>
 *   <li>handleは一意でなければならない（DB側でユニーク制約）</li>
 *   <li>handleの最大長は制限される（DB側でVARCHAR制約）</li>
 *   <li>handle重複時は、DataIntegrityViolationExceptionがスローされる</li>
 * </ul>
 *
 * <h2>戻り値</h2>
 * <p>このファンクションは、常に1行を返します。作成されたユーザーの情報が含まれます。</p>
 *
 * @author Tasbal Team
 * @since 1.0.0
 * @see com.tasbal.backend.domain.model.User
 * @see com.tasbal.backend.domain.repository.UserRepository#createGuest(String)
 */
@StoredFunction("sp_create_guest_user")
public class CreateGuestUserFunction extends BaseStoredFunction<CreateGuestUserFunction.Result> {

    /**
     * ユーザーハンドル。
     *
     * <p>nullの場合、DB側でランダムなhandle（例: "guest_a1b2c3d4"）が自動生成されます。</p>
     */
    @Parameter("p_handle")
    private String handle;

    /**
     * コンストラクタ。
     *
     * @param handle ユーザーハンドル。nullの場合は自動生成される
     */
    public CreateGuestUserFunction(String handle) {
        super(new ResultRowMapper());
        this.handle = handle;
    }

    /**
     * ストアドファンクションの実行結果を表すクラス。
     *
     * <p>このクラスは、{@code sp_create_guest_user}ファンクションの
     * RETURNS TABLE定義に対応しています。</p>
     *
     * <p><strong>注意:</strong> {@code last_login_at}と{@code deleted_at}は
     * このファンクションでは返されません（新規作成のため常にnull）。</p>
     */
    public static class Result {
        private UUID id;
        private String handle;
        private Short plan;
        private Boolean isGuest;
        private Short authState;
        private OffsetDateTime createdAt;
        private OffsetDateTime updatedAt;

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
         * <p>ゲストユーザーの場合、常に1(FREE)です。</p>
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
         * <p>このファンクションで作成されるユーザーは常にtrueです。</p>
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
         * <p>ゲストユーザーの場合、常に1(GUEST)です。</p>
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
         * <p>新規作成時は{@code created_at}と同じ値です。</p>
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
            return result;
        }
    }
}
