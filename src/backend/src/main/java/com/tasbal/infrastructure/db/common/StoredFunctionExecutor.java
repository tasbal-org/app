package com.tasbal.infrastructure.db.common;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * ストアドファンクションを実行するためのエグゼキュータクラス。
 *
 * <p>このクラスは、{@link StoredFunctionCall}インターフェースを実装した
 * ストアドファンクションクラスを実行するための便利なユーティリティを提供します。
 * C#の拡張メソッドのように、ファンクションインスタンスを渡すだけで実行できます。</p>
 *
 * <h2>主な機能</h2>
 * <ul>
 *   <li><strong>リスト取得:</strong> {@link #execute} - すべての結果行をリストで取得</li>
 *   <li><strong>単一行取得:</strong> {@link #executeForSingle} - 最初の行のみ取得(なければnull)</li>
 *   <li><strong>必須単一行:</strong> {@link #executeForSingleRequired} - 最初の行を取得(なければ例外)</li>
 * </ul>
 *
 * <h2>使用例</h2>
 *
 * <h3>リストで取得:</h3>
 * <pre>{@code
 * @Autowired
 * private StoredFunctionExecutor executor;
 *
 * public List<Task> getTasks(UUID userId, int limit, int offset) {
 *     GetTasksFunction function = new GetTasksFunction(userId, limit, offset);
 *     List<GetTasksFunction.Result> results = executor.execute(function);
 *     return results.stream()
 *         .map(this::mapToTask)
 *         .collect(Collectors.toList());
 * }
 * }</pre>
 *
 * <h3>単一行で取得:</h3>
 * <pre>{@code
 * public User getUserById(UUID userId) {
 *     GetUserByIdFunction function = new GetUserByIdFunction(userId);
 *     GetUserByIdFunction.Result result = executor.executeForSingle(function);
 *
 *     if (result == null) {
 *         throw new UserNotFoundException("User not found: " + userId);
 *     }
 *
 *     return mapToUser(result);
 * }
 * }</pre>
 *
 * <h3>必須の単一行で取得:</h3>
 * <pre>{@code
 * public User createGuestUser(String handle) {
 *     CreateGuestUserFunction function = new CreateGuestUserFunction(handle);
 *     // 結果がなければIllegalStateExceptionがスローされる
 *     CreateGuestUserFunction.Result result = executor.executeForSingleRequired(function);
 *     return mapToUser(result);
 * }
 * }</pre>
 *
 * <h2>スレッドセーフティ</h2>
 * <p>このクラスは<strong>スレッドセーフ</strong>です。
 * Spring DIコンテナによってシングルトンとして管理され、
 * 複数のスレッドから同時に使用できます。</p>
 *
 * <h2>トランザクション</h2>
 * <p>このエグゼキュータ自体はトランザクション管理を行いません。
 * トランザクションは、呼び出し元のサービス層で{@code @Transactional}
 * アノテーションを使用して管理してください:</p>
 *
 * <pre>{@code
 * @Service
 * @Transactional
 * public class UserService {
 *     @Autowired
 *     private StoredFunctionExecutor executor;
 *
 *     public User createGuestUser(String handle) {
 *         // このメソッド全体が1つのトランザクションで実行される
 *         CreateGuestUserFunction function = new CreateGuestUserFunction(handle);
 *         CreateGuestUserFunction.Result result = executor.executeForSingleRequired(function);
 *         return mapToUser(result);
 *     }
 * }
 * }</pre>
 *
 * <h2>エラーハンドリング</h2>
 * <p>データベースエラーは、SpringのDataAccessExceptionとしてスローされます。
 * 主なエラータイプ:</p>
 *
 * <ul>
 *   <li>{@code BadSqlGrammarException} - ファンクションが存在しない、SQL構文エラー</li>
 *   <li>{@code DataIntegrityViolationException} - 一意制約違反、外部キー制約違反</li>
 *   <li>{@code QueryTimeoutException} - クエリタイムアウト</li>
 *   <li>{@code TransientDataAccessResourceException} - DB接続エラー</li>
 * </ul>
 *
 * @author Tasbal Team
 * @since 1.0.0
 * @see StoredFunctionCall
 * @see BaseStoredFunction
 */
@Component
public class StoredFunctionExecutor {

    /**
     * Spring JDBCテンプレート。
     *
     * <p>データベースクエリの実行、結果のマッピング、例外変換などを
     * 行うSpring Frameworkの中核コンポーネントです。</p>
     */
    private final JdbcTemplate jdbcTemplate;

    /**
     * コンストラクタ。
     *
     * <p>Spring DIコンテナによって自動的に呼び出されます。
     * JdbcTemplateは、DataSourceから自動的に構成されます。</p>
     *
     * @param jdbcTemplate Spring JDBCテンプレート
     * @throws IllegalArgumentException jdbcTemplateがnullの場合
     */
    public StoredFunctionExecutor(JdbcTemplate jdbcTemplate) {
        if (jdbcTemplate == null) {
            throw new IllegalArgumentException("JdbcTemplate must not be null");
        }
        this.jdbcTemplate = jdbcTemplate;
    }

    /**
     * ストアドファンクションを実行し、すべての結果行をリストで返します。
     *
     * <p>このメソッドは、{@link StoredFunctionCall}インターフェースを実装した
     * 任意のストアドファンクションクラスを実行できます。</p>
     *
     * <h3>使用例:</h3>
     * <pre>{@code
     * GetTasksFunction function = new GetTasksFunction(userId, 20, 0);
     * List<GetTasksFunction.Result> results = executor.execute(function);
     *
     * // 結果が0件の場合
     * if (results.isEmpty()) {
     *     // タスクが存在しない
     * }
     * }</pre>
     *
     * <h3>パフォーマンス考慮:</h3>
     * <ul>
     *   <li>大量のデータを取得する場合は、ファンクション側でLIMIT/OFFSETを使用してページネーションを実装</li>
     *   <li>結果セットはすべてメモリに読み込まれるため、データ量に注意</li>
     * </ul>
     *
     * @param <TResult> 戻り値の型
     * @param function 実行するストアドファンクション
     * @return ストアドファンクションの実行結果のリスト。結果が0件の場合は空のリスト
     * @throws IllegalArgumentException functionがnullの場合
     * @throws org.springframework.dao.DataAccessException ストアドファンクションの実行に失敗した場合
     */
    public <TResult> List<TResult> execute(StoredFunctionCall<TResult> function) {
        if (function == null) {
            throw new IllegalArgumentException("StoredFunctionCall must not be null");
        }
        return function.executeWith(jdbcTemplate);
    }

    /**
     * ストアドファンクションを実行し、最初の結果行のみを返します。
     *
     * <p>結果が存在しない場合は{@code null}を返します。
     * このメソッドは、単一行のみを取得することが期待される場合に便利です。</p>
     *
     * <h3>使用例:</h3>
     * <pre>{@code
     * GetUserByIdFunction function = new GetUserByIdFunction(userId);
     * GetUserByIdFunction.Result result = executor.executeForSingle(function);
     *
     * if (result == null) {
     *     throw new UserNotFoundException("User not found: " + userId);
     * }
     *
     * return mapToUser(result);
     * }</pre>
     *
     * <h3>複数行が返された場合:</h3>
     * <p>ストアドファンクションが複数行を返す場合でも、このメソッドは
     * 最初の行のみを返し、残りの行は無視されます。</p>
     *
     * @param <TResult> 戻り値の型
     * @param function 実行するストアドファンクション
     * @return ストアドファンクションの実行結果の最初の要素、または{@code null}
     * @throws IllegalArgumentException functionがnullの場合
     * @throws org.springframework.dao.DataAccessException ストアドファンクションの実行に失敗した場合
     */
    public <TResult> TResult executeForSingle(StoredFunctionCall<TResult> function) {
        List<TResult> results = execute(function);
        return results.isEmpty() ? null : results.get(0);
    }

    /**
     * ストアドファンクションを実行し、結果が存在することを保証します。
     *
     * <p>結果が存在しない場合は{@link IllegalStateException}をスローします。
     * このメソッドは、必ず結果が返されることが期待される場合に使用します。</p>
     *
     * <h3>使用例:</h3>
     * <pre>{@code
     * CreateGuestUserFunction function = new CreateGuestUserFunction(handle);
     * // ゲストユーザー作成は必ず成功するはずなので、executeForSingleRequiredを使用
     * CreateGuestUserFunction.Result result = executor.executeForSingleRequired(function);
     * return mapToUser(result);
     * }</pre>
     *
     * <h3>例外がスローされる場合:</h3>
     * <ul>
     *   <li>ストアドファンクションが0行を返した場合</li>
     *   <li>ファンクション内でエラーが発生し、結果が返されなかった場合</li>
     * </ul>
     *
     * @param <TResult> 戻り値の型
     * @param function 実行するストアドファンクション
     * @return ストアドファンクションの実行結果の最初の要素
     * @throws IllegalArgumentException functionがnullの場合
     * @throws IllegalStateException 結果が存在しない場合
     * @throws org.springframework.dao.DataAccessException ストアドファンクションの実行に失敗した場合
     */
    public <TResult> TResult executeForSingleRequired(StoredFunctionCall<TResult> function) {
        TResult result = executeForSingle(function);
        if (result == null) {
            String functionName = function != null ? function.getFunctionName() : "unknown";
            throw new IllegalStateException(
                "Stored function " + functionName + " returned no results, but a result was required"
            );
        }
        return result;
    }
}
