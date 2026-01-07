# Tasbal API 仕様書（MVP）

> 本書は、これまでの要件整理・会話内容・設計方針を統合した **Tasbal（タスバル）API のMVP仕様書** です。
> ゲスト利用／端末管理／引き継ぎトークン／風船（Balloon）による貢献モデルを中核に設計されています。

---

## 1. 基本情報

- Base URL: `/api/v1`
- データ形式: `application/json; charset=utf-8`
- 日時形式: ISO 8601（例: `2026-01-06T10:00:00Z`）
- ID形式: `uuid`（string）

### 共通ヘッダ

| ヘッダ | 必須 | 説明 |
|---|---|---|
| Authorization | △ | `Bearer <access_token>`（認証後） |
| X-Device-Key | ○ | 端末識別キー（ゲスト含む） |
| Idempotency-Key | △ | POST系の冪等制御用 |

---

## 2. エラーフォーマット（共通）

```json
{
  "error": {
    "code": "TASK_NOT_FOUND",
    "message": "タスクが見つかりません。",
    "details": {
      "taskId": "uuid"
    }
  }
}
```

代表的なエラーコード:

- `UNAUTHORIZED`
- `FORBIDDEN`
- `NOT_FOUND`
- `VALIDATION_ERROR`
- `PUBLIC_BALLOON_LIMIT_EXCEEDED`
- `BALLOON_CREATE_LIMIT_EXCEEDED`
- `TRANSFER_TOKEN_EXPIRED`

---

## 3. 認証 / 端末 / 引き継ぎ

### 3.1 端末登録（初回起動）

`POST /devices/register`

```json
{
  "device_name": "Yohei's iPhone",
  "push_token": "expoPushToken..."
}
```

```json
{
  "device": {
    "id": "uuid",
    "device_key": "opaque-string",
    "device_name": "Yohei's iPhone",
    "last_used_at": "2026-01-06T10:00:00Z",
    "created_at": "2026-01-06T10:00:00Z"
  }
}
```

---

### 3.2 ゲスト開始（匿名ログイン）

`POST /auth/guest`

```json
{
  "device_key": "opaque-string"
}
```

```json
{
  "user": {
    "id": "uuid",
    "is_guest": true,
    "handle": "guest-xxxx"
  },
  "tokens": {
    "access_token": "jwt",
    "refresh_token": "opaque",
    "expires_in": 3600
  }
}
```

---

### 3.3 引き継ぎトークン発行 / 使用

#### 発行
`POST /transfer-tokens`

```json
{ "expires_in_minutes": 30 }
```

```json
{
  "transfer": {
    "id": "uuid",
    "token": "123456",
    "expires_at": "2026-01-06T10:30:00Z"
  }
}
```

#### 使用
`POST /transfer-tokens/consume`

```json
{
  "device_key": "opaque-string",
  "token": "123456"
}
```

```json
{
  "user": { "id": "uuid" },
  "tokens": {
    "access_token": "jwt",
    "refresh_token": "opaque",
    "expires_in": 3600
  }
}
```

---

## 4. ユーザー / 設定

### 4.1 自分の情報取得

`GET /me`

```json
{
  "user": {
    "id": "uuid",
    "handle": "yohei",
    "plan": "FREE",
    "is_guest": false,
    "created_at": "2026-01-01T00:00:00Z"
  }
}
```

### 4.2 ユーザー設定

`GET /me/settings`

`PUT /me/settings`

```json
{ "render_quality": "MEDIUM" }
```

---

## 5. タスク

### 5.1 タスク作成

`POST /tasks`

```json
{
  "title": "散歩する",
  "due_at": "2026-01-06T23:59:59+09:00",
  "memo": "10分だけでもOK"
}
```

---

### 5.2 タスク一覧

`GET /tasks?limit=20&cursor=...`

```json
{
  "items": [
    {
      "id": "uuid",
      "title": "散歩する",
      "is_done": false
    }
  ],
  "next_cursor": "..."
}
```

---

### 5.3 完了切替（風船加算トリガ）

`POST /tasks/{taskId}/toggle-done`

```json
{ "is_done": true }
```

```json
{
  "task": {
    "id": "uuid",
    "is_done": true
  },
  "balloon_reaction": {
    "popped_balloon_ids": ["uuid"],
    "sound": "POP_SOFT"
  }
}
```

---

## 6. 風船（Balloon）

### 種別

| type | 説明 |
|---|---|
| GLOBAL | 全体共有 |
| LOCATION | 地域単位 |
| USER | ユーザー作成 |
| GUERRILLA | 期間限定 |

---

### 6.1 風船作成（USER）

`POST /balloons`

```json
{
  "type": "USER",
  "title": "朝活バルーン",
  "description": "朝に一歩",
  "is_public": false
}
```

---

### 6.2 公開風船一覧

`GET /balloons/public`

```json
{
  "items": [
    {
      "id": "uuid",
      "title": "朝活バルーン",
      "owner_user_id": "uuid"
    }
  ]
}
```

---

### 6.3 選択中風船

- 取得: `GET /me/balloon-selection`
- 設定: `PUT /me/balloon-selection`

```json
{ "balloon_id": "uuid" }
```

---

### 6.4 進捗取得（数値はUI非表示）

`GET /balloons/{balloonId}/progress`

```json
{
  "ui_hint": {
    "fill_ratio": 0.6,
    "stage": "GROWING"
  }
}
```

---

## 7. ゲリライベント

`GET /guerrilla-events/active`

```json
{
  "events": [
    {
      "id": "uuid",
      "title": "金のゲリラ",
      "starts_at": "2026-01-06T00:00:00Z",
      "ends_at": "2026-01-07T00:00:00Z"
    }
  ]
}
```

---

## 8. 設計メモ

- 数値（貢献量・進捗量）は API 内部では保持するが、UI表示は行わない
- 完了処理は冪等性を意識する
- ゲスト → 正式ユーザー昇格を前提にID設計
- Balloonは「体験」を返し、評価は返さない

---

以上

