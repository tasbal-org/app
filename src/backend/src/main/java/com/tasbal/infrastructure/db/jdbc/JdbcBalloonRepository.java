package com.tasbal.infrastructure.db.jdbc;

import com.tasbal.domain.model.Balloon;
import com.tasbal.domain.repository.BalloonRepository;
import com.tasbal.infrastructure.db.common.StoredFunctionExecutor;
import com.tasbal.infrastructure.db.common.StoredProcedureExecutor;
import com.tasbal.infrastructure.db.function.balloon.GetBalloonSelectionFunction;
import com.tasbal.infrastructure.db.function.balloon.GetPublicBalloonsFunction;
import com.tasbal.infrastructure.db.procedure.balloon.CreateBalloonProcedure;
import com.tasbal.infrastructure.db.procedure.balloon.SetBalloonSelectionProcedure;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * バルーンリポジトリのJDBC実装。
 *
 * <p>このクラスは{@link BalloonRepository}インターフェースを実装し、
 * ストアドファンクション・プロシージャを使用してバルーンのデータアクセスを提供します。</p>
 *
 * <p>データベース操作は以下のルールに従います:</p>
 * <ul>
 *   <li>GET系操作: {@link StoredFunctionExecutor}経由でストアドファンクションを実行</li>
 *   <li>CREATE/UPDATE/DELETE系操作: {@link StoredProcedureExecutor}経由でストアドプロシージャを実行</li>
 * </ul>
 *
 * @author Tasbal Team
 * @since 1.0.0
 * @see BalloonRepository
 * @see StoredFunctionExecutor
 * @see StoredProcedureExecutor
 */
@Repository
public class JdbcBalloonRepository implements BalloonRepository {

    private final StoredProcedureExecutor procedureExecutor;
    private final StoredFunctionExecutor functionExecutor;

    /**
     * コンストラクタ。
     *
     * @param procedureExecutor ストアドプロシージャ実行クラス
     * @param functionExecutor ストアドファンクション実行クラス
     */
    public JdbcBalloonRepository(
            StoredProcedureExecutor procedureExecutor,
            StoredFunctionExecutor functionExecutor) {
        this.procedureExecutor = procedureExecutor;
        this.functionExecutor = functionExecutor;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Balloon create(UUID ownerUserId, String title, String description, Short colorId, Short tagIconId, Boolean isPublic) {
        CreateBalloonProcedure procedure = new CreateBalloonProcedure(ownerUserId, title, description, colorId, tagIconId, isPublic);
        CreateBalloonProcedure.Result result = procedureExecutor.executeForSingle(procedure);
        return result != null ? mapToBalloon(result) : null;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<Balloon> findPublicBalloons(int limit, int offset) {
        GetPublicBalloonsFunction function = new GetPublicBalloonsFunction(limit, offset);
        List<GetPublicBalloonsFunction.Result> results = functionExecutor.execute(function);
        return results.stream()
                .map(this::mapToBalloon)
                .toList();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Optional<UUID> findSelectedBalloon(UUID userId) {
        GetBalloonSelectionFunction function = new GetBalloonSelectionFunction(userId);
        GetBalloonSelectionFunction.Result result = functionExecutor.executeForSingle(function);
        return result != null ? Optional.of(result.getBalloonId()) : Optional.empty();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void setSelection(UUID userId, UUID balloonId) {
        SetBalloonSelectionProcedure procedure = new SetBalloonSelectionProcedure(userId, balloonId);
        procedureExecutor.execute(procedure);
    }

    /**
     * {@link CreateBalloonProcedure.Result}をドメインモデル{@link Balloon}に変換します。
     *
     * @param result ストアドプロシージャの実行結果
     * @return ドメインモデルのBalloonオブジェクト
     */
    private Balloon mapToBalloon(CreateBalloonProcedure.Result result) {
        return new Balloon(
                result.getId(),
                result.getBalloonType(),
                result.getDisplayGroup(),
                result.getVisibility(),
                result.getOwnerUserId(),
                result.getTitle(),
                result.getDescription(),
                result.getColorId(),
                result.getTagIconId(),
                result.getCountryCode(),
                result.getIsActive(),
                result.getCreatedAt(),
                result.getUpdatedAt()
        );
    }

    /**
     * {@link GetPublicBalloonsFunction.Result}をドメインモデル{@link Balloon}に変換します。
     *
     * @param result ストアドファンクションの実行結果
     * @return ドメインモデルのBalloonオブジェクト
     */
    private Balloon mapToBalloon(GetPublicBalloonsFunction.Result result) {
        return new Balloon(
                result.getId(),
                result.getBalloonType(),
                result.getDisplayGroup(),
                result.getVisibility(),
                result.getOwnerUserId(),
                result.getTitle(),
                result.getDescription(),
                result.getColorId(),
                result.getTagIconId(),
                result.getCountryCode(),
                result.getIsActive(),
                result.getCreatedAt(),
                result.getUpdatedAt()
        );
    }
}
