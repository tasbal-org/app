package com.tasbal.presentation.dto;

import io.swagger.v3.oas.annotations.media.Schema;

/**
 * 汎用メッセージレスポンスDTO。
 *
 * <p>このクラスは簡単なメッセージをクライアントに返却する際に使用します。
 * 操作の成功通知や簡易的な情報提供に利用されます。</p>
 *
 * @author Tasbal Team
 * @since 1.0.0
 */
@Schema(description = "汎用メッセージレスポンス")
public class MessageResponse {

    @Schema(description = "メッセージ", example = "Selection updated")
    private String message;

    /**
     * デフォルトコンストラクタ。
     */
    public MessageResponse() {
    }

    /**
     * メッセージを指定してインスタンスを構築します。
     *
     * @param message レスポンスメッセージ
     */
    public MessageResponse(String message) {
        this.message = message;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
