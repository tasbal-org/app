package com.tasbal.backend.infrastructure.db.common.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * ストアドファンクションを示すアノテーション。
 *
 * <p>PostgreSQLの{@code CREATE FUNCTION}で作成された関数に対応します。
 * ストアドファンクションは以下の特徴を持ちます:</p>
 *
 * <ul>
 *   <li>値を返す ({@code RETURNS TABLE}, {@code RETURNS SETOF}, {@code RETURNS type})</li>
 *   <li>{@code SELECT}文で呼び出し可能</li>
 *   <li>副作用を持つことは推奨されないが、可能</li>
 *   <li>トランザクション制御はできない</li>
 * </ul>
 *
 * <h3>使用例:</h3>
 * <pre>{@code
 * @StoredFunction("sp_get_user_by_id")
 * public class GetUserByIdFunction extends BaseStoredFunction<GetUserByIdFunction.Result> {
 *     @Parameter("p_user_id")
 *     private UUID userId;
 *
 *     // 実装...
 * }
 * }</pre>
 *
 * <h3>対応するSQL:</h3>
 * <pre>{@code
 * CREATE OR REPLACE FUNCTION sp_get_user_by_id(p_user_id UUID)
 * RETURNS TABLE(
 *     id UUID,
 *     handle VARCHAR,
 *     ...
 * ) AS $$
 * BEGIN
 *     RETURN QUERY
 *     SELECT u.id, u.handle, ...
 *     FROM users u
 *     WHERE u.id = p_user_id;
 * END;
 * $$ LANGUAGE plpgsql;
 * }</pre>
 *
 * @author Tasbal Team
 * @since 1.0.0
 * @see StoredProcedure
 * @see Parameter
 */
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
public @interface StoredFunction {

    /**
     * ストアドファンクションの名前。
     *
     * <p>PostgreSQLデータベースに定義されている関数名と一致する必要があります。</p>
     *
     * @return ストアドファンクション名
     */
    String value();
}
