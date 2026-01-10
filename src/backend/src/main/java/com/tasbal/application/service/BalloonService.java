package com.tasbal.application.service;

import com.tasbal.domain.model.Balloon;
import com.tasbal.domain.repository.BalloonRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

/**
 * バルーンアプリケーションサービス。
 *
 * <p>このクラスはバルーン（共有タスクグループ）に関するユースケースを提供します。
 * バルーンの作成、公開バルーンの取得、選択中バルーンの管理を担当します。</p>
 *
 * <p>主な機能:</p>
 * <ul>
 *   <li>バルーンの新規作成</li>
 *   <li>公開バルーン一覧の取得（ページネーション対応）</li>
 *   <li>ユーザーが選択中のバルーン取得</li>
 *   <li>選択中バルーンの設定</li>
 * </ul>
 *
 * @author Tasbal Team
 * @since 1.0.0
 * @see BalloonRepository
 * @see Balloon
 */
@Service
@Transactional
public class BalloonService {

    private final BalloonRepository balloonRepository;

    /**
     * コンストラクタ。
     *
     * @param balloonRepository バルーンリポジトリ
     */
    public BalloonService(BalloonRepository balloonRepository) {
        this.balloonRepository = balloonRepository;
    }

    /**
     * 新しいバルーンを作成します。
     *
     * @param ownerUserId バルーンの所有者ユーザーID
     * @param title バルーンのタイトル
     * @param description バルーンの説明
     * @param colorId カラー区分値
     * @param tagIconId タグアイコン区分値
     * @param isPublic 公開フラグ（trueの場合、他のユーザーから閲覧可能）
     * @return 作成されたバルーンオブジェクト
     */
    public Balloon createBalloon(UUID ownerUserId, String title, String description, Short colorId, Short tagIconId, Boolean isPublic) {
        return balloonRepository.create(ownerUserId, title, description, colorId, tagIconId, isPublic);
    }

    /**
     * 公開バルーン一覧を取得します。
     *
     * <p>ページネーションに対応し、指定された件数とオフセットで公開バルーンを取得します。</p>
     *
     * @param limit 取得する最大件数
     * @param offset 取得開始位置（スキップする件数）
     * @return 公開バルーンのリスト
     */
    public List<Balloon> getPublicBalloons(int limit, int offset) {
        return balloonRepository.findPublicBalloons(limit, offset);
    }

    /**
     * ユーザーが現在選択中のバルーンIDを取得します。
     *
     * @param userId ユーザーID
     * @return 選択中のバルーンID、選択されていない場合はnull
     */
    public UUID getSelectedBalloon(UUID userId) {
        return balloonRepository.findSelectedBalloon(userId)
                .orElse(null);
    }

    /**
     * ユーザーの選択中バルーンを設定します。
     *
     * @param userId ユーザーID
     * @param balloonId 選択するバルーンID
     */
    public void setSelectedBalloon(UUID userId, UUID balloonId) {
        balloonRepository.setSelection(userId, balloonId);
    }
}
