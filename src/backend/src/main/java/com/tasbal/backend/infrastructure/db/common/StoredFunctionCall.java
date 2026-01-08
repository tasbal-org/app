package com.tasbal.backend.infrastructure.db.common;

import org.springframework.jdbc.core.JdbcTemplate;

import java.util.List;

/**
 * ストアドファンクション呼び出しを表すインターフェース。
 *
 * <p>このインターフェースは、PostgreSQLのストアドファンクション({@code CREATE FUNCTION})を
 * Javaから実行するための契約を定義します。</p>
 *
 * <h2>目的</h2>
 * <p>このインターフェースは、以下の目的で設計されています:</p>
 *
 * <ul>
 *   <li><strong>型安全性:</strong> ジェネリクスにより、コンパイル時に戻り値の型を保証</li>
 *   <li><strong>統一インターフェース:</strong> すべてのストアドファンクションを同じ方法で実行</li>
 *   <li><strong>拡張性:</strong> 新しいファンクションの追加が容易</li>
 *   <li><strong>テスタビリティ:</strong> モックやスタブの作成が容易</li>
 * </ul>
 *
 * <h2>実装クラス</h2>
 * <p>通常、{@link BaseStoredFunction}を継承することで、
 * このインターフェースを実装します。</p>
 *
 * <h3>実装例:</h3>
 * <pre>{@code
 * @StoredFunction("sp_get_user_by_id")
 * public class GetUserByIdFunction extends BaseStoredFunction<GetUserByIdFunction.Result>
 *         implements StoredFunctionCall<GetUserByIdFunction.Result> {
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
 *     // ResultRowMapper実装...
 * }
 * }</pre>
 *
 * <h2>使用方法</h2>
 * <p>このインターフェースを実装したクラスは、
 * {@link StoredFunctionExecutor}を通じて実行されます:</p>
 *
 * <pre>{@code
 * // 実行方法
 * GetUserByIdFunction function = new GetUserByIdFunction(userId);
 * List<GetUserByIdFunction.Result> results = executor.execute(function);
 *
 * // または、単一結果を取得
 * GetUserByIdFunction.Result result = executor.executeForSingle(function);
 * }</pre>
 *
 * <h2>ストアドファンクションとストアドプロシージャの違い</h2>
 * <table border="1">
 *   <tr>
 *     <th>特徴</th>
 *     <th>ストアドファンクション</th>
 *     <th>ストアドプロシージャ</th>
 *   </tr>
 *   <tr>
 *     <td>戻り値</td>
 *     <td>あり (RETURNS TABLE等)</td>
 *     <td>なし</td>
 *   </tr>
 *   <tr>
 *     <td>呼び出し方</td>
 *     <td>SELECT文</td>
 *     <td>CALL文</td>
 *   </tr>
 *   <tr>
 *     <td>トランザクション制御</td>
 *     <td>不可</td>
 *     <td>可能 (COMMIT/ROLLBACK)</td>
 *   </tr>
 *   <tr>
 *     <td>主な用途</td>
 *     <td>データ取得・変換</td>
 *     <td>データ更新・バッチ処理</td>
 *   </tr>
 * </table>
 *
 * @param <TResult> ストアドファンクションの戻り値の型。
 *                  通常は、ファンクションのRETURNS TABLE定義に対応するJavaクラス
 * @author Tasbal Team
 * @since 1.0.0
 * @see BaseStoredFunction
 * @see StoredFunctionExecutor
 */
public interface StoredFunctionCall<TResult> {

    /**
     * ストアドファンクションの名前を取得します。
     *
     * <p>PostgreSQLデータベースに定義されているファンクション名と一致する必要があります。
     * 通常、{@link com.tasbal.backend.infrastructure.db.stored.annotation.StoredFunction}
     * アノテーションで指定された値が返されます。</p>
     *
     * <h3>例:</h3>
     * <pre>{@code
     * @StoredFunction("sp_get_user_by_id")
     * public class GetUserByIdFunction extends BaseStoredFunction<...> {
     *     // getFunctionName() は "sp_get_user_by_id" を返す
     * }
     * }</pre>
     *
     * @return ストアドファンクション名 (例: "sp_get_user_by_id")
     * @throws IllegalStateException ファンクション名が設定されていない場合
     */
    String getFunctionName();

    /**
     * JdbcTemplateを使用してストアドファンクションを実行します。
     *
     * <p>このメソッドは、Spring JDBCの{@link JdbcTemplate}を使用して
     * PostgreSQLのストアドファンクションを実行し、結果を
     * Javaオブジェクトのリストとして返します。</p>
     *
     * <h3>実行の流れ:</h3>
     * <ol>
     *   <li>SQL呼び出し文を構築 ({@code SELECT * FROM function_name(?, ?)})</li>
     *   <li>パラメータをバインド</li>
     *   <li>PostgreSQLでファンクションを実行</li>
     *   <li>ResultSetをJavaオブジェクトにマッピング</li>
     *   <li>結果をリストとして返す</li>
     * </ol>
     *
     * <h3>例:</h3>
     * <pre>{@code
     * // ファンクション定義
     * GetUserByIdFunction function = new GetUserByIdFunction(userId);
     *
     * // 実行
     * JdbcTemplate jdbcTemplate = // Spring DIから取得
     * List<GetUserByIdFunction.Result> results = function.executeWith(jdbcTemplate);
     *
     * // 結果が0件の場合、空のリストが返される
     * if (results.isEmpty()) {
     *     // ユーザーが見つからなかった
     * }
     * }</pre>
     *
     * <h3>エラーハンドリング:</h3>
     * <p>実行中にエラーが発生した場合、SpringのDataAccessExceptionが
     * スローされます。主なエラー:</p>
     *
     * <ul>
     *   <li>{@code BadSqlGrammarException} - ファンクションが存在しない、SQL構文エラー</li>
     *   <li>{@code DataIntegrityViolationException} - 制約違反</li>
     *   <li>{@code TransientDataAccessResourceException} - 一時的なDB接続エラー</li>
     * </ul>
     *
     * @param jdbcTemplate Spring JDBCテンプレート
     * @return ストアドファンクションの実行結果のリスト。
     *         結果が0件の場合は空のリスト({@code Collections.emptyList()}相当)
     * @throws org.springframework.dao.DataAccessException データアクセスエラーが発生した場合
     * @throws IllegalStateException ファンクション名が未設定の場合
     */
    List<TResult> executeWith(JdbcTemplate jdbcTemplate);
}
