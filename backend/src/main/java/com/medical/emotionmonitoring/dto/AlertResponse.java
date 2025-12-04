package com.medical.emotionmonitoring.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AlertResponse {
    private Long id;
    private String message;
    private LocalDateTime createdAt;
    private Boolean isRead;
    private Long patientId;
    private String patientName;
    private Long doctorId;
    private String doctorName;
}

