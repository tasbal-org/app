package com.tasbal.presentation.dto;

import com.tasbal.domain.model.User;

import java.time.OffsetDateTime;
import java.util.UUID;

/**
 * ユーザー情報のレスポンスDTO。
 *
 * <p>このクラスはAPI経由でクライアントに返却されるユーザー情報を表現します。
 * ドメインモデルの{@link User}から必要な情報を抽出し、
 * クライアントが利用しやすい形式に変換します。</p>
 *
 * <h3>主な特徴:</h3>
 * <ul>
 *   <li>ユーザープランは表示名（文字列）として返却</li>
 *   <li>認証状態は公開しない</li>
 *   <li>内部の区分値は公開しない</li>
 * </ul>
 *
 * @author Tasbal Team
 * @since 1.0.0
 * @see User
 */
public class UserResponse {
    // 識別情報
    private UUID id;
    private String handle;

    // ユーザー属性
    private String plan;
    private Boolean isGuest;

    // タイムスタンプ
    private OffsetDateTime createdAt;

    /**
     * ドメインモデルからレスポンスDTOを生成します。
     *
     * <p>このメソッドは{@link User}ドメインモデルから
     * クライアント向けのレスポンスDTOを構築します。
     * ユーザープランは表示名に変換されます。</p>
     *
     * @param user ユーザードメインモデル
     * @return 構築されたUserResponseオブジェクト
     */
    public static UserResponse from(User user) {
        UserResponse response = new UserResponse();
        response.id = user.getId();
        response.handle = user.getHandle();
        response.plan = user.getPlanEnum().getDisplayName();
        response.isGuest = user.getIsGuest();
        response.createdAt = user.getCreatedAt();
        return response;
    }

    // Getters and Setters
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getHandle() {
        return handle;
    }

    public void setHandle(String handle) {
        this.handle = handle;
    }

    public String getPlan() {
        return plan;
    }

    public void setPlan(String plan) {
        this.plan = plan;
    }

    public Boolean getIsGuest() {
        return isGuest;
    }

    public void setIsGuest(Boolean isGuest) {
        this.isGuest = isGuest;
    }

    public OffsetDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(OffsetDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
