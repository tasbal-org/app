# CLAUDE.md（Tasbal / タスバル）

このドキュメントは、Tasbal リポジトリで Claude（AI）に開発支援を依頼するときの **プロジェクト規約** です。
要件・実装方針・命名・フォルダ構成・DB アクセス（ストアド運用）をここに集約します。

---

## 0. プロダクト前提（重要）

Tasbal は「個人のタスク達成が、みんなの達成感につながる」共有バルーン型タスク管理アプリ。
競争や数値評価を避け、達成体験を共有する。

---

## 1. 技術スタック前提

> **仕様書・詳細設計・DB 設計・業務ルールなどの一次情報は、必ず以下を参照すること**
>
> ```
> /workspaces/app/docs
> ```
>
> Claude（AI）は推測で補完せず、原則としてこのディレクトリ配下のドキュメント内容を正とする。

- Backend: **Java 21 / Spring Boot**
- DB: **PostgreSQL**
- Frontend: Flutter（この CLAUDE.md は主に Backend 規約）
- SQL 実装ポリシー:
  - **SQL は必ずストアドプロシージャ（またはストアドファンクション）経由**
  - **ストアドの返り値は常に “テーブル（ResultSet）” として返す**
  - **リレーションテーブルがある場合に限り**、その内容は **JSON（推奨: jsonb）または配列** で受け渡しする

---

## 2. アーキテクチャ方針（DDD）

### 2.1 レイヤ構成と依存方向

```
presentation -> application -> domain <- infrastructure
```

- domain: ビジネスルール（エンティティ / 値オブジェクト / ドメインサービス）
- application: ユースケース（トランザクション境界、入力検証、権限制御）
- infrastructure: DB / 外部 API / メッセージングなど技術詳細
- presentation: REST Controller（HTTP 責務、DTO 変換のみ）

> ドメインクラスはテーブル定義書から自動生成予定のため、当面は AI が無理に生成しない。

---

## 3. 推奨フォルダ構成

```
backend/
  src/main/java/com/tasbal/
    presentation/
      controller/
      dto/
      mapper/
      exception/
    application/
      usecase/
      command/
      query/
      service/
    domain/
      model/
      service/
      repository/
      value/
    infrastructure/
      db/
        stored/
        jdbc/
        mapper/
      config/
      external/
  src/main/resources/
    db/
      stored/
    application.yml
```

---

## 4. DB（ストアド）規約

### 4.1 基本ルール

- すべての DB 操作は **ストアド経由**
- 戻り値は必ず **テーブル形式**
- 更新系も `SELECT` により結果を返す

### 4.2 リレーションテーブル

- リレーションテーブルがある場合のみ以下を許可
  - JSON（jsonb）
  - 配列（uuid[] / int[] など）

---

## 5. Java 側：ストアド管理方針

- ストアド名・引数・型・戻り列は **オブジェクトで一元管理**
- 文字列直書きは禁止
- JDBC / Spring JDBC どちらでも可

---

## 6. Java コーディング規約

### 6.1 インデント

- **スペース 4 つ**
- タブ文字は禁止

### 6.2 命名

- クラス: PascalCase
- メソッド / 変数: camelCase
- 定数: UPPER_SNAKE_CASE

### 6.3 文法・設計指針

- ネストを浅く（早期 return）
- null を極力使わない
- 例外は意味のある型へ変換
- DTO / Command は不変を基本とする

---

## 7. API 実装方針

- Controller は薄く
- バリデーションは API 側で実施
- 複合ルールは application 層で検証

---

## 8. SQL 管理

- `resources/db/stored` に SQL を配置
- 1 ストアド = 1 ファイル
- 雛形には引数・戻り列・エラーコードを明示

---

## 9. Claude への依頼ルール

1. SQL は必ずストアド経由
2. 戻りはテーブル
3. リレーションがある場合のみ JSON / 配列
4. DDD 構成を維持
5. ストアド定義はオブジェクト管理
6. インデントはスペース 4 つ
7. ドメインモデルは最小限

---

## 10. 禁止事項

- Controller 直 DB
- SQL 直書き
- スカラー返却ストアド
- 不要な JSON 化
- DDD 無視の util 集約
