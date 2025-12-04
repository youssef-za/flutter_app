package com.medical.emotionmonitoring.controller;

import com.medical.emotionmonitoring.dto.AlertResponse;
import com.medical.emotionmonitoring.service.AlertService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/alerts")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class AlertController {

    private final AlertService alertService;

    @GetMapping("/doctor/{doctorId}")
    @PreAuthorize("hasRole('DOCTOR')")
    public ResponseEntity<List<AlertResponse>> getAlertsByDoctorId(@PathVariable Long doctorId) {
        try {
            List<AlertResponse> alerts = alertService.getAlertsByDoctorId(doctorId).stream()
                    .map(this::mapToAlertResponse)
                    .collect(Collectors.toList());
            return ResponseEntity.ok(alerts);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/doctor/{doctorId}/unread")
    @PreAuthorize("hasRole('DOCTOR')")
    public ResponseEntity<List<AlertResponse>> getUnreadAlertsByDoctorId(@PathVariable Long doctorId) {
        try {
            List<AlertResponse> alerts = alertService.getUnreadAlertsByDoctorId(doctorId).stream()
                    .map(this::mapToAlertResponse)
                    .collect(Collectors.toList());
            return ResponseEntity.ok(alerts);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PutMapping("/{alertId}/read")
    @PreAuthorize("hasRole('DOCTOR')")
    public ResponseEntity<?> markAlertAsRead(@PathVariable Long alertId) {
        try {
            alertService.markAsRead(alertId);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
    }

    private AlertResponse mapToAlertResponse(com.medical.emotionmonitoring.entity.Alert alert) {
        AlertResponse response = new AlertResponse();
        response.setId(alert.getId());
        response.setMessage(alert.getMessage());
        response.setCreatedAt(alert.getCreatedAt());
        response.setIsRead(alert.getIsRead());
        response.setPatientId(alert.getPatient().getId());
        response.setPatientName(alert.getPatient().getFullName());
        response.setDoctorId(alert.getDoctor().getId());
        response.setDoctorName(alert.getDoctor().getFullName());
        return response;
    }
}

