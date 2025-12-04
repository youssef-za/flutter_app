package com.medical.emotionmonitoring.controller;

import com.medical.emotionmonitoring.dto.EmotionRequest;
import com.medical.emotionmonitoring.dto.EmotionResponse;
import com.medical.emotionmonitoring.dto.EmotionStatisticsResponse;
import com.medical.emotionmonitoring.entity.Role;
import com.medical.emotionmonitoring.entity.User;
import com.medical.emotionmonitoring.exception.BusinessException;
import com.medical.emotionmonitoring.exception.EntityNotFoundException;
import com.medical.emotionmonitoring.exception.ValidationException;
import com.medical.emotionmonitoring.repository.UserRepository;
import com.medical.emotionmonitoring.service.EmotionService;
import com.medical.emotionmonitoring.service.EmotionStatisticsService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/emotions")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class EmotionController {

    private final EmotionService emotionService;
    private final EmotionStatisticsService emotionStatisticsService;
    private final UserRepository userRepository;

    @PostMapping
    public ResponseEntity<EmotionResponse> createEmotion(@Valid @RequestBody EmotionRequest request) {
        Long patientId = getCurrentUserId();
        EmotionResponse response = emotionService.createEmotion(patientId, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @GetMapping("/{id}")
    public ResponseEntity<EmotionResponse> getEmotionById(@PathVariable Long id) {
        Long patientId = getCurrentUserId();
        EmotionResponse response = emotionService.getEmotionById(id, patientId);
        return ResponseEntity.ok(response);
    }

    @PostMapping(value = "/detect", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<EmotionResponse> detectEmotionFromImage(@RequestParam("image") MultipartFile imageFile) {
        // Detailed logging for debugging
        log.info("=== Emotion Detection Request ===");
        log.info("Image file name: {}", imageFile.getOriginalFilename());
        log.info("Image file size: {} bytes", imageFile.getSize());
        log.info("Image content type: {}", imageFile.getContentType());
        
        if (imageFile.isEmpty()) {
            log.warn("Empty image file received");
            throw new ValidationException("Image file is required");
        }

        // Validate image type
        String contentType = imageFile.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            log.warn("Invalid content type: {}", contentType);
            throw new ValidationException("File must be an image");
        }

        // Log base64 preview (first 50 chars)
        try {
            byte[] imageBytes = imageFile.getBytes();
            String base64Preview = java.util.Base64.getEncoder().encodeToString(imageBytes);
            log.debug("Base64 image length: {} chars, preview: {}...", 
                    base64Preview.length(), 
                    base64Preview.length() > 50 ? base64Preview.substring(0, 50) : base64Preview);
        } catch (Exception e) {
            log.warn("Could not encode image to base64 for logging: {}", e.getMessage());
        }

        Long patientId = getCurrentUserId();
        log.info("Processing emotion detection for patient ID: {}", patientId);
        
        EmotionResponse response = emotionService.createEmotionFromImage(patientId, imageFile);
        
        log.info("Emotion detection successful: emotionType={}, confidence={}, emotionId={}", 
                response.getEmotionType(), response.getConfidence(), response.getId());
        
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @GetMapping("/patient/{patientId}")
    public ResponseEntity<List<EmotionResponse>> getEmotionHistoryByPatientId(@PathVariable Long patientId) {
        Long currentUserId = getCurrentUserId();
        Role currentUserRole = getCurrentUserRole();
        
        List<EmotionResponse> emotions = emotionService.getEmotionHistoryByPatientId(
                patientId, currentUserId, currentUserRole);
        
        return ResponseEntity.ok(emotions);
    }

    @GetMapping("/patient/{patientId}/statistics")
    public ResponseEntity<EmotionStatisticsResponse> getPatientStatistics(
            @PathVariable Long patientId) {
        Long currentUserId = getCurrentUserId();
        Role currentUserRole = getCurrentUserRole();
        
        // Authorization check
        if (currentUserRole == Role.PATIENT && !patientId.equals(currentUserId)) {
            throw new BusinessException(
                    "Unauthorized: Patients can only view their own statistics");
        }
        
        EmotionStatisticsResponse statistics = 
                emotionStatisticsService.getPatientStatistics(patientId);
        
        return ResponseEntity.ok(statistics);
    }

    private Long getCurrentUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getPrincipal() instanceof org.springframework.security.core.userdetails.UserDetails) {
            String email = ((org.springframework.security.core.userdetails.UserDetails) authentication.getPrincipal()).getUsername();
            return userRepository.findByEmail(email)
                    .orElseThrow(() -> new EntityNotFoundException("User not found"))
                    .getId();
        }
        throw new BusinessException("User not authenticated");
    }

    private Role getCurrentUserRole() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getPrincipal() instanceof org.springframework.security.core.userdetails.UserDetails) {
            String email = ((org.springframework.security.core.userdetails.UserDetails) authentication.getPrincipal()).getUsername();
            User user = userRepository.findByEmail(email)
                    .orElseThrow(() -> new EntityNotFoundException("User not found"));
            return user.getRole();
        }
        throw new BusinessException("User not authenticated");
    }

}

