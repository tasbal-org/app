package com.tasbal.backend.infrastructure.db.function.balloon;

import com.tasbal.backend.infrastructure.db.common.BaseStoredFunction;
import com.tasbal.backend.infrastructure.db.common.annotation.Parameter;
import com.tasbal.backend.infrastructure.db.common.annotation.StoredFunction;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.OffsetDateTime;
import java.util.UUID;

/**
 * ユーザーが選択中の風船を取得するストアドファンクション。
 *
 * <p>このファンクションは、指定されたユーザーが現在選択している風船の情報を
 * データベースから取得します。選択中の風船とは、タスク完了時に貢献が加算される
 * アクティブな風船のことです。</p>
 *
 * <ul>
 *   <li>left_at IS NULL（選択中）</li>
 *   <li>優先度順にソート</li>
 *   <li>最大1件を返す</li>
 * </ul>
 *
 * <h2>対応するSQL</h2>
 * <p>このクラスは、PostgreSQLの{@code sp_get_balloon_selection}ファンクションに対応します:</p>
 *
 * <pre>{@code
 * CREATE OR REPLACE FUNCTION sp_get_balloon_selection(
 *     p_user_id UUID
 * )
 * RETURNS TABLE(
 *     user_id UUID,
 *     balloon_id UUID,
 *     priority INT,
 *     selected_at TIMESTAMPTZ,
 *     left_at TIMESTAMPTZ
 * ) AS $$
 * BEGIN
 *     RETURN QUERY
 *     SELECT bs.user_id, bs.balloon_id, bs.priority, bs.selected_at, bs.left_at
 *     FROM balloon_selections bs
 *     WHERE bs.user_id = p_user_id
 *       AND bs.left_at IS NULL
 *     ORDER BY bs.priority
 *     LIMIT 1;
 * END;
 * $$ LANGUAGE plpgsql;
 * }</pre>
 *
 * <h2>使用例</h2>
 *
 * <h3>選択中の風船を取得:</h3>
 * <pre>{@code
 * UUID userId = UUID.fromString("...");
 * GetBalloonSelectionFunction function = new GetBalloonSelectionFunction(userId);
 * Optional<GetBalloonSelectionFunction.Result> result = executor.executeForSingleOptional(function);
 *
 * if (result.isPresent()) {
 *     System.out.println("Selected balloon: " + result.get().getBalloonId());
 * } else {
 *     System.out.println("No balloon selected");
 * }
 * }</pre>
 *
 * <h3>選択中の風船があるか確認:</h3>
 * <pre>{@code
 * GetBalloonSelectionFunction function = new GetBalloonSelectionFunction(userId);
 * List<GetBalloonSelectionFunction.Result> results = executor.executeForList(function);
 * boolean hasSelection = !results.isEmpty();
 * }</pre>
 *
 * <h2>制約とバリデーション</h2>
 * <ul>
 *   <li>userIdはnullであってはならない</li>
 *   <li>同時に選択できる風船は最大1つ</li>
 *   <li>left_atがnullでない風船は選択解除済み</li>
 * </ul>
 *
 * <h2>戻り値</h2>
 * <p>このファンクションは、0件または1件を返します。
 * 選択中の風船がない場合は空のリストが返されます。</p>
 *
 * <h2>ビジネスルール</h2>
 * <p>風船選択の仕組み:</p>
 * <ul>
 *   <li>ユーザーは常に最大1つの風船を選択できる</li>
 *   <li>選択中の風船にのみタスク完了時の貢献が加算される</li>
 *   <li>風船の選択を解除するとleft_atがセットされる</li>
 *   <li>別の風船を選択すると、自動的に前の選択が解除される</li>
 * </ul>
 *
 * @author Tasbal Team
 * @since 1.0.0
 * @see com.tasbal.backend.domain.model.BalloonSelection
 * @see com.tasbal.backend.domain.repository.BalloonRepository#findSelection(UUID)
 */
@StoredFunction("sp_get_balloon_selection")
public class GetBalloonSelectionFunction extends BaseStoredFunction<GetBalloonSelectionFunction.Result> {

    /**
     * ユーザーID。
     *
     * <p>このユーザーの選択中の風船を取得します。</p>
     */
    @Parameter("p_user_id")
    private UUID userId;

    /**
     * コンストラクタ。
     *
     * @param userId ユーザーID
     */
    public GetBalloonSelectionFunction(UUID userId) {
        super(new ResultRowMapper());
        this.userId = userId;
    }

    /**
     * ストアドファンクションの実行結果を表すクラス。
     *
     * <p>このクラスは、{@code sp_get_balloon_selection}ファンクションの
     * RETURNS TABLE定義に対応しています。</p>
     *
     * <p><strong>注意:</strong> left_atは常にnullです（選択中の風船のみを返すため）。</p>
     */
    public static class Result {
        private UUID userId;
        private UUID balloonId;
        private Integer priority;
        private OffsetDateTime selectedAt;
        private OffsetDateTime leftAt;

        /**
         * ユーザーIDを取得します。
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
         * 風船IDを取得します。
         *
         * @return 風船ID (UUID)
         */
        public UUID getBalloonId() {
            return balloonId;
        }

        /**
         * 風船IDを設定します。
         *
         * @param balloonId 風船ID
         */
        public void setBalloonId(UUID balloonId) {
            this.balloonId = balloonId;
        }

        /**
         * 優先度を取得します。
         *
         * <p>複数の風船を選択している場合の表示順序を制御します。
         * 数値が小さいほど優先度が高くなります。</p>
         *
         * @return 優先度
         */
        public Integer getPriority() {
            return priority;
        }

        /**
         * 優先度を設定します。
         *
         * @param priority 優先度
         */
        public void setPriority(Integer priority) {
            this.priority = priority;
        }

        /**
         * 選択日時を取得します。
         *
         * <p>この風船が選択された（または最後に再選択された）日時です。</p>
         *
         * @return 選択日時
         */
        public OffsetDateTime getSelectedAt() {
            return selectedAt;
        }

        /**
         * 選択日時を設定します。
         *
         * @param selectedAt 選択日時
         */
        public void setSelectedAt(OffsetDateTime selectedAt) {
            this.selectedAt = selectedAt;
        }

        /**
         * 選択解除日時を取得します。
         *
         * <p>このファンクションで返される結果では常にnullです
         * （選択中の風船のみを取得するため）。</p>
         *
         * @return 選択解除日時（選択中の場合はnull）
         */
        public OffsetDateTime getLeftAt() {
            return leftAt;
        }

        /**
         * 選択解除日時を設定します。
         *
         * @param leftAt 選択解除日時
         */
        public void setLeftAt(OffsetDateTime leftAt) {
            this.leftAt = leftAt;
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
            result.setUserId((UUID) rs.getObject("user_id"));
            result.setBalloonId((UUID) rs.getObject("balloon_id"));
            result.setPriority(rs.getInt("priority"));
            result.setSelectedAt(rs.getObject("selected_at", OffsetDateTime.class));
            result.setLeftAt(rs.getObject("left_at", OffsetDateTime.class));
            return result;
        }
    }
}
