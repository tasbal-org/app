# Backend Dockerfiles

Tasbalバックエンドのコンテナ化設定ファイル群

## ファイル構成

```
infra/docker/backend/
├── Dockerfile          # 本番用Dockerfile
├── Dockerfile.dev      # 開発用Dockerfile
├── .dockerignore       # ビルド除外設定
└── README.md          # このファイル
```

## Dockerfile（本番用）

マルチステージビルドで最適化された本番用イメージ。

### 特徴
- **ビルドステージ**: JDK 21でアプリケーションをビルド
- **ランタイムステージ**: 軽量なJRE 21でアプリケーションを実行
- **レイヤーキャッシュ最適化**: 依存関係とソースコードを分離してビルド高速化
- **セキュリティ**: 非rootユーザー（tasbal:1001）で実行
- **ヘルスチェック**: 組み込みヘルスチェック機能

### ビルド方法

```bash
# プロジェクトルートから
cd app

# イメージのビルド
docker build -f infra/docker/backend/Dockerfile -t tasbal-backend:latest ./src/backend

# docker-compose経由（推奨）
docker-compose build backend
```

### 単体での実行

```bash
docker run -d \
  --name tasbal-backend \
  -p 8080:8080 \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://host.docker.internal:5432/tasbal \
  -e SPRING_DATASOURCE_USERNAME=tasbal_user \
  -e SPRING_DATASOURCE_PASSWORD=tasbal_password \
  tasbal-backend:latest
```

## Dockerfile.dev（開発用）

ホットリロードとデバッグに対応した開発環境用イメージ。

### 特徴
- **ホットリロード**: Spring Boot DevToolsによる自動リロード
- **JDWPデバッグ**: ポート5005でリモートデバッグ可能
- **ソースマウント**: ホストのソースコードをリアルタイム反映
- **高速起動**: ビルド済みアーティファクトなし、起動時にMaven実行

### ビルド方法

```bash
# プロジェクトルートから
cd app

# イメージのビルド
docker build -f infra/docker/backend/Dockerfile.dev -t tasbal-backend:dev ./src/backend

# docker-compose経由（推奨）
docker-compose -f docker-compose.dev.yml build backend
```

### 使用方法

```bash
# 開発用docker-composeで起動
docker-compose -f docker-compose.dev.yml up -d

# ログの確認
docker-compose -f docker-compose.dev.yml logs -f backend
```

### IDEでのデバッグ接続

#### IntelliJ IDEA
1. Run → Edit Configurations
2. `+` → Remote JVM Debug
3. Host: `localhost`, Port: `5005`
4. デバッガーを起動

#### VS Code
`.vscode/launch.json`に追加:
```json
{
  "type": "java",
  "name": "Attach to Docker",
  "request": "attach",
  "hostName": "localhost",
  "port": 5005
}
```

## .dockerignore

ビルド時に不要なファイルを除外してビルド高速化とイメージサイズ削減。

### 除外されるファイル
- Mavenビルド成果物（`target/`）
- IDE設定ファイル（`.idea/`, `.vscode/`）
- ログファイル
- ドキュメント
- Git関連ファイル

## 環境変数

両方のDockerfileで以下の環境変数が使用可能です。

| 変数名 | 説明 | デフォルト値 |
|--------|------|-------------|
| `SPRING_PROFILES_ACTIVE` | 起動プロファイル | `dev` |
| `SPRING_DATASOURCE_URL` | DB接続URL | - |
| `SPRING_DATASOURCE_USERNAME` | DBユーザー名 | - |
| `SPRING_DATASOURCE_PASSWORD` | DBパスワード | - |
| `SERVER_PORT` | サーバーポート | `8080` |
| `TZ` | タイムゾーン | `UTC` |

## トラブルシューティング

### ビルドエラー: "mvnw: Permission denied"

Dockerfileで`chmod +x mvnw`を実行していますが、それでもエラーが出る場合:

```bash
# ホスト側で実行権限を付与
chmod +x src/backend/mvnw
git update-index --chmod=+x src/backend/mvnw
```

### 開発用コンテナが起動しない

```bash
# キャッシュをクリアして再ビルド
docker-compose -f docker-compose.dev.yml build --no-cache backend
docker-compose -f docker-compose.dev.yml up -d backend
```

### ホットリロードが効かない

1. ボリュームマウントが正しいか確認
```bash
docker-compose -f docker-compose.dev.yml config | grep volumes -A 5
```

2. コンテナ内でソースが見えているか確認
```bash
docker-compose -f docker-compose.dev.yml exec backend ls -la /app/src
```

### ヘルスチェックが失敗する

```bash
# コンテナ内でヘルスチェックを手動実行
docker exec tasbal-backend curl -f http://localhost:8080/actuator/health

# Actuatorが有効か確認（pom.xmlに以下を追加）
# <dependency>
#   <groupId>org.springframework.boot</groupId>
#   <artifactId>spring-boot-starter-actuator</artifactId>
# </dependency>
```

## ベストプラクティス

### 本番環境
- 常に`Dockerfile`（本番用）を使用
- 環境変数は`.env`ファイルやKubernetes Secretsで管理
- イメージにはバージョンタグを付ける（例: `tasbal-backend:v1.0.0`）
- ヘルスチェックエンドポイントを必ず実装

### 開発環境
- `Dockerfile.dev`を使用してホットリロード活用
- ソースコードはボリュームマウントで反映
- デバッガーを活用して効率的に開発
- 本番用イメージも定期的にビルドして動作確認

## 参考リンク

- [Spring Boot with Docker](https://spring.io/guides/topicals/spring-boot-docker/)
- [Best practices for writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Spring Boot DevTools](https://docs.spring.io/spring-boot/reference/using/devtools.html)
