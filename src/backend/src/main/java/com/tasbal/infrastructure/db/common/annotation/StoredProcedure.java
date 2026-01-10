package com.tasbal.infrastructure.db.common.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * ストアドプロシージャを示すアノテーション。
 *
 * <p>PostgreSQLの{@code CREATE PROCEDURE}で作成されたプロシージャに対応します。
 * ストアドプロシージャは以下の特徴を持ちます:</p>
 *
 * <ul>
 *   <li>値を返さない（副作用のみ）</li>
 *   <li>{@code CALL}文で呼び出し</li>
 *   <li>トランザクション制御が可能 ({@code COMMIT}, {@code ROLLBACK})</li>
 *   <li>PostgreSQL 11以降で利用可能</li>
 * </ul>
 *
 * <p><strong>注意:</strong> 現在のTasbalプロジェクトでは、すべてのDB操作に
 * {@code RETURNS TABLE}を使用する{@link StoredFunction}を採用しています。
 * このアノテーションは将来の拡張のために用意されています。</p>
 *
 * <h3>使用例:</h3>
 * <pre>{@code
 * @StoredProcedure("sp_cleanup_old_data")
 * public class CleanupOldDataProcedure extends BaseStoredProcedure {
 *     @Parameter("p_days_old")
 *     private Integer daysOld;
 *
 *     // 実装...
 * }
 * }</pre>
 *
 * <h3>対応するSQL:</h3>
 * <pre>{@code
 * CREATE OR REPLACE PROCEDURE sp_cleanup_old_data(p_days_old INTEGER)
 * LANGUAGE plpgsql
 * AS $$
 * BEGIN
 *     DELETE FROM tasks WHERE created_at < NOW() - (p_days_old || ' days')::INTERVAL;
 *     COMMIT;
 * END;
 * $$;
 * }</pre>
 *
 * @author Tasbal Team
 * @since 1.0.0
 * @see StoredFunction
 * @see Parameter
 */
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
public @interface StoredProcedure {

    /**
     * ストアドプロシージャの名前。
     *
     * <p>PostgreSQLデータベースに定義されているプロシージャ名と一致する必要があります。</p>
     *
     * @return ストアドプロシージャ名
     */
    String value();
}
