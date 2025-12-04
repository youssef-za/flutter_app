package com.medical.emotionmonitoring.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ErrorResponse {
    private String error = "Error";
    private String message;

    public ErrorResponse(String message) {
        this.error = "Error";
        this.message = message;
    }
}

