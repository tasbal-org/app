package com.tasbal.backend.presentation.controller;

import com.tasbal.backend.application.service.UserService;
import com.tasbal.backend.domain.model.User;
import com.tasbal.backend.presentation.dto.CreateGuestUserRequest;
import com.tasbal.backend.presentation.dto.UserResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/v1")
@Tag(name = "Users", description = "ユーザー管理API")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping("/users/guest")
    @Operation(summary = "ゲストユーザーを作成", description = "新しいゲストユーザーを作成します")
    public ResponseEntity<UserResponse> createGuestUser(@RequestBody(required = false) CreateGuestUserRequest request) {
        String handle = (request != null) ? request.getHandle() : null;
        User user = userService.createGuestUser(handle);
        return ResponseEntity.status(HttpStatus.CREATED).body(UserResponse.from(user));
    }

    @GetMapping("/me")
    @Operation(summary = "自分の情報を取得", description = "現在のユーザー情報を取得します")
    public ResponseEntity<UserResponse> getCurrentUser(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") UUID userId) {
        User user = userService.getUserById(userId);
        return ResponseEntity.ok(UserResponse.from(user));
    }
}
