package com.tasbal.presentation.exception;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.HashMap;
import java.util.Map;

/**
 * グローバル例外ハンドラー。
 *
 * <p>アプリケーション全体で発生する例外を一元的に捕捉し、
 * 統一フォーマットのエラーレスポンスを生成します。
 * これにより、クライアント側で一貫したエラーハンドリングが可能になります。</p>
 *
 * <h3>ハンドリングする例外:</h3>
 * <ul>
 *   <li>{@link MethodArgumentNotValidException} - バリデーションエラー（400 Bad Request）</li>
 *   <li>{@link IllegalArgumentException} - 不正な引数エラー（400 Bad Request）</li>
 *   <li>{@link RuntimeException} - 実行時エラー（500 Internal Server Error）</li>
 *   <li>{@link Exception} - その他の予期しないエラー（500 Internal Server Error）</li>
 * </ul>
 *
 * @author Tasbal Team
 * @since 1.0.0
 * @see ErrorResponse
 * @see RestControllerAdvice
 */
@RestControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    /**
     * バリデーション例外をハンドリングします。
     *
     * <p>Spring MVCの{@code @Valid}アノテーションによるバリデーションエラーを捕捉し、
     * フィールドごとのエラーメッセージを含むレスポンスを返します。</p>
     *
     * <h4>レスポンス例:</h4>
     * <pre>
     * {
     *   "error": {
     *     "code": "VALIDATION_ERROR",
     *     "message": "Validation failed",
     *     "details": {
     *       "title": "タイトルは必須です",
     *       "dueAt": "期限日時は未来の日時を指定してください"
     *     }
     *   }
     * }
     * </pre>
     *
     * @param ex バリデーション例外
     * @return HTTPステータス400とエラー詳細を含むレスポンス
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, Object>> handleValidationExceptions(MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getAllErrors().forEach((error) -> {
            String fieldName = ((FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            errors.put(fieldName, errorMessage);
        });

        Map<String, Object> response = new HashMap<>();
        Map<String, Object> errorDetails = new HashMap<>();
        errorDetails.put("code", "VALIDATION_ERROR");
        errorDetails.put("message", "Validation failed");
        errorDetails.put("details", errors);
        response.put("error", errorDetails);

        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
    }

    /**
     * 実行時例外をハンドリングします。
     *
     * <p>アプリケーション実行中に発生したランタイムエラーを捕捉し、
     * エラーメッセージを含む500エラーレスポンスを返します。</p>
     *
     * @param ex 実行時例外
     * @return HTTPステータス500とエラーメッセージを含むレスポンス
     */
    @ExceptionHandler(RuntimeException.class)
    public ResponseEntity<Map<String, Object>> handleRuntimeException(RuntimeException ex) {
        Map<String, Object> response = new HashMap<>();
        Map<String, Object> errorDetails = new HashMap<>();
        errorDetails.put("code", "INTERNAL_ERROR");
        errorDetails.put("message", ex.getMessage());
        response.put("error", errorDetails);

        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
    }

    /**
     * 不正な引数例外をハンドリングします。
     *
     * <p>メソッド引数が不正な場合に発生する例外を捕捉し、
     * エラーメッセージを含む400エラーレスポンスを返します。</p>
     *
     * @param ex 不正な引数例外
     * @return HTTPステータス400とエラーメッセージを含むレスポンス
     */
    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<Map<String, Object>> handleIllegalArgumentException(IllegalArgumentException ex) {
        Map<String, Object> response = new HashMap<>();
        Map<String, Object> errorDetails = new HashMap<>();
        errorDetails.put("code", "BAD_REQUEST");
        errorDetails.put("message", ex.getMessage());
        response.put("error", errorDetails);

        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
    }

    /**
     * その他の予期しない例外をハンドリングします。
     *
     * <p>上記の特定の例外ハンドラーで捕捉されなかったすべての例外を捕捉します。
     * エラー内容はログに記録され、汎用的なエラーメッセージがクライアントに返されます。
     * これにより、システム内部の詳細情報が外部に漏洩することを防ぎます。</p>
     *
     * @param ex 予期しない例外
     * @return HTTPステータス500と汎用エラーメッセージを含むレスポンス
     */
    @ExceptionHandler(Exception.class)
    public ResponseEntity<Map<String, Object>> handleGenericException(Exception ex) {
        logger.error("Unexpected error occurred", ex);
        Map<String, Object> response = new HashMap<>();
        Map<String, Object> errorDetails = new HashMap<>();
        errorDetails.put("code", "INTERNAL_ERROR");
        errorDetails.put("message", "An unexpected error occurred");
        errorDetails.put("details", Map.of("exception", ex.getClass().getSimpleName()));
        response.put("error", errorDetails);

        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
    }
}
