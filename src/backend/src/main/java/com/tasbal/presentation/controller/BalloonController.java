package com.tasbal.presentation.controller;

import com.tasbal.application.service.BalloonService;
import com.tasbal.domain.model.Balloon;
import com.tasbal.presentation.dto.BalloonRequest;
import com.tasbal.presentation.dto.BalloonResponse;
import com.tasbal.presentation.dto.BalloonSelectionRequest;
import com.tasbal.presentation.dto.BalloonSelectionResponse;
import com.tasbal.presentation.dto.MessageResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * 風船管理REST APIコントローラー。
 *
 * <p>このコントローラーは風船（Balloon）に関するHTTPエンドポイントを提供します。
 * 風船はユーザーがタスクを達成した際に膨らむ共有可能な達成感の可視化オブジェクトです。</p>
 *
 * <h3>主な責務:</h3>
 * <ul>
 *   <li>風船の作成</li>
 *   <li>公開風船の一覧取得</li>
 *   <li>選択中の風船の取得・設定</li>
 *   <li>HTTPリクエストのバリデーション</li>
 *   <li>DTOとドメインモデル間の変換</li>
 * </ul>
 *
 * <h3>主な機能:</h3>
 * <ul>
 *   <li>ユーザーが自分の風船を作成できる</li>
 *   <li>公開されている風船の一覧を参照できる</li>
 *   <li>タスク完了時に加算される風船を選択できる</li>
 * </ul>
 *
 * @author Tasbal Team
 * @since 1.0.0
 * @see BalloonService
 * @see BalloonRequest
 * @see BalloonResponse
 */
@RestController
@RequestMapping("/api/v1/balloons")
@Tag(name = "Balloons", description = "風船管理API")
public class BalloonController {

    private final BalloonService balloonService;

    /**
     * コンストラクタインジェクション。
     *
     * @param balloonService 風船ビジネスロジックを提供するサービス
     */
    public BalloonController(BalloonService balloonService) {
        this.balloonService = balloonService;
    }

    /**
     * 新しい風船を作成します。
     *
     * <p>ユーザーが新しい風船を作成します。
     * 風船にはタイトル、説明、色、アイコン、公開設定を指定できます。
     * 作成された風船は自動的にそのユーザーに関連付けられます。</p>
     *
     * @param userId リクエストヘッダーから取得されたユーザーID
     * @param request 風船作成リクエスト（タイトル、説明、色ID、タグアイコンID、公開設定）
     * @return 作成された風船のレスポンスDTO（ステータス: 201 CREATED）
     */
    @PostMapping
    @Operation(summary = "風船を作成", description = "新しいユーザー作成風船を作成します")
    public ResponseEntity<BalloonResponse> createBalloon(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") UUID userId,
            @Valid @RequestBody BalloonRequest request) {
        Balloon balloon = balloonService.createBalloon(
                userId,
                request.getTitle(),
                request.getDescription(),
                request.getColorId(),
                request.getTagIconId(),
                request.getIsPublic()
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(BalloonResponse.from(balloon));
    }

    /**
     * 公開風船の一覧を取得します。
     *
     * <p>すべてのユーザーが参加可能な公開設定の風船一覧を取得します。
     * ページネーションに対応しており、取得件数とオフセットを指定できます。</p>
     *
     * @param limit 取得件数（デフォルト: 20）
     * @param offset 取得開始位置のオフセット（デフォルト: 0）
     * @return 公開風船のレスポンスDTOリスト
     */
    @GetMapping("/public")
    @Operation(summary = "公開風船一覧を取得", description = "すべてのユーザーが参加可能な公開風船の一覧を取得します")
    public ResponseEntity<List<BalloonResponse>> getPublicBalloons(
            @Parameter(description = "取得件数") @RequestParam(defaultValue = "20") int limit,
            @Parameter(description = "オフセット") @RequestParam(defaultValue = "0") int offset) {
        List<Balloon> balloons = balloonService.getPublicBalloons(limit, offset);
        List<BalloonResponse> responses = balloons.stream()
                .map(BalloonResponse::from)
                .collect(Collectors.toList());
        return ResponseEntity.ok(responses);
    }

    /**
     * 選択中の風船を取得します。
     *
     * <p>ユーザーが現在選択している風船のIDを取得します。
     * 選択中の風船は、タスク完了時に達成度が加算される対象となります。</p>
     *
     * @param userId リクエストヘッダーから取得されたユーザーID
     * @return 選択中の風船IDを含むレスポンス
     */
    @GetMapping("/selection")
    @Operation(summary = "選択中の風船を取得", description = "現在選択している風船のIDを取得します")
    public ResponseEntity<BalloonSelectionResponse> getSelectedBalloon(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") UUID userId) {
        UUID balloonId = balloonService.getSelectedBalloon(userId);
        return ResponseEntity.ok(new BalloonSelectionResponse(balloonId));
    }

    /**
     * 選択中の風船を設定します。
     *
     * <p>ユーザーが選択する風船を変更します。
     * 選択された風船は、タスク完了時に達成度が加算される対象となります。</p>
     *
     * @param userId リクエストヘッダーから取得されたユーザーID
     * @param request 選択する風船のIDを含むリクエスト
     * @return 更新成功メッセージ
     */
    @PutMapping("/selection")
    @Operation(summary = "選択中の風船を設定", description = "タスク完了時に加算される風船を選択します")
    public ResponseEntity<MessageResponse> setSelectedBalloon(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") UUID userId,
            @Valid @RequestBody BalloonSelectionRequest request) {
        balloonService.setSelectedBalloon(userId, request.getBalloonId());
        return ResponseEntity.ok(new MessageResponse("Selection updated"));
    }
}
