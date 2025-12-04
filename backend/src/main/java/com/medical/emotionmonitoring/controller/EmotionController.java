package com.medical.emotionmonitoring.controller;

import com.medical.emotionmonitoring.dto.EmotionRequest;
import com.medical.emotionmonitoring.dto.EmotionResponse;
import com.medical.emotionmonitoring.dto.ErrorResponse;
import com.medical.emotionmonitoring.entity.Role;
import com.medical.emotionmonitoring.entity.User;
import com.medical.emotionmonitoring.repository.UserRepository;
import com.medical.emotionmonitoring.service.EmotionService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/emotions")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class EmotionController {

    private final EmotionService emotionService;
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
            if (imageFile.isEmpty()) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(new ErrorResponse("Image file is required"));
            }

            // Validate image type
            String contentType = imageFile.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(new ErrorResponse("File must be an image"));
            }

            Long patientId = getCurrentUserId();
            EmotionResponse response = emotionService.createEmotionFromImage(patientId, imageFile);
            
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new ErrorResponse(e.getMessage()));
        } catch (Exception e) {
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

