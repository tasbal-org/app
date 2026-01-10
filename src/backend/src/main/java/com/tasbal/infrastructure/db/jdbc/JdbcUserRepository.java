package com.tasbal.infrastructure.db.jdbc;

import com.tasbal.domain.model.User;
import com.tasbal.domain.model.UserSettings;
import com.tasbal.domain.repository.UserRepository;
import com.tasbal.infrastructure.db.common.StoredFunctionExecutor;
import com.tasbal.infrastructure.db.common.StoredProcedureExecutor;
import com.tasbal.infrastructure.db.function.user.CreateGuestUserFunction;
import com.tasbal.infrastructure.db.function.user.GetUserByIdFunction;
import com.tasbal.infrastructure.db.function.user.GetUserSettingsFunction;
import com.tasbal.infrastructure.db.procedure.user.UpdateUserSettingsProcedure;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

/**
 * ユーザーリポジトリのJDBC実装。
 *
 * <p>このクラスは{@link UserRepository}インターフェースを実装し、
 * ストアドプロシージャを使用してユーザーおよびユーザー設定のデータアクセスを提供します。</p>
 *
 * <p>すべてのデータベース操作は{@link StoredProcedureExecutor}を介して
 * ストアドプロシージャクラスを実行します。</p>
 *
 * @author Tasbal Team
 * @since 1.0.0
 * @see UserRepository
 * @see StoredProcedureExecutor
 */
@Repository
public class JdbcUserRepository implements UserRepository {

    private final StoredProcedureExecutor procedureExecutor;
    private final StoredFunctionExecutor functionExecutor;

    /**
     * コンストラクタ。
     *
     * @param procedureExecutor ストアドプロシージャ実行クラス
     * @param functionExecutor ストアドファンクション実行クラス
     */
    public JdbcUserRepository(
            StoredProcedureExecutor procedureExecutor,
            StoredFunctionExecutor functionExecutor) {
        this.procedureExecutor = procedureExecutor;
        this.functionExecutor = functionExecutor;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public User createGuest(String handle) {
        CreateGuestUserFunction function = new CreateGuestUserFunction(handle);
        CreateGuestUserFunction.Result result = functionExecutor.executeForSingleRequired(function);
        return mapToUser(result);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Optional<User> findById(UUID userId) {
        GetUserByIdFunction function = new GetUserByIdFunction(userId);
        GetUserByIdFunction.Result result = functionExecutor.executeForSingle(function);
        return result != null ? Optional.of(mapToUser(result)) : Optional.empty();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Optional<UserSettings> findSettingsByUserId(UUID userId) {
        GetUserSettingsFunction function = new GetUserSettingsFunction(userId);
        GetUserSettingsFunction.Result result = functionExecutor.executeForSingle(function);
        return result != null ? Optional.of(mapToUserSettings(result)) : Optional.empty();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public UserSettings updateSettings(UUID userId, String countryCode, Short renderQuality, Boolean autoLowPower) {
        UpdateUserSettingsProcedure procedure = new UpdateUserSettingsProcedure(userId, countryCode, renderQuality, autoLowPower);
        UpdateUserSettingsProcedure.Result result = procedureExecutor.executeForSingle(procedure);
        return result != null ? mapToUserSettings(result) : null;
    }

    /**
     * {@link CreateGuestUserFunction.Result}をドメインモデル{@link User}に変換します。
     *
     * @param result ストアドファンクションの実行結果
     * @return ドメインモデルのUserオブジェクト
     */
    private User mapToUser(CreateGuestUserFunction.Result result) {
        return new User(
                result.getId(),
                result.getHandle(),
                result.getPlan(),
                result.getIsGuest(),
                result.getAuthState(),
                result.getCreatedAt(),
                result.getUpdatedAt(),
                null, // last_login_at is not returned by sp_create_guest_user
                null  // deleted_at is not returned by sp_create_guest_user
        );
    }

    /**
     * {@link GetUserByIdFunction.Result}をドメインモデル{@link User}に変換します。
     *
     * @param result ストアドファンクションの実行結果
     * @return ドメインモデルのUserオブジェクト
     */
    private User mapToUser(GetUserByIdFunction.Result result) {
        return new User(
                result.getId(),
                result.getHandle(),
                result.getPlan(),
                result.getIsGuest(),
                result.getAuthState(),
                result.getCreatedAt(),
                result.getUpdatedAt(),
                result.getLastLoginAt(),
                result.getDeletedAt()
        );
    }

    /**
     * {@link GetUserSettingsFunction.Result}をドメインモデル{@link UserSettings}に変換します。
     *
     * @param result ストアドファンクションの実行結果
     * @return ドメインモデルのUserSettingsオブジェクト
     */
    private UserSettings mapToUserSettings(GetUserSettingsFunction.Result result) {
        return new UserSettings(
                result.getUserId(),
                result.getCountryCode(),
                result.getRenderQuality(),
                result.getAutoLowPower(),
                result.getUpdatedAt()
        );
    }

    /**
     * {@link UpdateUserSettingsProcedure.Result}をドメインモデル{@link UserSettings}に変換します。
     *
     * @param result ストアドプロシージャの実行結果
     * @return ドメインモデルのUserSettingsオブジェクト
     */
    private UserSettings mapToUserSettings(UpdateUserSettingsProcedure.Result result) {
        return new UserSettings(
                result.getUserId(),
                result.getCountryCode(),
                result.getRenderQuality(),
                result.getAutoLowPower(),
                result.getUpdatedAt()
        );
    }
}
