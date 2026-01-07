package com.tasbal.backend.presentation.exception;

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

@RestControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

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

    @ExceptionHandler(RuntimeException.class)
    public ResponseEntity<Map<String, Object>> handleRuntimeException(RuntimeException ex) {
        Map<String, Object> response = new HashMap<>();
        Map<String, Object> errorDetails = new HashMap<>();
        errorDetails.put("code", "INTERNAL_ERROR");
        errorDetails.put("message", ex.getMessage());
        response.put("error", errorDetails);

        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<Map<String, Object>> handleIllegalArgumentException(IllegalArgumentException ex) {
        Map<String, Object> response = new HashMap<>();
        Map<String, Object> errorDetails = new HashMap<>();
        errorDetails.put("code", "BAD_REQUEST");
        errorDetails.put("message", ex.getMessage());
        response.put("error", errorDetails);

        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
    }

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
