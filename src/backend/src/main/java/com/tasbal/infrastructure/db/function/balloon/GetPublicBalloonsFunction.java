package com.tasbal.infrastructure.db.function.balloon;

import com.tasbal.infrastructure.db.common.BaseStoredFunction;
import com.tasbal.infrastructure.db.common.annotation.Parameter;
import com.tasbal.infrastructure.db.common.annotation.StoredFunction;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.OffsetDateTime;
import java.util.UUID;

/**
 * 公開風船一覧を取得するストアドファンクション。
 *
 * <p>このファンクションは、公開されているユーザー風船の一覧をデータベースから取得します。
 * 以下の条件でフィルタリングされます:</p>
 *
 * <ul>
 *   <li>visibility = 3 (PUBLIC)</li>
 *   <li>is_active = true</li>
 *   <li>balloon_type = 4 (USER)</li>
 * </ul>
 *
 * <p>結果は作成日時の降順で返され、ページネーション機能をサポートします。</p>
 *
 * <h2>対応するSQL</h2>
 * <p>このクラスは、PostgreSQLの{@code sp_get_public_balloons}ファンクションに対応します:</p>
 *
 * <pre>{@code
 * CREATE OR REPLACE FUNCTION sp_get_public_balloons(
 *     p_limit INT DEFAULT 20,
 *     p_offset INT DEFAULT 0
 * )
 * RETURNS TABLE(
 *     id UUID,
 *     balloon_type SMALLINT,
 *     display_group SMALLINT,
 *     visibility SMALLINT,
 *     owner_user_id UUID,
 *     title VARCHAR,
 *     description TEXT,
 *     color_id SMALLINT,
 *     tag_icon_id SMALLINT,
 *     country_code CHAR,
 *     is_active BOOLEAN,
 *     created_at TIMESTAMPTZ,
 *     updated_at TIMESTAMPTZ
 * ) AS $$
 * BEGIN
 *     RETURN QUERY
 *     SELECT b.id, b.balloon_type, b.display_group, b.visibility, b.owner_user_id,
 *            b.title, b.description, b.color_id, b.tag_icon_id, b.country_code,
 *            b.is_active, b.created_at, b.updated_at
 *     FROM balloons b
 *     WHERE b.visibility = 3  -- PUBLIC
 *       AND b.is_active = true
 *       AND b.balloon_type = 4  -- USER
 *     ORDER BY b.created_at DESC
 *     LIMIT p_limit
 *     OFFSET p_offset;
 * END;
 * $$ LANGUAGE plpgsql;
 * }</pre>
 *
 * <h2>使用例</h2>
 *
 * <h3>最初の20件を取得:</h3>
 * <pre>{@code
 * GetPublicBalloonsFunction function = new GetPublicBalloonsFunction(20, 0);
 * List<GetPublicBalloonsFunction.Result> results = executor.executeForList(function);
 * results.forEach(balloon -> System.out.println("Balloon: " + balloon.getTitle()));
 * }</pre>
 *
 * <h3>次の20件を取得（ページネーション）:</h3>
 * <pre>{@code
 * GetPublicBalloonsFunction function = new GetPublicBalloonsFunction(20, 20);
 * List<GetPublicBalloonsFunction.Result> results = executor.executeForList(function);
 * }</pre>
 *
 * <h3>最初の10件のみ取得:</h3>
 * <pre>{@code
 * GetPublicBalloonsFunction function = new GetPublicBalloonsFunction(10, 0);
 * List<GetPublicBalloonsFunction.Result> results = executor.executeForList(function);
 * }</pre>
 *
 * <h2>制約とバリデーション</h2>
 * <ul>
 *   <li>limitは正の整数でなければならない</li>
 *   <li>offsetは0以上の整数でなければならない</li>
 *   <li>公開風船のみが返される（非公開風船は除外）</li>
 *   <li>非アクティブな風船は除外される</li>
 * </ul>
 *
 * <h2>戻り値</h2>
 * <p>このファンクションは、0行以上のリストを返します。
 * 該当する公開風船が存在しない場合は空のリストが返されます。</p>
 *
 * <h2>ページネーション</h2>
 * <p>limitとoffsetパラメータを使用して、効率的なページネーションが可能です:</p>
 * <ul>
 *   <li>limit: 取得する最大件数</li>
 *   <li>offset: スキップする件数（0始まり）</li>
 * </ul>
 *
 * @author Tasbal Team
 * @since 1.0.0
 * @see com.tasbal.backend.domain.model.Balloon
 * @see com.tasbal.backend.domain.repository.BalloonRepository#findPublicBalloons(int, int)
 */
@StoredFunction("sp_get_public_balloons")
public class GetPublicBalloonsFunction extends BaseStoredFunction<GetPublicBalloonsFunction.Result> {

    /**
     * 取得する最大件数。
     *
     * <p>デフォルト値は20です。</p>
     */
    @Parameter("p_limit")
    private Integer limit;

    /**
     * スキップする件数（オフセット）。
     *
     * <p>デフォルト値は0です。</p>
     */
    @Parameter("p_offset")
    private Integer offset;

    /**
     * コンストラクタ。
     *
     * @param limit 取得する最大件数
     * @param offset スキップする件数
     */
    public GetPublicBalloonsFunction(Integer limit, Integer offset) {
        super(new ResultRowMapper());
        this.limit = limit;
        this.offset = offset;
    }

