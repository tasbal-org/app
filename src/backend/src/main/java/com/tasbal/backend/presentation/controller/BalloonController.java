package com.tasbal.backend.presentation.controller;

import com.tasbal.backend.application.service.BalloonService;
import com.tasbal.backend.domain.model.Balloon;
import com.tasbal.backend.presentation.dto.BalloonRequest;
import com.tasbal.backend.presentation.dto.BalloonResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
    public ResponseEntity<Map<String, UUID>> getSelectedBalloon(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") UUID userId) {
        UUID balloonId = balloonService.getSelectedBalloon(userId);
        Map<String, UUID> response = new HashMap<>();
        response.put("balloonId", balloonId);
        return ResponseEntity.ok(response);
    }

    @PutMapping("/selection")
    @Operation(summary = "選択中の風船を設定", description = "タスク完了時に加算される風船を選択します")
    public ResponseEntity<Map<String, String>> setSelectedBalloon(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") UUID userId,
            @RequestBody Map<String, UUID> request) {
        UUID balloonId = request.get("balloonId");
        balloonService.setSelectedBalloon(userId, balloonId);
        Map<String, String> response = new HashMap<>();
        response.put("message", "Selection updated");
        return ResponseEntity.ok(response);
    }
}
