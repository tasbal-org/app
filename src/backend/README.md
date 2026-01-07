# Tasbal Backend

タスク管理アプリ「Tasbal」のバックエンド API サーバー

## 技術スタック

- **Java**: 21
- **Spring Boot**: 3.4.1
- **データベース**: PostgreSQL 16
- **マイグレーション**: Flyway
- **認証**: Spring Security + OAuth2 Resource Server
- **API ドキュメント**: Swagger (springdoc-openapi 2.7.0)
- **ビルドツール**: Maven

## 主要な依存関係

- `spring-boot-starter-web` - REST API エンドポイント
- `spring-boot-starter-security` - セキュリティ機能
- `spring-boot-starter-oauth2-resource-server` - OAuth2 認証
- `spring-boot-starter-data-jpa` - JPA/Hibernate
- `flyway-core` - データベースマイグレーション
- `spring-boot-starter-validation` - バリデーション機能
- `spring-boot-starter-actuator` - ヘルスチェック・メトリクス
- `springdoc-openapi-starter-webmvc-ui` - Swagger UI
- `postgresql` - PostgreSQL ドライバー

## 前提条件

- Java 21 以上
- Maven 3.8 以上（または同梱の Maven Wrapper）
- Docker & Docker Compose（Docker 環境で実行する場合）

## セットアップ

### ローカル開発環境

1. **依存関係のインストール**

```bash
./mvnw clean install
```

2. **データベースの起動**（Docker 使用）

```bash
# プロジェクトルートから
docker-compose up -d db
```

3. **アプリケーションの起動**

```bash
./mvnw spring-boot:run
```

アプリケーションは http://localhost:8080 で起動します。

## API エンドポイント

アプリケーション起動後、以下のエンドポイントにアクセスできます：

### 🔍 Swagger UI（API ドキュメント）

インタラクティブなAPI仕様書とテスト環境：

- **Swagger UI**: <http://localhost:8080/swagger-ui.html>
- **OpenAPI JSON**: <http://localhost:8080/v3/api-docs>

Swagger UIから直接APIをテストすることができます。

### 🏥 Actuator（ヘルスチェック）

アプリケーションの状態監視：

- **ヘルスチェック**: <http://localhost:8080/actuator/health>
- **情報エンドポイント**: <http://localhost:8080/actuator/info>

### 🎯 REST API

すべてのビジネスロジック用API：

- **ベースURL**: <http://localhost:8080/api/v1>

### Docker 環境

#### 開発用（ホットリロード対応）

```bash
# プロジェクトルートから
docker-compose -f docker-compose.dev.yml up -d
```

開発用 Dockerfile は `Dockerfile.dev` を使用し、Spring Boot DevTools によるホットリロードに対応しています。

#### 本番用

```bash
# プロジェクトルートから
docker-compose up -d
```

本番用 Dockerfile はマルチステージビルドで最適化されており、軽量な JRE イメージを使用します。

## ビルド

### JAR ファイルのビルド

```bash
./mvnw clean package
```

生成された JAR ファイルは `target/` ディレクトリに配置されます。

### テストのスキップ

```bash
./mvnw clean package -DskipTests
```

### Docker イメージのビルド

```bash
# 本番用
docker build -f ../../infra/docker/backend/Dockerfile -t tasbal-backend:latest .

# 開発用
docker build -f ../../infra/docker/backend/Dockerfile.dev -t tasbal-backend:dev .
```

## テスト

### 全テストの実行

```bash
./mvnw test
```

### 特定のテストクラスの実行

```bash
./mvnw test -Dtest=TasbalBackendApplicationTests
```

## データベースマイグレーション

Flyway を使用したデータベースマイグレーションは、アプリケーション起動時に自動実行されます。

マイグレーションファイルの配置先:

```
src/main/resources/db/migration/
├── V1__init.sql
├── V2__add_users_table.sql
└── ...
```

### マイグレーション情報の確認

```bash
./mvnw flyway:info
```

### マイグレーションの実行（手動）

```bash
./mvnw flyway:migrate
```

## API 仕様

Base URL: `/api/v1`

### 認証

現在のMVP実装では、認証は簡略化されています。リクエストヘッダーに `X-User-Id` を指定してユーザーIDを渡してください。

### タスク API

#### タスク作成

```bash
curl -X POST http://localhost:8080/api/v1/tasks \
  -H "Content-Type: application/json" \
  -H "X-User-Id: <ユーザーID>" \
  -d '{
    "title": "散歩する",
    "memo": "10分だけでもOK",
    "dueAt": "2026-01-06T23:59:59+09:00"
  }'
```

#### タスク一覧取得

```bash
curl -X GET "http://localhost:8080/api/v1/tasks?limit=20&offset=0" \
  -H "X-User-Id: <ユーザーID>"
```

#### タスク取得

```bash
curl -X GET http://localhost:8080/api/v1/tasks/<タスクID> \
  -H "X-User-Id: <ユーザーID>"
```

