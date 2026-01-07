# Tasbal - タスク管理アプリ

個人のタスク達成が、みんなの達成感につながる共有バルーン型のタスク管理アプリ

## 技術スタック

### Backend
- Java 21
- Spring Boot 4.0.1
- PostgreSQL 16
- JOOQ (ORM)
- Flyway (マイグレーション)
- Maven
- Docker

### Frontend
- Flutter (最新版)
- Redux (状態管理)
- Firebase Authentication
- Hive (ローカルストレージ)

## 前提条件

- Docker & Docker Compose
- Flutter SDK (最新版)
- Git

## セットアップ手順

### 1. リポジトリのクローン

```bash
git clone <repository-url>
cd app
```

### 2. 環境変数の設定

`.env.example`をコピーして`.env`を作成し、必要な値を設定します。

```bash
cp .env.example .env
```

### 3. Dockerコンテナの起動

#### 本番用
```bash
docker-compose up -d
```

#### 開発用（ホットリロード対応）
```bash
docker-compose -f docker-compose.dev.yml up -d
```

これにより以下のサービスが起動します：
- PostgreSQL (ポート: 5432)
- Java Backend (ポート: 8080)
- デバッグポート (開発用のみ、ポート: 5005)

### 4. サービスの確認

```bash
# コンテナの状態確認
docker-compose ps

# バックエンドのヘルスチェック
curl http://localhost:8080/actuator/health

# ログの確認
docker-compose logs -f backend
```

### 5. Flutterアプリの起動

```bash
cd src/frontend
flutter pub get
flutter run
```

## ディレクトリ構成

```
app/
├── docker-compose.yml          # Docker構成ファイル（本番用）
├── docker-compose.dev.yml      # Docker構成ファイル（開発用）
├── .env                        # 環境変数（Git管理外）
├── .env.example               # 環境変数のサンプル
├── docs/                      # ドキュメント
│   ├── 仕様書.md
│   ├── 設計書.md
│   └── sample/               # サンプルコード
├── infra/                    # インフラ設定
│   ├── docker/              # Docker関連ファイル
│   │   └── backend/        # バックエンドDockerfile群
│   │       ├── Dockerfile      # 本番用
│   │       ├── Dockerfile.dev  # 開発用
│   │       └── .dockerignore
│   └── db/
│       └── init/            # DB初期化スクリプト
└── src/
    ├── backend/             # Java Spring Boot
    │   ├── pom.xml
    │   ├── README.md
    │   └── src/
    │       └── main/
    │           ├── java/
    │           │   └── com/tasbal/
    │           └── resources/
    │               └── application.properties
    └── frontend/            # Flutter
        ├── pubspec.yaml
        └── lib/
```

## 開発コマンド

### Backend

```bash
# コンテナ内でMavenコマンド実行
docker-compose exec backend ./mvnw clean package

# アプリケーションの再起動
docker-compose restart backend

# ログの確認
docker-compose logs -f backend
```

### Frontend

```bash
cd src/frontend

# 依存関係のインストール
flutter pub get

# コード生成（Hive, JSON serialization）
flutter pub run build_runner build --delete-conflicting-outputs

# アプリの起動
flutter run

# テストの実行
flutter test
```

### Database

```bash
# PostgreSQLに接続
docker-compose exec db psql -U tasbal_user -d tasbal

# DBコンテナのログ確認
docker-compose logs -f db
```

## トラブルシューティング

### ポートが既に使用されている場合

`.env`ファイルでポート番号を変更してください：

```
POSTGRES_PORT=5433
BACKEND_PORT=8081
```

### Dockerコンテナの完全リセット

```bash
docker-compose down -v
docker-compose up -d
```

### バックエンドのビルドエラー

```bash
docker-compose exec backend ./mvnw clean install -DskipTests
docker-compose restart backend
```

## Firebase設定（認証用）

1. Firebaseプロジェクトを作成
2. 認証プロバイダ（Google, Apple）を有効化
3. サービスアカウントキーをダウンロード
4. `.env`ファイルに設定を追加

詳細は[Firebase設定ガイド](docs/firebase-setup.md)を参照してください。

## ライセンス

このプロジェクトは非公開です。