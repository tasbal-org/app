package com.tasbal.infrastructure.db.common;

import com.tasbal.infrastructure.db.common.annotation.Parameter;
import com.tasbal.infrastructure.db.common.annotation.StoredFunction;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * ストアドファンクションの基底クラス。
 *
 * <p>すべてのストアドファンクションクラスはこのクラスを継承します。
 * PostgreSQLの{@code CREATE FUNCTION ... RETURNS TABLE}で作成された
 * 関数に対応し、パラメータの収集、SQL文の構築、実行を共通化します。</p>
 *
 * <h2>ストアドファンクションとは</h2>
 * <p>ストアドファンクションは、データベースサーバー上で実行される
 * 事前コンパイルされたSQL文の集合です。以下の特徴があります:</p>
 *
 * <ul>
 *   <li><strong>戻り値あり:</strong> {@code RETURNS TABLE}または特定の型を返す</li>
 *   <li><strong>SELECT可能:</strong> {@code SELECT * FROM function_name(...)}で呼び出せる</li>
 *   <li><strong>読み取り主体:</strong> 主にデータの取得・変換に使用</li>
 *   <li><strong>トランザクション制御不可:</strong> 呼び出し元のトランザクションに従う</li>
 * </ul>
 *
 * <h2>実装方法</h2>
 * <p>このクラスを継承して、以下の要素を実装します:</p>
 *
 * <ol>
 *   <li>{@link StoredFunction}アノテーションでファンクション名を指定</li>
 *   <li>{@link Parameter}アノテーションで引数フィールドを定義</li>
 *   <li>戻り値を表す{@code Result}内部クラスを定義</li>
 *   <li>{@link RowMapper}を実装した{@code ResultRowMapper}を定義</li>
 * </ol>
 *
 * <h3>実装例:</h3>
 * <pre>{@code
 * @StoredFunction("sp_get_user_by_id")
 * public class GetUserByIdFunction extends BaseStoredFunction<GetUserByIdFunction.Result> {
 *
 *     @Parameter("p_user_id")
 *     private UUID userId;
 *
 *     public GetUserByIdFunction(UUID userId) {
 *         super(new ResultRowMapper());
 *         this.userId = userId;
 *     }
 *
 *     public static class Result {
 *         private UUID id;
 *         private String handle;
 *         // getters and setters...
 *     }
 *
 *     private static class ResultRowMapper implements RowMapper<Result> {
 *         @Override
 *         public Result mapRow(ResultSet rs, int rowNum) throws SQLException {
 *             Result result = new Result();
 *             result.setId((UUID) rs.getObject("id"));
 *             result.setHandle(rs.getString("handle"));
 *             return result;
 *         }
 *     }
 * }
 * }</pre>
 *
 * <h3>対応するSQL:</h3>
 * <pre>{@code
 * CREATE OR REPLACE FUNCTION sp_get_user_by_id(p_user_id UUID)
 * RETURNS TABLE(
 *     id UUID,
 *     handle VARCHAR
 * ) AS $$
 * BEGIN
 *     RETURN QUERY
 *     SELECT u.id, u.handle
 *     FROM users u
 *     WHERE u.id = p_user_id;
 * END;
 * $$ LANGUAGE plpgsql;
 * }</pre>
 *
 * <h2>SQL生成の仕組み</h2>
 * <p>このクラスは、{@link Parameter}アノテーションが付与されたフィールドから
 * 自動的にSQL文を生成します:</p>
 *
 * <pre>{@code
 * // Javaコード
 * @Parameter("p_user_id") private UUID userId;
 * @Parameter("p_status") private Integer status;
 *
 * // 生成されるSQL
 * SELECT * FROM sp_get_users(?, ?)
 * // パラメータ配列: [userId, status]
 * }</pre>
 *
 * <h2>スレッドセーフティ</h2>
 * <p>このクラスのインスタンスは<strong>スレッドセーフではありません</strong>。
 * 各実行ごとに新しいインスタンスを作成してください。</p>
 *
 * @param <TResult> ストアドファンクションの戻り値の型
 * @author Tasbal Team
 * @since 1.0.0
 * @see StoredFunction
 * @see Parameter
 * @see StoredFunctionCall
 */
public abstract class BaseStoredFunction<TResult> implements StoredFunctionCall<TResult> {

    /**
     * ResultSetから結果オブジェクトへのマッピングを行うRowMapper。
     *
     * <p>このマッパーは、PostgreSQLから返されたResultSetの各行を
     * Javaオブジェクトに変換します。</p>
     */
    protected final RowMapper<TResult> rowMapper;

    /**
     * コンストラクタ。
     *
     * <p>サブクラスは、このコンストラクタを呼び出して
     * RowMapperインスタンスを渡す必要があります。</p>
     *
     * @param rowMapper ResultSetから結果オブジェクトへのマッピングを行うRowMapper
     * @throws IllegalArgumentException rowMapperがnullの場合
     */
    protected BaseStoredFunction(RowMapper<TResult> rowMapper) {
        if (rowMapper == null) {
            throw new IllegalArgumentException("RowMapper must not be null");
        }
        this.rowMapper = rowMapper;
    }