#### タスク更新

```bash
curl -X PUT http://localhost:8080/api/v1/tasks/<タスクID> \
  -H "Content-Type: application/json" \
  -H "X-User-Id: <ユーザーID>" \
  -d '{
    "title": "散歩する（更新）",
    "memo": "30分歩く"
  }'
```

#### タスク完了切替

```bash
curl -X POST http://localhost:8080/api/v1/tasks/<タスクID>/toggle-done \
  -H "Content-Type: application/json" \
  -H "X-User-Id: <ユーザーID>" \
  -d '{
    "isDone": true
  }'
```

#### タスク削除

```bash
curl -X DELETE http://localhost:8080/api/v1/tasks/<タスクID> \
  -H "X-User-Id: <ユーザーID>"
```

### 風船（Balloon）API

#### 風船作成

```bash
curl -X POST http://localhost:8080/api/v1/balloons \
  -H "Content-Type: application/json" \
  -H "X-User-Id: <ユーザーID>" \
  -d '{
    "title": "朝活バルーン",
    "description": "朝に一歩",
    "colorId": 1,
    "tagIconId": 1,
    "isPublic": false
  }'
```

#### 公開風船一覧取得

```bash
curl -X GET "http://localhost:8080/api/v1/balloons/public?limit=20&offset=0"
```

#### 選択中風船取得

```bash
curl -X GET http://localhost:8080/api/v1/balloons/selection \
  -H "X-User-Id: <ユーザーID>"
```

#### 選択中風船設定

```bash
curl -X PUT http://localhost:8080/api/v1/balloons/selection \
  -H "Content-Type: application/json" \
  -H "X-User-Id: <ユーザーID>" \
  -d '{
    "balloonId": "<風船ID>"
  }'
```

### ユーザー API

#### 自分の情報取得

```bash
curl -X GET http://localhost:8080/api/v1/me \
  -H "X-User-Id: <ユーザーID>"
```

## アーキテクチャ

このプロジェクトは DDD (Domain-Driven Design) に基づいて設計されています。

### レイヤー構成

```
presentation -> application -> domain <- infrastructure
```

- **domain**: ビジネスルール（エンティティ / リポジトリインターフェース）
- **application**: ユースケース（トランザクション境界、入力検証）
- **infrastructure**: DB / 外部 API など技術詳細
- **presentation**: REST Controller（HTTP 責務、DTO 変換のみ）

### データベースアクセス

**重要**: すべてのDB操作はストアドプロシージャ経由で行います。

- SQLは必ずストアドプロシージャ（またはストアドファンクション）経由
- ストアドの返り値は常にテーブル形式（ResultSet）
- リレーションテーブルの内容はJSON（jsonb）または配列で受け渡し

ストアドプロシージャは `/src/main/resources/db/migration/V2__create_stored_procedures.sql` に定義されています。

## 環境変数

| 変数名                       | 説明                   | デフォルト値                              |
| ---------------------------- | ---------------------- | ----------------------------------------- |
| `SPRING_PROFILES_ACTIVE`     | 起動プロファイル       | `dev`                                     |
| `SPRING_DATASOURCE_URL`      | データベース接続 URL   | `jdbc:postgresql://localhost:5432/tasbal` |
| `SPRING_DATASOURCE_USERNAME` | データベースユーザー名 | `tasbal_user`                             |
| `SPRING_DATASOURCE_PASSWORD` | データベースパスワード | `tasbal_password`                         |
| `SERVER_PORT`                | サーバーポート         | `8080`                                    |

## トラブルシューティング

### ポートが既に使用されている

別のポートを指定して起動します:

```bash
./mvnw spring-boot:run -Dspring-boot.run.arguments=--server.port=8081
```

### データベース接続エラー

1. PostgreSQL が起動しているか確認

```bash
docker-compose ps db
```

2. 接続情報が正しいか確認

```bash
# 環境変数を確認
echo $SPRING_DATASOURCE_URL
```

### ビルドエラー

キャッシュをクリアして再ビルド:

```bash
./mvnw clean install -U
```

## 開発ガイドライン

### コーディング規約

- Java コーディング規約に準拠
- クラス・メソッドには適切な Javadoc コメントを記載
- テストカバレッジ 80%以上を目指す

### ブランチ戦略

- `main` - 本番環境
- `develop` - 開発環境
- `feature/*` - 機能開発
- `fix/*` - バグ修正

## リファレンス

- [Spring Boot 3.4.1 Documentation](https://docs.spring.io/spring-boot/3.4.1/reference/)
- [Spring Security](https://docs.spring.io/spring-security/reference/)
- [springdoc-openapi](https://springdoc.org/)
- [Flyway](https://flywaydb.org/documentation/)
- [PostgreSQL 16](https://www.postgresql.org/docs/16/index.html)

## ライセンス

このプロジェクトは非公開です。
