# Stored Procedure Management

ストアドプロシージャをクラスベースで管理するフレームワークです。

## 設計方針

1. **Attributeベースのストアド定義**
   - `@StoredProcedure` でクラスにストアド名を指定
   - `@Parameter` でプロパティに引数名を指定
   - プロパティはcamelCase、DBの引数はsnake_case

2. **型安全な管理**
   - 引数はコンストラクタで指定
   - 戻り値はResultクラスで型付け
   - JdbcTemplateは不要（Executorが管理）

3. **C#スタイルの実行**
   - `StoredProcedureExecutor` を使用してインスタンスを渡すだけで実行
   - 拡張メソッドのような使用感

## 使用例

### 基本的な使い方

```java
@Service
public class TaskService {

    private final StoredProcedureExecutor executor;

    public TaskService(StoredProcedureExecutor executor) {
        this.executor = executor;
    }

    public Task createTask(UUID userId, String title, String memo, OffsetDateTime dueAt) {
        // 1. ストアドプロシージャのインスタンスを生成
        CreateTaskProcedure procedure = new CreateTaskProcedure(
            userId,
            title,
            memo,
            dueAt
        );

        // 2. Executorで実行（C#の拡張メソッドのようなスタイル）
        CreateTaskProcedure.Result result = executor.executeForSingleRequired(procedure);

        // 3. Resultをドメインエンティティに変換
        return mapToEntity(result);
    }

    public List<Task> getTasks(UUID userId, int limit, int offset) {
        GetTasksProcedure procedure = new GetTasksProcedure(userId, limit, offset);

        List<GetTasksProcedure.Result> results = executor.execute(procedure);

        return results.stream()
            .map(this::mapToEntity)
            .toList();
    }

    public Optional<Task> getTaskById(UUID taskId, UUID userId) {
        GetTaskByIdProcedure procedure = new GetTaskByIdProcedure(taskId, userId);

        GetTaskByIdProcedure.Result result = executor.executeForSingle(procedure);

        return Optional.ofNullable(result).map(this::mapToEntity);
    }
}
```

### Executor のメソッド

```java
public class StoredProcedureExecutor {

    /**
     * ストアドプロシージャを実行し、結果のリストを返す
     */
    public <TResult> List<TResult> execute(StoredProcedureCall<TResult> procedure);

    /**
     * ストアドプロシージャを実行し、最初の結果を返す（結果がない場合はnull）
     */
    public <TResult> TResult executeForSingle(StoredProcedureCall<TResult> procedure);

    /**
     * ストアドプロシージャを実行し、最初の結果を返す（結果がない場合は例外）
     */
    public <TResult> TResult executeForSingleRequired(StoredProcedureCall<TResult> procedure);
}
```

### ストアドプロシージャクラスの定義方法

```java
package com.tasbal.backend.infrastructure.db.stored.task;

import com.tasbal.backend.infrastructure.db.stored.BaseStoredProcedure;
import com.tasbal.backend.infrastructure.db.stored.annotation.Parameter;
import com.tasbal.backend.infrastructure.db.stored.annotation.StoredProcedure;
import org.springframework.jdbc.core.RowMapper;

import java.time.OffsetDateTime;
import java.util.UUID;

/**
 * タスク作成ストアドプロシージャ {@code sp_create_task} の呼び出しクラス。
 */
@StoredProcedure("sp_create_task")  // ストアド名を指定
public class CreateTaskProcedure extends BaseStoredProcedure<CreateTaskProcedure.Result> {

    /** ユーザーID */
    @Parameter("p_user_id")  // DB上のパラメータ名（snake_case）
    private UUID userId;     // Javaのフィールド名（camelCase）

    /** タスクのタイトル */
    @Parameter("p_title")
    private String title;

    /** タスクのメモ */
    @Parameter("p_memo")
    private String memo;

    /** タスクの期限日時 */
    @Parameter("p_due_at")
    private OffsetDateTime dueAt;

    /**
     * コンストラクタ。
     * パラメータの順序はフィールド宣言順序と一致させる。
     */
    public CreateTaskProcedure(UUID userId, String title, String memo, OffsetDateTime dueAt) {
        super(new ResultRowMapper());
        this.userId = userId;
        this.title = title;
        this.memo = memo;
        this.dueAt = dueAt;
    }

    /**
     * ストアドプロシージャの戻り値を表すクラス。
     */
    public static class Result {
        /** タスクID */
        private UUID id;

        /** タスクのタイトル */
        private String title;

        // ... その他のプロパティ ...

        // getter/setter
        public UUID getId() { return id; }
        public void setId(UUID id) { this.id = id; }
        public String getTitle() { return title; }
        public void setTitle(String title) { this.title = title; }
    }

    /**
     * ResultSetから Result へのマッピングを行う RowMapper。
     */
    private static class ResultRowMapper implements RowMapper<Result> {
        @Override
        public Result mapRow(java.sql.ResultSet rs, int rowNum) throws java.sql.SQLException {
            Result result = new Result();
            result.setId((UUID) rs.getObject("id"));
            result.setTitle(rs.getString("title"));
            // ... その他のカラムのマッピング ...
            return result;
        }
    }
}
```

### Repositoryでの実装例

