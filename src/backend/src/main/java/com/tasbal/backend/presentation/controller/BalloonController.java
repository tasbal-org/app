package com.tasbal.backend.presentation.controller;

import com.tasbal.backend.application.service.BalloonService;
import com.tasbal.backend.domain.model.Balloon;
import com.tasbal.backend.presentation.dto.BalloonRequest;
import com.tasbal.backend.presentation.dto.BalloonResponse;
import com.tasbal.backend.presentation.dto.BalloonSelectionRequest;
import com.tasbal.backend.presentation.dto.BalloonSelectionResponse;
import com.tasbal.backend.presentation.dto.MessageResponse;
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

@RestController
@RequestMapping("/api/v1/balloons")
@Tag(name = "Balloons", description = "風船管理API")
public class BalloonController {

    private final BalloonService balloonService;

    public BalloonController(BalloonService balloonService) {
        this.balloonService = balloonService;
    }

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

    @GetMapping("/selection")
    @Operation(summary = "選択中の風船を取得", description = "現在選択している風船のIDを取得します")
    public ResponseEntity<BalloonSelectionResponse> getSelectedBalloon(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") UUID userId) {
        UUID balloonId = balloonService.getSelectedBalloon(userId);
        return ResponseEntity.ok(new BalloonSelectionResponse(balloonId));
    }

    @PutMapping("/selection")
    @Operation(summary = "選択中の風船を設定", description = "タスク完了時に加算される風船を選択します")
    public ResponseEntity<MessageResponse> setSelectedBalloon(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") UUID userId,
            @Valid @RequestBody BalloonSelectionRequest request) {
        balloonService.setSelectedBalloon(userId, request.getBalloonId());
        return ResponseEntity.ok(new MessageResponse("Selection updated"));
    }
}
