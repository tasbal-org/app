package com.tasbal.backend.infrastructure.db.stored.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * ストアドプロシージャ名を指定するアノテーション。
 *
 * <p>このアノテーションはストアドプロシージャクラスに付与され、
 * データベース上のストアドプロシージャ名を指定します。</p>
 *
 * <h3>使用例:</h3>
 * <pre>{@code
 * @StoredProcedure("sp_create_task")
 * public class CreateTaskProcedure extends BaseStoredProcedure<CreateTaskProcedure.Result> {
 *     // クラス実装
 * }
 * }</pre>
 *
 * @author Tasbal Team
 * @since 1.0.0
 */
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
public @interface StoredProcedure {

    /**
     * データベース上のストアドプロシージャ名。
     *
     * @return ストアドプロシージャ名（例: "sp_create_task"）
     */
    String value();
}
