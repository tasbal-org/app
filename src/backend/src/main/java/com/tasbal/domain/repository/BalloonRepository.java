package com.tasbal.domain.repository;

import com.tasbal.domain.model.Balloon;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * バルーンのリポジトリインターフェース。
 *
 * <p>このインターフェースは、バルーンエンティティの永続化層へのアクセスを定義します。
 * Tasbalアプリケーションにおけるバルーンの作成、検索、選択状態の管理を提供します。</p>
 *
 * <p>実装クラスは、ストアドプロシージャ・ストアドファンクションを経由して
 * データベースアクセスを行う必要があります。</p>
 *
 * @author Tasbal Team
 * @since 1.0.0
 * @see Balloon
 */
public interface BalloonRepository {
    /**
     * 新しいバルーンを作成します。
     *
     * @param ownerUserId バルーンの所有者のユーザーID
     * @param title バルーンのタイトル
     * @param description バルーンの説明
     * @param colorId バルーンの色ID
     * @param tagIconId バルーンのタグアイコンID
     * @param isPublic バルーンを公開するかどうか
     * @return 作成されたバルーンオブジェクト
     */
    Balloon create(UUID ownerUserId, String title, String description, Short colorId, Short tagIconId, Boolean isPublic);

    /**
     * 公開されているバルーンの一覧を取得します。
     *
     * @param limit 取得する最大件数
     * @param offset 取得開始位置（ページネーション用）
     * @return 公開バルーンのリスト
     */
    List<Balloon> findPublicBalloons(int limit, int offset);

    /**
     * 指定されたユーザーが現在選択しているバルーンのIDを取得します。
     *
     * @param userId 対象ユーザーのID
     * @return 選択中のバルーンID（選択されていない場合は空のOptional）
     */
    Optional<UUID> findSelectedBalloon(UUID userId);

    /**
     * ユーザーの選択バルーンを設定します。
     *
     * @param userId 対象ユーザーのID
     * @param balloonId 選択するバルーンのID
     */
    void setSelection(UUID userId, UUID balloonId);
}
