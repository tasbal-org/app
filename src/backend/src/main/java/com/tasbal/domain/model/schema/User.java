package com.tasbal.domain.model.schema;

import java.time.OffsetDateTime;
import java.util.UUID;

/**
 * ユーザースキーマモデル。
 *
 * <p>このクラスはデータベースのusersテーブルと1:1で対応するスキーマ層のモデルです。
 * 区分値は数値（Short型）のまま保持し、データベースとの直接的なマッピングを提供します。</p>
 *
 * @author Tasbal Team
 * @since 1.0.0
 */
public class User {
    // 識別子
    private final UUID id;

    // 基本情報
    private String handle;
    private Short plan;
    private Boolean isGuest;
    private Short authState;

    // タイムスタンプ
    private final OffsetDateTime createdAt;
    private OffsetDateTime updatedAt;
    private OffsetDateTime lastLoginAt;
    private OffsetDateTime deletedAt;

    /**
     * コンストラクタ。
     *
     * @param id ユーザーID
     * @param handle ユーザーハンドル
     * @param plan プラン区分
     * @param isGuest ゲストフラグ
     * @param authState 認証状態
     * @param createdAt 作成日時
     * @param updatedAt 更新日時
     * @param lastLoginAt 最終ログイン日時
     * @param deletedAt 削除日時
     */
    public User(UUID id, String handle, Short plan, Boolean isGuest, Short authState,
                OffsetDateTime createdAt, OffsetDateTime updatedAt, OffsetDateTime lastLoginAt,
                OffsetDateTime deletedAt) {
        this.id = id;
        this.handle = handle;
        this.plan = plan;
        this.isGuest = isGuest;
        this.authState = authState;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.lastLoginAt = lastLoginAt;
        this.deletedAt = deletedAt;
    }

    // Getters
    public UUID getId() {
        return id;
    }

    public String getHandle() {
        return handle;
    }

    public Short getPlan() {
        return plan;
    }

    public Boolean getIsGuest() {
        return isGuest;
    }

    public Short getAuthState() {
        return authState;
    }

    public OffsetDateTime getCreatedAt() {
        return createdAt;
    }

    public OffsetDateTime getUpdatedAt() {
        return updatedAt;
    }

    public OffsetDateTime getLastLoginAt() {
        return lastLoginAt;
    }

    public OffsetDateTime getDeletedAt() {
        return deletedAt;
    }

    // Setters
    public void setHandle(String handle) {
        this.handle = handle;
    }

    public void setPlan(Short plan) {
        this.plan = plan;
    }

    public void setIsGuest(Boolean isGuest) {
        this.isGuest = isGuest;
    }

    public void setAuthState(Short authState) {
        this.authState = authState;
    }

    public void setUpdatedAt(OffsetDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public void setLastLoginAt(OffsetDateTime lastLoginAt) {
        this.lastLoginAt = lastLoginAt;
    }

    public void setDeletedAt(OffsetDateTime deletedAt) {
        this.deletedAt = deletedAt;
    }
}
