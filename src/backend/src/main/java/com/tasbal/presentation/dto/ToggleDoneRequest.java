package com.tasbal.presentation.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;

/**
 * タスク完了状態切替リクエストDTO。
 *
 * <p>このクラスはタスクの完了状態を変更する際のリクエストを表現します。
 * 完了状態フラグが必須項目として定義されています。</p>
 *
 * @author Tasbal Team
 * @since 1.0.0
 */
@Schema(description = "タスク完了切替リクエスト")
public class ToggleDoneRequest {

    @NotNull(message = "isDone is required")
    @Schema(description = "完了状態", example = "true", required = true)
    private Boolean isDone;

    /**
     * デフォルトコンストラクタ。
     */
    public ToggleDoneRequest() {
    }

    /**
     * 完了状態を指定してインスタンスを構築します。
     *
     * @param isDone 完了状態（true: 完了, false: 未完了）
     */
    public ToggleDoneRequest(Boolean isDone) {
        this.isDone = isDone;
    }

    // Getters and Setters
    public Boolean getIsDone() {
        return isDone;
    }

    public void setIsDone(Boolean isDone) {
        this.isDone = isDone;
    }
}
