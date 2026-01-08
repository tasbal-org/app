package com.tasbal.backend.infrastructure.db.common.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * ストアドプロシージャのパラメータ名を指定するアノテーション。
 *
 * <p>このアノテーションはストアドプロシージャクラスのフィールドに付与され、
 * データベース上のパラメータ名を指定します。</p>
 *
 * <p>Javaのフィールド名はcamelCaseで記述し、データベースのパラメータ名は
 * snake_caseで指定します。</p>
 *
 * <h3>使用例:</h3>
 * <pre>{@code
 * @StoredProcedure("sp_create_task")
 * public class CreateTaskProcedure extends BaseStoredProcedure<CreateTaskProcedure.Result> {
 *
 *     @Parameter("p_user_id")  // DB上のパラメータ名（snake_case）
 *     private UUID userId;      // Javaのフィールド名（camelCase）
 *
 *     @Parameter("p_title")
 *     private String title;
 * }
 * }</pre>
 *
 * @author Tasbal Team
 * @since 1.0.0
 */
@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
public @interface Parameter {

    /**
     * データベース上のパラメータ名。
     *
     * <p>通常は"p_"プレフィックスを付けたsnake_case形式で指定します。</p>
     *
     * @return パラメータ名（例: "p_user_id"）
     */
    String value();
}
