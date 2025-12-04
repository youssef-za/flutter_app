package com.medical.emotionmonitoring.controller;

import com.medical.emotionmonitoring.dto.EmotionRequest;
import com.medical.emotionmonitoring.dto.EmotionResponse;
import com.medical.emotionmonitoring.dto.ErrorResponse;
import com.medical.emotionmonitoring.entity.Role;
import com.medical.emotionmonitoring.entity.User;
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
    public ResponseEntity<?> createEmotion(@Valid @RequestBody EmotionRequest request) {
        try {
            Long patientId = getCurrentUserId();
            EmotionResponse response = emotionService.createEmotion(patientId, request);
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new ErrorResponse(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ErrorResponse("An error occurred while saving emotion"));
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getEmotionById(@PathVariable Long id) {
        try {
            Long patientId = getCurrentUserId();
            EmotionResponse response = emotionService.getEmotionById(id, patientId);
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new ErrorResponse(e.getMessage()));
        }
    }

    @PostMapping(value = "/detect", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<?> detectEmotionFromImage(@RequestParam("image") MultipartFile imageFile) {
        try {
            // Detailed logging for debugging
            log.info("=== Emotion Detection Request ===");
            log.info("Image file name: {}", imageFile.getOriginalFilename());
            log.info("Image file size: {} bytes", imageFile.getSize());
            log.info("Image content type: {}", imageFile.getContentType());
            
            if (imageFile.isEmpty()) {
                log.warn("Empty image file received");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(new ErrorResponse("Image file is required"));
            }

            // Validate image type
            String contentType = imageFile.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                log.warn("Invalid content type: {}", contentType);
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(new ErrorResponse("File must be an image"));
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
        } catch (RuntimeException e) {
            log.error("Runtime error in emotion detection: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new ErrorResponse(e.getMessage()));
        } catch (Exception e) {
            log.error("Unexpected error in emotion detection: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ErrorResponse("An error occurred while processing the image"));
        }
    }

    @GetMapping("/patient/{patientId}")
    public ResponseEntity<?> getEmotionHistoryByPatientId(@PathVariable Long patientId) {
        try {
            Long currentUserId = getCurrentUserId();
            Role currentUserRole = getCurrentUserRole();
            
            List<EmotionResponse> emotions = emotionService.getEmotionHistoryByPatientId(
                    patientId, currentUserId, currentUserRole);
            
            return ResponseEntity.ok(emotions);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(new ErrorResponse(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ErrorResponse("An error occurred while fetching emotion history"));
        }
    }

    @GetMapping("/patient/{patientId}/statistics")
    public ResponseEntity<?> getPatientStatistics(@PathVariable Long patientId) {
        try {
            Long currentUserId = getCurrentUserId();
            Role currentUserRole = getCurrentUserRole();
            
            // Authorization check
            if (currentUserRole == Role.PATIENT && !patientId.equals(currentUserId)) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body(new ErrorResponse("Unauthorized: Patients can only view their own statistics"));
            }
            
            com.medical.emotionmonitoring.dto.EmotionStatisticsResponse statistics = 
                    emotionStatisticsService.getPatientStatistics(patientId);
            
            return ResponseEntity.ok(statistics);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(new ErrorResponse(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ErrorResponse("An error occurred while fetching statistics"));
        }
    }

    private Long getCurrentUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getPrincipal() instanceof org.springframework.security.core.userdetails.UserDetails) {
            String email = ((org.springframework.security.core.userdetails.UserDetails) authentication.getPrincipal()).getUsername();
            return userRepository.findByEmail(email)
                    .orElseThrow(() -> new RuntimeException("User not found"))
                    .getId();
        }
        throw new RuntimeException("User not authenticated");
    }

    private Role getCurrentUserRole() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getPrincipal() instanceof org.springframework.security.core.userdetails.UserDetails) {
            String email = ((org.springframework.security.core.userdetails.UserDetails) authentication.getPrincipal()).getUsername();
            User user = userRepository.findByEmail(email)
                    .orElseThrow(() -> new RuntimeException("User not found"));
            return user.getRole();
        }
        throw new RuntimeException("User not authenticated");
    }

}

