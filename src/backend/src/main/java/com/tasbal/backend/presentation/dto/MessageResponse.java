package com.tasbal.backend.presentation.dto;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "汎用メッセージレスポンス")
public class MessageResponse {

    @Schema(description = "メッセージ", example = "Selection updated")
    private String message;

    public MessageResponse() {
    }

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