    /**
     * ストアドファンクションの実行結果を表すクラス。
     *
     * <p>このクラスは、{@code sp_get_public_balloons}ファンクションの
     * RETURNS TABLE定義に対応しています。</p>
     *
     * <p><strong>注意:</strong> このファンクションは公開風船のみを返すため、
     * visibility は常に 3 (PUBLIC)、is_active は常に true、
     * balloon_type は常に 4 (USER) です。</p>
     */
    public static class Result {
        private UUID id;
        private Short balloonType;
        private Short displayGroup;
        private Short visibility;
        private UUID ownerUserId;
        private String title;
        private String description;
        private Short colorId;
        private Short tagIconId;
        private String countryCode;
        private Boolean isActive;
        private OffsetDateTime createdAt;
        private OffsetDateTime updatedAt;

        /**
         * 風船IDを取得します。
         *
         * @return 風船ID (UUID)
         */
        public UUID getId() {
            return id;
        }

        /**
         * 風船IDを設定します。
         *
         * @param id 風船ID
         */
        public void setId(UUID id) {
            this.id = id;
        }

        /**
         * 風船タイプを取得します。
         *
         * <p>公開風船の場合、常に4(USER)です。</p>
         *
         * @return 風船タイプ (1=GLOBAL, 2=LOCATION, 3=BREATHING, 4=USER, 5=GUERRILLA)
         */
        public Short getBalloonType() {
            return balloonType;
        }

        /**
         * 風船タイプを設定します。
         *
         * @param balloonType 風船タイプ
         */
        public void setBalloonType(Short balloonType) {
            this.balloonType = balloonType;
        }

        /**
         * 表示グループを取得します。
         *
         * @return 表示グループ (1=PINNED, 2=DRIFTING)
         */
        public Short getDisplayGroup() {
            return displayGroup;
        }

        /**
         * 表示グループを設定します。
         *
         * @param displayGroup 表示グループ
         */
        public void setDisplayGroup(Short displayGroup) {
            this.displayGroup = displayGroup;
        }

        /**
         * 公開範囲を取得します。
         *
         * <p>公開風船の場合、常に3(PUBLIC)です。</p>
         *
         * @return 公開範囲 (1=SYSTEM, 2=PRIVATE, 3=PUBLIC)
         */
        public Short getVisibility() {
            return visibility;
        }

        /**
         * 公開範囲を設定します。
         *
         * @param visibility 公開範囲
         */
        public void setVisibility(Short visibility) {
            this.visibility = visibility;
        }

        /**
         * オーナーユーザーIDを取得します。
         *
         * @return オーナーユーザーID (UUID)、システム風船の場合はnull
         */
        public UUID getOwnerUserId() {
            return ownerUserId;
        }

        /**
         * オーナーユーザーIDを設定します。
         *
         * @param ownerUserId オーナーユーザーID
         */
        public void setOwnerUserId(UUID ownerUserId) {
            this.ownerUserId = ownerUserId;
        }

        /**
         * 風船タイトルを取得します。
         *
         * @return 風船タイトル
         */
        public String getTitle() {
            return title;
        }

        /**
         * 風船タイトルを設定します。
         *
         * @param title 風船タイトル
         */
        public void setTitle(String title) {
            this.title = title;
        }

        /**
         * 風船の説明を取得します。
         *
         * @return 風船の説明
         */
        public String getDescription() {
            return description;
        }

        /**
         * 風船の説明を設定します。
         *
         * @param description 風船の説明
         */
        public void setDescription(String description) {
            this.description = description;
        }

        /**
         * カラーIDを取得します。
         *
         * @return カラーID
         */
        public Short getColorId() {
            return colorId;
        }

        /**
         * カラーIDを設定します。
         *
         * @param colorId カラーID
         */
        public void setColorId(Short colorId) {
            this.colorId = colorId;
        }

        /**
         * タグアイコンIDを取得します。
         *
         * @return タグアイコンID
         */
        public Short getTagIconId() {
            return tagIconId;
        }

        /**
         * タグアイコンIDを設定します。
         *
         * @param tagIconId タグアイコンID
         */
        public void setTagIconId(Short tagIconId) {
            this.tagIconId = tagIconId;
        }

        /**
         * 国コードを取得します。
         *
         * @return 国コード (ISO 3166-1 alpha-2)、設定されていない場合はnull
         */
        public String getCountryCode() {
            return countryCode;
        }

        /**
         * 国コードを設定します。
         *
         * @param countryCode 国コード
         */
        public void setCountryCode(String countryCode) {
            this.countryCode = countryCode;
        }

        /**
         * アクティブフラグを取得します。
         *
         * <p>公開風船の場合、常にtrueです。</p>
         *
         * @return アクティブな場合true
         */
        public Boolean getIsActive() {
            return isActive;
        }

        /**
         * アクティブフラグを設定します。
         *
         * @param isActive アクティブフラグ
         */
        public void setIsActive(Boolean isActive) {
            this.isActive = isActive;
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
            result.setBalloonType(rs.getShort("balloon_type"));
            result.setDisplayGroup(rs.getShort("display_group"));
            result.setVisibility(rs.getShort("visibility"));
            result.setOwnerUserId((UUID) rs.getObject("owner_user_id"));
            result.setTitle(rs.getString("title"));
            result.setDescription(rs.getString("description"));
            result.setColorId(rs.getShort("color_id"));
            result.setTagIconId(rs.getShort("tag_icon_id"));
            result.setCountryCode(rs.getString("country_code"));
            result.setIsActive(rs.getBoolean("is_active"));
            result.setCreatedAt(rs.getObject("created_at", OffsetDateTime.class));
            result.setUpdatedAt(rs.getObject("updated_at", OffsetDateTime.class));
            return result;
        }
    }
}
