package com.tasbal.presentation.controller;

import com.tasbal.application.service.UserService;
import com.tasbal.domain.model.User;
import com.tasbal.presentation.dto.CreateGuestUserRequest;
import com.tasbal.presentation.dto.UserResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

/**
 * ユーザー管理REST APIコントローラー。
 *
 * <p>このコントローラーはユーザー（User）に関するHTTPエンドポイントを提供します。
 * ユーザーはTasbalアプリケーションを利用する個人を表し、
 * ゲストユーザーとして気軽にアプリを試すことができます。</p>
 *
 * <h3>主な責務:</h3>
 * <ul>
 *   <li>ゲストユーザーの作成</li>
 *   <li>現在のユーザー情報の取得</li>
 *   <li>HTTPリクエストのバリデーション</li>
 *   <li>DTOとドメインモデル間の変換</li>
 * </ul>
 *
 * <h3>主な機能:</h3>
 * <ul>
 *   <li>ユーザー登録なしでゲストとしてアプリを利用開始できる</li>
 *   <li>自分のユーザー情報を参照できる</li>
 * </ul>
 *
 * @author Tasbal Team
 * @since 1.0.0
 * @see UserService
 * @see CreateGuestUserRequest
 * @see UserResponse
 */
@RestController
@RequestMapping("/api/v1")
@Tag(name = "Users", description = "ユーザー管理API")
public class UserController {

    private final UserService userService;

    /**
     * コンストラクタインジェクション。
     *
     * @param userService ユーザービジネスロジックを提供するサービス
     */
    public UserController(UserService userService) {
        this.userService = userService;
    }

    /**
     * 新しいゲストユーザーを作成します。
     *
     * <p>ユーザー登録なしでアプリを利用開始できるゲストユーザーを作成します。
     * ハンドル名は任意で指定でき、指定しない場合は自動生成されます。
     * ゲストユーザーはフリープランで作成され、即座にアプリを利用できます。</p>
     *
     * @param request ゲストユーザー作成リクエスト（ハンドル名は任意）
     * @return 作成されたユーザーのレスポンスDTO（ステータス: 201 CREATED）
     */
    @PostMapping("/users/guest")
    @Operation(summary = "ゲストユーザーを作成", description = "新しいゲストユーザーを作成します")
    public ResponseEntity<UserResponse> createGuestUser(@RequestBody(required = false) CreateGuestUserRequest request) {
        String handle = (request != null) ? request.getHandle() : null;
        User user = userService.createGuestUser(handle);
        return ResponseEntity.status(HttpStatus.CREATED).body(UserResponse.from(user));
    }

    /**
     * 現在のユーザー情報を取得します。
     *
     * <p>リクエストヘッダーから取得したユーザーIDに基づいて、
     * 現在ログイン中のユーザー情報を取得します。
     * ユーザーID、ハンドル名、プラン、ゲストフラグ、作成日時が返却されます。</p>
     *
     * @param userId リクエストヘッダーから取得されたユーザーID
     * @return 現在のユーザーのレスポンスDTO
     */
    @GetMapping("/me")
    @Operation(summary = "自分の情報を取得", description = "現在のユーザー情報を取得します")
    public ResponseEntity<UserResponse> getCurrentUser(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") UUID userId) {
        User user = userService.getUserById(userId);
        return ResponseEntity.ok(UserResponse.from(user));
    }
}
