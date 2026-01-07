package com.tasbal.backend.infrastructure.db.stored;

import com.tasbal.backend.infrastructure.db.stored.annotation.Parameter;
import com.tasbal.backend.infrastructure.db.stored.annotation.StoredProcedure;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * ストアドプロシージャの基底クラス。
 *
 * <p>すべてのストアドプロシージャクラスはこのクラスを継承します。
 * パラメータの収集、SQL文の構築、実行を共通化します。</p>
 *
 * <h3>実装方法:</h3>
 * <pre>{@code
 * @StoredProcedure("sp_create_task")
 * public class CreateTaskProcedure extends BaseStoredProcedure<CreateTaskProcedure.Result> {
 *
 *     @Parameter("p_user_id")
 *     private UUID userId;
 *
 *     @Parameter("p_title")
 *     private String title;
 *
 *     public CreateTaskProcedure(UUID userId, String title) {
 *         super(new ResultRowMapper());
 *         this.userId = userId;
 *         this.title = title;
 *     }
 *
 *     public static class Result {
 *         // 戻り値のプロパティ
 *     }
 *
 *     private static class ResultRowMapper implements RowMapper<Result> {
 *         // マッピング処理
 *     }
 * }
 * }</pre>
 *
 * @param <TResult> ストアドプロシージャの戻り値の型
 * @author Tasbal Team
 * @since 1.0.0
 */
public abstract class BaseStoredProcedure<TResult> implements StoredProcedureCall<TResult> {

    /**
     * ResultSetから結果オブジェクトへのマッピングを行うRowMapper。
     */
    protected final RowMapper<TResult> rowMapper;

    /**
     * コンストラクタ。
     *
     * @param rowMapper ResultSetから結果オブジェクトへのマッピングを行うRowMapper
     */
    protected BaseStoredProcedure(RowMapper<TResult> rowMapper) {
        this.rowMapper = rowMapper;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String getProcedureName() {
        StoredProcedure annotation = this.getClass().getAnnotation(StoredProcedure.class);
        if (annotation == null) {
            throw new IllegalStateException("@StoredProcedure annotation is required on " + this.getClass().getName());
        }
        return annotation.value();
    }

    /**
     * {@inheritDoc}
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
     * <p>パラメータの順序はフィールド宣言順序に依存します。</p>
     *
     * @return パラメータ名と値のマップ（順序保証）
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
     * ストアドプロシージャを呼び出すためのSQL文を構築します。
     *
     * <p>例: {@code SELECT * FROM sp_create_task(?, ?, ?)}</p>
     *
     * @return 構築されたSQL文
     */
    protected String buildCallStatement() {
        Map<String, Object> params = getParameters();
        StringBuilder sql = new StringBuilder("SELECT * FROM ");
        sql.append(getProcedureName()).append("(");

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
     * <p>配列の順序はフィールド宣言順序と一致します。</p>
     *
     * @return パラメータ値の配列
     */
    protected Object[] buildParameterArray() {
        Map<String, Object> params = getParameters();
        return params.values().toArray();
    }
}
