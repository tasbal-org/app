package com.tasbal.backend.presentation.exception;

import java.time.OffsetDateTime;
import java.util.Map;

public class ErrorResponse {
    private String code;
    private String message;
    private OffsetDateTime timestamp;
    private Map<String, Object> details;

    public ErrorResponse(String code, String message, Map<String, Object> details) {
        this.code = code;
        this.message = message;
        this.timestamp = OffsetDateTime.now();
        this.details = details;
    }

    // Getters and Setters
    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public OffsetDateTime getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(OffsetDateTime timestamp) {
        this.timestamp = timestamp;
    }

    public Map<String, Object> getDetails() {
        return details;
    }

    public void setDetails(Map<String, Object> details) {
        this.details = details;
    }
}
