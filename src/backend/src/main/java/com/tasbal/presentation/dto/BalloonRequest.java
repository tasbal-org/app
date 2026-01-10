package com.tasbal.presentation.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

/**
 * 風船作成・更新リクエストDTO。
 *
 * <p>このクラスは風船の作成または更新時のリクエストを表現します。
 * バリデーション制約が定義されており、不正なデータの投入を防ぎます。</p>
 *
 * <h3>バリデーション:</h3>
 * <ul>
 *   <li>title: 必須、最大100文字</li>
 *   <li>colorId: 必須</li>
 *   <li>isPublic: 必須</li>
 * </ul>
 *
 * @author Tasbal Team
 * @since 1.0.0
 */
@Schema(description = "風船作成リクエスト")
public class BalloonRequest {

    @NotBlank(message = "Title is required")
    @Size(max = 100, message = "Title must be less than 100 characters")
    @Schema(description = "風船のタイトル", example = "今週の目標", required = true, maxLength = 100)
    private String title;

    @Schema(description = "風船の説明", example = "今週中に終わらせるタスクをまとめる風船", nullable = true)
    private String description;

    @NotNull(message = "colorId is required")
    @Schema(description = "風船の色ID", example = "1", required = true)
    private Short colorId;

    @Schema(description = "タグアイコンID", example = "5", nullable = true)
    private Short tagIconId;

    @NotNull(message = "isPublic is required")
    @Schema(description = "公開設定", example = "true", required = true)
    private Boolean isPublic;

    /**
     * デフォルトコンストラクタ。
     */
    public BalloonRequest() {
    }

    /**
     * 全フィールドを指定してインスタンスを構築します。
     *
     * @param title 風船のタイトル
     * @param description 風船の説明
     * @param colorId 色ID
     * @param tagIconId タグアイコンID
     * @param isPublic 公開設定
     */
    public BalloonRequest(String title, String description, Short colorId, Short tagIconId, Boolean isPublic) {
        this.title = title;
        this.description = description;
        this.colorId = colorId;
        this.tagIconId = tagIconId;
        this.isPublic = isPublic;
    }

    // Getters and Setters
    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Short getColorId() {
        return colorId;
    }

    public void setColorId(Short colorId) {
        this.colorId = colorId;
    }

    public Short getTagIconId() {
        return tagIconId;
    }

    public void setTagIconId(Short tagIconId) {
        this.tagIconId = tagIconId;
    }

    public Boolean getIsPublic() {
        return isPublic;
    }

    public void setIsPublic(Boolean isPublic) {
        this.isPublic = isPublic;
    }
}
