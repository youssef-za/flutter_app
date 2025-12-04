package com.medical.emotionmonitoring.service;

import com.medical.emotionmonitoring.dto.EmotionDetectionResponse;
import com.medical.emotionmonitoring.dto.EmotionRequest;
import com.medical.emotionmonitoring.dto.EmotionResponse;
import com.medical.emotionmonitoring.entity.Alert;
import com.medical.emotionmonitoring.entity.Emotion;
import com.medical.emotionmonitoring.entity.EmotionTypeEnum;
import com.medical.emotionmonitoring.entity.Role;
import com.medical.emotionmonitoring.entity.User;
import com.medical.emotionmonitoring.repository.EmotionRepository;
import com.medical.emotionmonitoring.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class EmotionService {

    private final EmotionRepository emotionRepository;
    private final UserRepository userRepository;
    private final AlertService alertService;
    private final EmotionDetectionService emotionDetectionService;

    @Transactional
    public EmotionResponse createEmotion(Long patientId, EmotionRequest request) {
        User patient = userRepository.findById(patientId)
                .orElseThrow(() -> new RuntimeException("Patient not found"));

        Emotion emotion = new Emotion();
        emotion.setEmotionType(request.getEmotionType());
        emotion.setConfidence(request.getConfidence());
        emotion.setPatient(patient);
        emotion.setTimestamp(request.getTimestamp() != null ? request.getTimestamp() : LocalDateTime.now());

        Emotion savedEmotion = emotionRepository.save(emotion);

        // Check for 3 consecutive SAD emotions and trigger alert
        checkAndTriggerSadAlert(patientId);

        return mapToResponse(savedEmotion);
    }

    /**
     * Detect emotion from image and save it
     */
    @Transactional
    public EmotionResponse createEmotionFromImage(Long patientId, MultipartFile imageFile) {
        User patient = userRepository.findById(patientId)
                .orElseThrow(() -> new RuntimeException("Patient not found"));

        // Detect emotion from image
        EmotionDetectionResponse detectionResponse = emotionDetectionService.detectEmotionFromImage(imageFile);
        
        // Map detected emotion to EmotionTypeEnum
        EmotionTypeEnum emotionType = emotionDetectionService.mapToEmotionTypeEnum(detectionResponse.getEmotion());
        Double confidence = detectionResponse.getConfidence();

        // Create emotion entity
        Emotion emotion = new Emotion();
        emotion.setEmotionType(emotionType);
        emotion.setConfidence(confidence);
        emotion.setPatient(patient);
        emotion.setTimestamp(LocalDateTime.now());

        Emotion savedEmotion = emotionRepository.save(emotion);

        // Check for 3 consecutive SAD emotions and trigger alert
        checkAndTriggerSadAlert(patientId);

        log.info("Emotion detected from image for patient {}: {} with confidence {}", 
                patientId, emotionType, confidence);

        return mapToResponse(savedEmotion);
    }

    /**
     * Check if patient has 3 consecutive SAD emotions and trigger an alert
     * Only creates an alert if one hasn't been created recently for the same pattern
     */
    private void checkAndTriggerSadAlert(Long patientId) {
        List<Emotion> recentEmotions = emotionRepository.findByPatientIdOrderByTimestampDesc(patientId);

        // Check if we have at least 3 emotions
        if (recentEmotions.size() < 3) {
            return;
        }

        // Get the last 3 emotions (most recent first)
        List<Emotion> lastThreeEmotions = recentEmotions.subList(0, Math.min(3, recentEmotions.size()));

        // Check if all 3 are SAD
        boolean allSad = lastThreeEmotions.stream()
                .allMatch(e -> e.getEmotionType() == EmotionTypeEnum.SAD);

        if (allSad) {
            // Check if an alert was already created recently (within last hour) to avoid duplicates
            List<Alert> recentAlerts = alertService.getAlertsByPatientId(patientId);
            LocalDateTime oneHourAgo = LocalDateTime.now().minusHours(1);
            
            boolean recentAlertExists = recentAlerts.stream()
                    .anyMatch(alert -> alert.getCreatedAt().isAfter(oneHourAgo) 
                            && alert.getMessage().contains("3 consecutive SAD emotions"));

            if (recentAlertExists) {
                log.debug("Alert already exists for patient {} within the last hour, skipping duplicate alert", patientId);
                return;
            }

            User patient = userRepository.findById(patientId)
                    .orElseThrow(() -> new RuntimeException("Patient not found"));

            String message = String.format(
                    "Alert: Patient %s has recorded 3 consecutive SAD emotions. Please review their emotional state.",
                    patient.getFullName()
            );

            try {
                alertService.createAlert(patientId, message);
                log.info("Alert created for patient {} due to 3 consecutive SAD emotions", patientId);
            } catch (Exception e) {
                log.error("Failed to create alert for patient {}: {}", patientId, e.getMessage());
                // Don't throw exception - alert creation failure shouldn't break emotion creation
            }
        }
    }

    public EmotionResponse getEmotionById(Long id, Long patientId) {
        Emotion emotion = emotionRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Emotion not found"));

        if (!emotion.getPatient().getId().equals(patientId)) {
            throw new RuntimeException("Unauthorized access to emotion");
        }

        return mapToResponse(emotion);
    }

    public List<EmotionResponse> getEmotionHistoryByPatientId(Long patientId, Long currentUserId, Role currentUserRole) {
        // Check if patient exists
        if (!userRepository.existsById(patientId)) {
            throw new RuntimeException("Patient not found");
        }

        // Authorization check: Patients can only view their own history, Doctors can view any patient's history
        if (currentUserRole == Role.PATIENT && !patientId.equals(currentUserId)) {
            throw new RuntimeException("Unauthorized: Patients can only view their own emotion history");
        }

        List<Emotion> emotions = emotionRepository.findByPatientIdOrderByTimestampDesc(patientId);
        return emotions.stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    private EmotionResponse mapToResponse(Emotion emotion) {
        EmotionResponse response = new EmotionResponse();
        response.setId(emotion.getId());
        response.setEmotionType(emotion.getEmotionType());
        response.setConfidence(emotion.getConfidence());
        response.setTimestamp(emotion.getTimestamp());
        response.setPatientId(emotion.getPatient().getId());
        response.setPatientName(emotion.getPatient().getFullName());
        return response;
    }
}

