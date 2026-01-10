package com.tasbal.domain.model;

import com.tasbal.domain.division.AuthState;
import com.tasbal.domain.division.UserPlan;

import java.time.OffsetDateTime;
import java.util.UUID;

/**
 * ユーザードメインモデル。
 *
 * <p>このクラスは{@link com.tasbal.domain.model.schema.User}を継承し、
 * ユーザーのビジネスロジックとdivision enumへのアクセスを提供します。</p>
 *
 * <p>スキーマモデルではShort型で保持されている区分値を、
 * このドメインモデルでは型安全なenumとして扱えるようにします。</p>
 *
 * <h3>主な機能:</h3>
 * <ul>
 *   <li>ユーザープラン（FREE/PRO）のenum変換</li>
 *   <li>認証状態（GUEST/LINKED/DISABLED）のenum変換</li>
 *   <li>スキーマモデルの全機能を継承</li>
 * </ul>
 *
 * @author Tasbal Team
 * @since 1.0.0
 * @see com.tasbal.domain.model.schema.User
 * @see UserPlan
 * @see AuthState
 */
public class User extends com.tasbal.domain.model.schema.User {

    /**
     * ユーザーを構築します。
     *
     * @param id ユーザーID
     * @param handle ハンドル名（ユーザー識別子）
     * @param plan プラン区分値（1:FREE, 2:PRO）
     * @param isGuest ゲストユーザーフラグ
     * @param authState 認証状態区分値（1:GUEST, 2:LINKED, 3:DISABLED）
     * @param createdAt 作成日時
     * @param updatedAt 更新日時
     * @param lastLoginAt 最終ログイン日時
     * @param deletedAt 削除日時（論理削除）
     */
    public User(UUID id, String handle, Short plan, Boolean isGuest, Short authState,
                OffsetDateTime createdAt, OffsetDateTime updatedAt, OffsetDateTime lastLoginAt,
                OffsetDateTime deletedAt) {
        super(id, handle, plan, isGuest, authState, createdAt, updatedAt, lastLoginAt, deletedAt);
    }

    /**
     * ユーザープランをenum型で取得します。
     *
     * <p>データベースの数値区分値を{@link UserPlan} enumに変換して返します。
     * 変換に失敗した場合は{@link UserPlan#Free}がデフォルト値として返されます。</p>
     *
     * @return ユーザープランenum
     */
    public UserPlan getPlanEnum() {
        return UserPlan.fromValue(getPlan()).orElse(UserPlan.Free);
    }

    /**
     * 認証状態をenum型で取得します。
     *
     * <p>データベースの数値区分値を{@link AuthState} enumに変換して返します。
     * 変換に失敗した場合は{@link AuthState#Guest}がデフォルト値として返されます。</p>
     *
     * @return 認証状態enum
     */
    public AuthState getAuthStateEnum() {
        return AuthState.fromValue(getAuthState()).orElse(AuthState.Guest);
    }

    /**
     * ユーザープランをenum型で設定します。
     *
     * <p>enum値を数値区分値に変換してデータベースに保存します。</p>
     *
     * @param planEnum 設定するユーザープランenum
     */
    public void setPlanEnum(UserPlan planEnum) {
        setPlan((short) planEnum.getValue());
    }

    /**
     * 認証状態をenum型で設定します。
     *
     * <p>enum値を数値区分値に変換してデータベースに保存します。</p>
     *
     * @param authStateEnum 設定する認証状態enum
     */
    public void setAuthStateEnum(AuthState authStateEnum) {
        setAuthState((short) authStateEnum.getValue());
    }
}
