package com.tasbal.presentation.exception;

import java.time.OffsetDateTime;
import java.util.Map;

/**
 * エラーレスポンスDTO。
 *
 * <p>APIのエラー時に返却する統一フォーマットのレスポンスオブジェクトです。
 * クライアント側で一貫したエラーハンドリングを可能にします。</p>
 *
 * <h3>レスポンス構造:</h3>
 * <pre>
 * {
 *   "code": "エラーコード",
 *   "message": "エラーメッセージ",
 *   "timestamp": "発生日時（ISO 8601形式）",
 *   "details": {
 *     // 追加のエラー詳細情報
 *   }
 * }
 * </pre>
 *
 * @author Tasbal Team
 * @since 1.0.0
 * @see GlobalExceptionHandler
 */
public class ErrorResponse {
    private String code;
    private String message;
    private OffsetDateTime timestamp;
    private Map<String, Object> details;

    /**
     * エラーレスポンスを構築します。
     *
     * <p>タイムスタンプは自動的に現在日時で設定されます。</p>
     *
     * @param code エラーコード（例: "VALIDATION_ERROR", "INTERNAL_ERROR"）
     * @param message ユーザーに表示するエラーメッセージ
     * @param details 追加のエラー詳細情報（フィールドエラー、スタックトレースなど）
     */
    public ErrorResponse(String code, String message, Map<String, Object> details) {
        this.code = code;
        this.message = message;
        this.timestamp = OffsetDateTime.now();
        this.details = details;
    }

    /**
     * エラーコードを取得します。
     *
     * @return エラーコード
     */
    public String getCode() {
        return code;
    }

    /**
     * エラーコードを設定します。
     *
     * @param code エラーコード
     */
    public void setCode(String code) {
        this.code = code;
    }

    /**
     * エラーメッセージを取得します。
     *
     * @return エラーメッセージ
     */
    public String getMessage() {
        return message;
    }

    /**
     * エラーメッセージを設定します。
     *
     * @param message エラーメッセージ
     */
    public void setMessage(String message) {
        this.message = message;
    }

    /**
     * エラー発生日時を取得します。
     *
     * @return エラー発生日時
     */
    public OffsetDateTime getTimestamp() {
        return timestamp;
    }

    /**
     * エラー発生日時を設定します。
     *
     * @param timestamp エラー発生日時
     */
    public void setTimestamp(OffsetDateTime timestamp) {
        this.timestamp = timestamp;
    }

    /**
     * エラー詳細情報を取得します。
     *
     * @return エラー詳細情報のマップ
     */
    public Map<String, Object> getDetails() {
        return details;
    }

    /**
     * エラー詳細情報を設定します。
     *
     * @param details エラー詳細情報のマップ
     */
    public void setDetails(Map<String, Object> details) {
        this.details = details;
    }
}
