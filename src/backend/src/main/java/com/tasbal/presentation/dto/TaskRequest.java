package com.tasbal.presentation.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

import java.time.OffsetDateTime;

/**
 * タスク作成・更新リクエストDTO。
 *
 * <p>このクラスはタスクの作成または更新時のリクエストを表現します。
 * バリデーション制約が定義されており、不正なデータの投入を防ぎます。</p>
 *
 * <h3>バリデーション:</h3>
 * <ul>
 *   <li>title: 必須、最大500文字</li>
 *   <li>memo: 任意</li>
 *   <li>dueAt: 任意</li>
 * </ul>
 *
 * @author Tasbal Team
 * @since 1.0.0
 */
@Schema(description = "タスクリクエスト")
public class TaskRequest {

    @NotBlank(message = "Title is required")
    @Size(max = 500, message = "Title must be less than 500 characters")
    @Schema(description = "タスクのタイトル", example = "プレゼン資料を作成する", required = true, maxLength = 500)
    private String title;

    @Schema(description = "タスクのメモ", example = "スライド20枚程度、デザインはシンプルに", nullable = true)
    private String memo;

    @Schema(description = "期限日時", example = "2026-01-15T23:59:59+09:00", nullable = true)
    private OffsetDateTime dueAt;

    /**
     * デフォルトコンストラクタ。
     */
    public TaskRequest() {
    }

    /**
     * 全フィールドを指定してインスタンスを構築します。
     *
     * @param title タスクのタイトル
     * @param memo タスクのメモ
     * @param dueAt 期限日時
     */
    public TaskRequest(String title, String memo, OffsetDateTime dueAt) {
        this.title = title;
        this.memo = memo;
        this.dueAt = dueAt;
    }

    // Getters and Setters
    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }

    public OffsetDateTime getDueAt() {
        return dueAt;
    }

    public void setDueAt(OffsetDateTime dueAt) {
        this.dueAt = dueAt;
    }
}
