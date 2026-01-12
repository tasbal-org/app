# Tasbal API Specification (MVP)

> This document is the **Tasbal API MVP specification** integrating all requirements, conversations, and design policies.
> Designed around guest usage, device management, transfer tokens, and the balloon-based contribution model.

---

## 1. Basic Information

- Base URL: `/api/v1`
- Data format: `application/json; charset=utf-8`
- Date format: ISO 8601 (e.g., `2026-01-06T10:00:00Z`)
- ID format: `uuid` (string)

### Common Headers

| Header | Required | Description |
|---|---|---|
| Authorization | △ | `Bearer <access_token>` (after auth) |
| X-Device-Key | ○ | Device identifier key (including guest) |
| Idempotency-Key | △ | For POST idempotency control |

---

## 2. Error Format (Common)

```json
{
  "error": {
    "code": "TASK_NOT_FOUND",
    "message": "Task not found.",
    "details": {
      "taskId": "uuid"
    }
  }
}
```

Common error codes:

- `UNAUTHORIZED`
- `FORBIDDEN`
- `NOT_FOUND`
- `VALIDATION_ERROR`
- `PUBLIC_BALLOON_LIMIT_EXCEEDED`
- `BALLOON_CREATE_LIMIT_EXCEEDED`
- `TRANSFER_TOKEN_EXPIRED`

---

## 3. Authentication / Device / Transfer

### 3.1 Device Registration (First Launch)

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

### 3.2 Guest Start (Anonymous Login)

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

### 3.3 Transfer Token Issue / Use

#### Issue
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

#### Use
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

## 4. User / Settings

### 4.1 Get My Info

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

### 4.2 User Settings

`GET /me/settings`

`PUT /me/settings`

```json
{ "render_quality": "MEDIUM" }
```

---

## 5. Tasks

### 5.1 Create Task

`POST /tasks`

```json
{
  "title": "Take a walk",
  "due_at": "2026-01-06T23:59:59+09:00",
  "memo": "Even 10 minutes is OK"
}
```

---

### 5.2 Task List

`GET /tasks?limit=20&cursor=...`

```json
{
  "items": [
    {
      "id": "uuid",
      "title": "Take a walk",
      "is_done": false
    }
  ],
  "next_cursor": "..."
}
```

---

### 5.3 Toggle Completion (Balloon Addition Trigger)

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

## 6. Balloons

### Types

| type | Description |
|---|---|
| GLOBAL | World-wide shared |
| LOCATION | By region |
| USER | User-created |
| GUERRILLA | Time-limited |

---

### 6.1 Create Balloon (USER)

`POST /balloons`

```json
{
  "type": "USER",
  "title": "Morning Activity Balloon",
  "description": "One step in the morning",
  "is_public": false
}
```

---

### 6.2 Public Balloon List

`GET /balloons/public`

```json
{
  "items": [
    {
      "id": "uuid",
      "title": "Morning Activity Balloon",
      "owner_user_id": "uuid"
    }
  ]
}
```

---

### 6.3 Selected Balloon

- Get: `GET /me/balloon-selection`
- Set: `PUT /me/balloon-selection`

```json
{ "balloon_id": "uuid" }
```

---

### 6.4 Get Progress (Numbers not shown in UI)

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

## 7. Guerrilla Events

`GET /guerrilla-events/active`

```json
{
  "events": [
    {
      "id": "uuid",
      "title": "Golden Guerrilla",
      "starts_at": "2026-01-06T00:00:00Z",
      "ends_at": "2026-01-07T00:00:00Z"
    }
  ]
}
```

---

## 8. Design Notes

- Numbers (contribution amount, progress amount) are kept internally in API but not displayed in UI
- Completion processing is designed with idempotency in mind
- ID design assumes guest → official user promotion
- Balloon returns "experience", not evaluation

---

End
