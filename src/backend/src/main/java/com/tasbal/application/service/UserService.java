package com.tasbal.application.service;

import com.tasbal.domain.model.User;
import com.tasbal.domain.model.UserSettings;
import com.tasbal.domain.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

/**
 * ユーザーアプリケーションサービス。
 *
 * <p>このクラスはユーザーに関するユースケースを提供します。
 * ゲストユーザーの作成、ユーザー情報の取得、ユーザー設定の管理を担当します。</p>
 *
 * <p>主な機能:</p>
 * <ul>
 *   <li>ゲストユーザーの作成</li>
 *   <li>ユーザー情報の取得</li>
 *   <li>ユーザー設定の取得</li>
 *   <li>ユーザー設定の更新</li>
 * </ul>
 *
 * @author Tasbal Team
 * @since 1.0.0
 * @see UserRepository
 * @see User
 * @see UserSettings
 */
@Service
@Transactional
public class UserService {

    private final UserRepository userRepository;

    /**
     * コンストラクタ。
     *
     * @param userRepository ユーザーリポジトリ
     */
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    /**
     * ゲストユーザーを作成します。
     *
     * <p>ゲストユーザーは認証なしで利用できる一時的なユーザーアカウントです。</p>
     *
     * @param handle ユーザーハンドル（表示名）
     * @return 作成されたゲストユーザーオブジェクト
     */
    public User createGuestUser(String handle) {
        return userRepository.createGuest(handle);
    }

    /**
     * ユーザーIDでユーザー情報を取得します。
     *
     * @param userId ユーザーID
     * @return ユーザーオブジェクト
     * @throws RuntimeException ユーザーが見つからない場合
     */
    public User getUserById(UUID userId) {
        return userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    /**
     * ユーザーIDでユーザー設定を取得します。
     *
     * @param userId ユーザーID
     * @return ユーザー設定オブジェクト
     * @throws RuntimeException ユーザー設定が見つからない場合
     */
    public UserSettings getUserSettings(UUID userId) {
        return userRepository.findSettingsByUserId(userId)
                .orElseThrow(() -> new RuntimeException("User settings not found"));
    }

    /**
     * ユーザー設定を更新します。
     *
     * @param userId ユーザーID
     * @param countryCode 国コード（ISO 3166-1 alpha-2形式）
     * @param renderQuality レンダリング品質区分値
     * @param autoLowPower 自動低電力モードフラグ
     * @return 更新されたユーザー設定オブジェクト
     */
    public UserSettings updateUserSettings(UUID userId, String countryCode, Short renderQuality, Boolean autoLowPower) {
        return userRepository.updateSettings(userId, countryCode, renderQuality, autoLowPower);
    }
}