```java
package com.tasbal.backend.infrastructure.db.jdbc;

import com.tasbal.backend.domain.model.Task;
import com.tasbal.backend.domain.repository.TaskRepository;
import com.tasbal.backend.infrastructure.db.stored.StoredProcedureExecutor;
import com.tasbal.backend.infrastructure.db.stored.task.*;
import org.springframework.stereotype.Repository;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public class JdbcTaskRepository implements TaskRepository {

    private final StoredProcedureExecutor executor;

    public JdbcTaskRepository(StoredProcedureExecutor executor) {
        this.executor = executor;
    }

    @Override
    public Task create(UUID userId, String title, String memo, OffsetDateTime dueAt) {
        // ストアドプロシージャのインスタンスを作成
        CreateTaskProcedure procedure = new CreateTaskProcedure(userId, title, memo, dueAt);

        // Executorで実行
        CreateTaskProcedure.Result result = executor.executeForSingleRequired(procedure);

        // ドメインエンティティに変換
        return mapToEntity(result);
    }

    @Override
    public List<Task> findByUserId(UUID userId, int limit, int offset) {
        GetTasksProcedure procedure = new GetTasksProcedure(userId, limit, offset);

        List<GetTasksProcedure.Result> results = executor.execute(procedure);

        return results.stream()
            .map(this::mapToEntity)
            .toList();
    }

    @Override
    public Optional<Task> findById(UUID taskId, UUID userId) {
        GetTaskByIdProcedure procedure = new GetTaskByIdProcedure(taskId, userId);

        GetTaskByIdProcedure.Result result = executor.executeForSingle(procedure);

        return Optional.ofNullable(result).map(this::mapToEntity);
    }

    private Task mapToEntity(CreateTaskProcedure.Result result) {
        return new Task(
            result.getId(),
            result.getUserId(),
            result.getTitle(),
            result.getMemo(),
            result.getDueAt(),
            result.getStatus(),
            result.getPinned(),
            result.getCompletedAt(),
            result.getCreatedAt(),
            result.getUpdatedAt()
        );
    }
}
```

## ディレクトリ構成

```text
infrastructure/db/stored/
├── annotation/
│   ├── StoredProcedure.java     # ストアド名を指定するアノテーション
│   └── Parameter.java           # パラメータ名を指定するアノテーション
├── StoredProcedureCall.java     # インターフェース
├── BaseStoredProcedure.java     # 基底クラス
├── StoredProcedureExecutor.java # 実行クラス（C#の拡張メソッド風）
├── task/
│   ├── CreateTaskProcedure.java
│   ├── GetTasksProcedure.java
│   ├── GetTaskByIdProcedure.java
│   ├── UpdateTaskProcedure.java
│   ├── ToggleTaskCompletionProcedure.java
│   └── DeleteTaskProcedure.java
├── balloon/
│   ├── CreateBalloonProcedure.java
│   ├── GetPublicBalloonsProcedure.java
│   ├── SetBalloonSelectionProcedure.java
│   └── GetBalloonSelectionProcedure.java
└── user/
    ├── CreateGuestUserProcedure.java
    ├── GetUserByIdProcedure.java
    ├── GetUserSettingsProcedure.java
    └── UpdateUserSettingsProcedure.java
```

## 利点

1. **型安全**: コンパイル時に引数や戻り値の型チェックが可能
2. **保守性**: ストアド名と引数名が一箇所で管理される
3. **可読性**: アノテーションで意図が明確
4. **C#スタイル**: Executorを使った直感的な実行方法
5. **テスト容易性**: モックやスタブが簡単に作成できる
6. **ドキュメント**: Javadocで詳細な説明を記載

## 規約

### 1. クラス名

- **形式**: `{操作名}Procedure`
- **例**: `CreateTaskProcedure`, `GetTasksProcedure`

### 2. プロパティ名

- **形式**: camelCase
- **例**: `userId`, `dueAt`, `isPublic`

### 3. @Parameter値

- **形式**: ストアドの引数名（snake_case）
- **プレフィックス**: 通常は `p_` を付ける
- **例**: `@Parameter("p_user_id")`, `@Parameter("p_due_at")`

### 4. Result クラス

- **配置**: ストアドプロシージャクラスの内部static class
- **命名**: `Result`
- **内容**: ストアドの戻り値の全カラムをプロパティとして定義
- **アクセサ**: getter/setterを提供

### 5. RowMapper クラス

- **配置**: ストアドプロシージャクラスの内部static class
- **命名**: `ResultRowMapper`
- **実装**: `RowMapper<Result>`を実装
- **責務**: ResultSetからResultオブジェクトへのマッピング

### 6. Javadoc

- **クラス**: 必須。ストアドの目的と使用例を記載
- **フィールド**: 必須。各パラメータの意味を記載
- **コンストラクタ**: 必須。引数の説明を記載
- **Resultクラス**: 必須。戻り値の説明を記載
- **Resultプロパティ**: 必須。各カラムの意味を記載

## アーキテクチャ上の位置づけ

```text
presentation -> application -> domain <- infrastructure
                                            ↑
                                        db/stored/
                                        db/jdbc/ (Repository実装)
```

- **infrastructure/db/stored**: ストアドプロシージャ定義（技術詳細）
- **infrastructure/db/jdbc**: Repository実装（ドメインとストアドの橋渡し）
- **domain/repository**: Repository インターフェース（ドメイン層）

ストアドプロシージャクラスはInfrastructure層の技術詳細として実装され、
Repository実装クラスがドメインエンティティとの変換を担当します。