    /**
     * {@inheritDoc}
     *
     * <p>クラスに付与された{@link StoredFunction}アノテーションから
     * ファンクション名を取得します。</p>
     *
     * @throws IllegalStateException {@link StoredFunction}アノテーションが付与されていない場合
     */
    @Override
    public String getFunctionName() {
        StoredFunction annotation = this.getClass().getAnnotation(StoredFunction.class);
        if (annotation == null) {
            throw new IllegalStateException(
                "@StoredFunction annotation is required on " + this.getClass().getName()
            );
        }
        return annotation.value();
    }

    /**
     * {@inheritDoc}
     *
     * <p>JdbcTemplateを使用してストアドファンクションを実行します。
     * 以下の手順で実行されます:</p>
     *
     * <ol>
     *   <li>SQL呼び出し文を構築 ({@code SELECT * FROM function_name(?, ?)})</li>
     *   <li>パラメータ配列を構築</li>
     *   <li>JdbcTemplateで実行し、RowMapperで結果をマッピング</li>
     * </ol>
     *
     * @param jdbcTemplate Spring JDBCテンプレート
     * @return ストアドファンクションの実行結果のリスト
     * @throws org.springframework.dao.DataAccessException データアクセスエラーが発生した場合
     */
    @Override
    public List<TResult> executeWith(JdbcTemplate jdbcTemplate) {
        String sql = buildCallStatement();
        Object[] parameters = buildParameterArray();
        return jdbcTemplate.query(sql, rowMapper, parameters);
    }

    /**
     * クラスのフィールドから{@link Parameter}アノテーションが付与されたフィールドを収集します。
     *
     * <p>パラメータの順序はフィールド宣言順序に依存します。
     * これにより、SQLのプレースホルダ(?)と値の対応が保証されます。</p>
     *
     * <h3>例:</h3>
     * <pre>{@code
     * @Parameter("p_user_id") private UUID userId;
     * @Parameter("p_limit") private Integer limit;
     *
     * // 返されるマップ:
     * {
     *   "p_user_id" -> userId値,
     *   "p_limit" -> limit値
     * }
     * }</pre>
     *
     * @return パラメータ名と値のマップ（挿入順序保証）
     * @throws RuntimeException フィールドへのアクセスに失敗した場合
     */
    protected Map<String, Object> getParameters() {
        Map<String, Object> params = new LinkedHashMap<>();
        Field[] fields = this.getClass().getDeclaredFields();

        for (Field field : fields) {
            Parameter paramAnnotation = field.getAnnotation(Parameter.class);
            if (paramAnnotation != null) {
                field.setAccessible(true);
                try {
                    Object value = field.get(this);
                    params.put(paramAnnotation.value(), value);
                } catch (IllegalAccessException e) {
                    throw new RuntimeException("Failed to access field: " + field.getName(), e);
                }
            }
        }

        return params;
    }

    /**
     * ストアドファンクションを呼び出すためのSQL文を構築します。
     *
     * <p>PostgreSQLのファンクション呼び出し構文に従って、
     * {@code SELECT * FROM function_name(?, ?, ...)}形式のSQL文を生成します。</p>
     *
     * <h3>生成例:</h3>
     * <pre>{@code
     * // パラメータが2つの場合
     * SELECT * FROM sp_get_tasks(?, ?)
     *
     * // パラメータが0の場合
     * SELECT * FROM sp_get_public_balloons()
     * }</pre>
     *
     * @return 構築されたSQL文
     */
    protected String buildCallStatement() {
        Map<String, Object> params = getParameters();
        StringBuilder sql = new StringBuilder("SELECT * FROM ");
        sql.append(getFunctionName()).append("(");

        List<String> placeholders = new ArrayList<>();
        for (int i = 0; i < params.size(); i++) {
            placeholders.add("?");
        }
        sql.append(String.join(", ", placeholders));
        sql.append(")");

        return sql.toString();
    }

    /**
     * パラメータ値を配列として構築します。
     *
     * <p>配列の順序はフィールド宣言順序と一致し、
     * {@link #buildCallStatement()}で生成されたプレースホルダと対応します。</p>
     *
     * <h3>例:</h3>
     * <pre>{@code
     * @Parameter("p_user_id") private UUID userId = UUID.fromString("...");
     * @Parameter("p_limit") private Integer limit = 20;
     *
     * // 返される配列:
     * [UUID("..."), 20]
     * }</pre>
     *
     * @return パラメータ値の配列
     */
    protected Object[] buildParameterArray() {
        Map<String, Object> params = getParameters();
        return params.values().toArray();
    }
}
