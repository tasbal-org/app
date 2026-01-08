package com.tasbal.backend.presentation.dto;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "ゲストユーザー作成リクエスト")
public class CreateGuestUserRequest {

    @Schema(description = "ユーザーハンドル（オプション）", example = "guest_user_123", nullable = true)
    private String handle;

    public CreateGuestUserRequest() {
    }

    public CreateGuestUserRequest(String handle) {
        this.handle = handle;
    }

    public String getHandle() {
        return handle;
    }

    public void setHandle(String handle) {
        this.handle = handle;
    }
}
