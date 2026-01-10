package com.tasbal.domain.repository;

import com.tasbal.domain.model.User;
import com.tasbal.domain.model.UserSettings;
import java.util.Optional;
import java.util.UUID;

/**
 * ユーザーのリポジトリインターフェース。
 *
 * <p>このインターフェースは、ユーザーおよびユーザー設定エンティティの永続化層へのアクセスを定義します。
 * Tasbalアプリケーションにおけるユーザーの作成、検索、設定の管理を提供します。</p>
 *
 * <p>実装クラスは、ストアドプロシージャ・ストアドファンクションを経由して
 * データベースアクセスを行う必要があります。</p>
 *
 * @author Tasbal Team
 * @since 1.0.0
 * @see User
 * @see UserSettings
 */
public interface UserRepository {
    /**
     * ゲストユーザーを作成します。
     *
     * <p>ゲストユーザーは、本登録前の一時的なユーザーとして扱われます。</p>
     *
     * @param handle ユーザーのハンドル名
     * @return 作成されたユーザーオブジェクト
     */
    User createGuest(String handle);

    /**
     * 指定されたIDのユーザーを取得します。
     *
     * @param userId 取得するユーザーのID
     * @return ユーザーオブジェクト（存在しない場合は空のOptional）
     */
    Optional<User> findById(UUID userId);

    /**
     * 指定されたユーザーの設定情報を取得します。
     *
     * @param userId 対象ユーザーのID
     * @return ユーザー設定オブジェクト（存在しない場合は空のOptional）
     */
    Optional<UserSettings> findSettingsByUserId(UUID userId);

    /**
     * ユーザーの設定情報を更新します。
     *
     * @param userId 対象ユーザーのID
     * @param countryCode 国コード
     * @param renderQuality レンダリング品質
     * @param autoLowPower 自動省電力モードの有効/無効
     * @return 更新後のユーザー設定オブジェクト
     */
    UserSettings updateSettings(UUID userId, String countryCode, Short renderQuality, Boolean autoLowPower);
}
