package com.tasbal.backend.infrastructure.db.common;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * ストアドプロシージャを実行するためのユーティリティクラス。
 *
 * <p>C#の拡張メソッドのように、{@link StoredProcedureCall}のインスタンスを渡すだけで
 * ストアドプロシージャを実行できます。</p>
 *
 * <h3>使用例:</h3>
 * <pre>{@code
 * CreateTaskProcedure procedure = new CreateTaskProcedure(userId, title, memo, dueAt);
 * List<CreateTaskProcedure.Result> results = executor.execute(procedure);
 * }</pre>
 *
 * @author Tasbal Team
 * @since 1.0.0
 */
@Component
public class StoredProcedureExecutor {

    private final JdbcTemplate jdbcTemplate;

    /**
     * コンストラクタ。
     *
     * @param jdbcTemplate Spring JDBCテンプレート
     */
    public StoredProcedureExecutor(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    /**
     * ストアドプロシージャを実行します。
     *
     * <p>このメソッドは、{@link StoredProcedureCall}インターフェースを実装した
     * 任意のストアドプロシージャクラスを実行できます。</p>
     *
     * @param <TResult> 戻り値の型
     * @param procedure 実行するストアドプロシージャ
     * @return ストアドプロシージャの実行結果のリスト
     * @throws RuntimeException ストアドプロシージャの実行に失敗した場合
     */
    public <TResult> List<TResult> execute(StoredProcedureCall<TResult> procedure) {
        return procedure.executeWith(jdbcTemplate);
    }

    /**
     * ストアドプロシージャを実行し、最初の結果を返します。
     *
     * <p>結果が存在しない場合は{@code null}を返します。</p>
     *
     * @param <TResult> 戻り値の型
     * @param procedure 実行するストアドプロシージャ
     * @return ストアドプロシージャの実行結果の最初の要素、または{@code null}
     * @throws RuntimeException ストアドプロシージャの実行に失敗した場合
     */
    public <TResult> TResult executeForSingle(StoredProcedureCall<TResult> procedure) {
        List<TResult> results = execute(procedure);
        return results.isEmpty() ? null : results.get(0);
    }

    /**
     * ストアドプロシージャを実行し、結果が存在することを保証します。
     *
     * <p>結果が存在しない場合は{@link IllegalStateException}をスローします。</p>
     *
     * @param <TResult> 戻り値の型
     * @param procedure 実行するストアドプロシージャ
     * @return ストアドプロシージャの実行結果の最初の要素
     * @throws IllegalStateException 結果が存在しない場合
     * @throws RuntimeException ストアドプロシージャの実行に失敗した場合
     */
    public <TResult> TResult executeForSingleRequired(StoredProcedureCall<TResult> procedure) {
        TResult result = executeForSingle(procedure);
        if (result == null) {
            throw new IllegalStateException(
                "Stored procedure " + procedure.getProcedureName() + " returned no results"
            );
        }
        return result;
    }
}
