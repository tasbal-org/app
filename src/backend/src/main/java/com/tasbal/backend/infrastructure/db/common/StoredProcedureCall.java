package com.tasbal.backend.infrastructure.db.common;

import org.springframework.jdbc.core.JdbcTemplate;

import java.util.List;

/**
 * ストアドプロシージャ呼び出しを表すインターフェース。
 *
 * <p>すべてのストアドプロシージャクラスはこのインターフェースを実装します。
 * {@link StoredProcedureExecutor}を使用して実行することを推奨します。</p>
 *
 * @param <TResult> ストアドプロシージャの戻り値の型
 * @author Tasbal Team
 * @since 1.0.0
 */
public interface StoredProcedureCall<TResult> {

    /**
     * ストアドプロシージャの名前を取得します。
     *
     * @return ストアドプロシージャの名前（例: "sp_create_task"）
     */
    String getProcedureName();

    /**
     * {@link JdbcTemplate}を使用してストアドプロシージャを実行します。
     *
     * <p>このメソッドは{@link StoredProcedureExecutor}から呼び出されることを想定しています。
     * 直接呼び出すのではなく、{@link StoredProcedureExecutor#execute(StoredProcedureCall)}を使用してください。</p>
     *
     * @param jdbcTemplate Spring JDBCテンプレート
     * @return ストアドプロシージャの実行結果のリスト
     */
    List<TResult> executeWith(JdbcTemplate jdbcTemplate);
}
