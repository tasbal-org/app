package com.tasbal.presentation.dto;

import io.swagger.v3.oas.annotations.media.Schema;

/**
 * ゲストユーザー作成リクエストDTO。
 *
 * <p>このクラスはゲストユーザーを新規作成する際のリクエストを表現します。
 * ユーザーハンドルはオプションで、指定されない場合は自動生成されます。</p>
 *
 * @author Tasbal Team
 * @since 1.0.0
 */
@Schema(description = "ゲストユーザー作成リクエスト")
public class CreateGuestUserRequest {

    @Schema(description = "ユーザーハンドル（オプション）", example = "guest_user_123", nullable = true)
    private String handle;

    /**
     * デフォルトコンストラクタ。
     */
    public CreateGuestUserRequest() {
    }

    /**
     * ハンドルを指定してインスタンスを構築します。
     *
     * @param handle ユーザーハンドル（省略可能）
     */
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
