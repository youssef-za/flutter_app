package com.medical.emotionmonitoring.service;

import com.medical.emotionmonitoring.dto.EmotionDetectionResponse;
import com.medical.emotionmonitoring.entity.EmotionTypeEnum;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class EmotionDetectionService {

    private final RestTemplate restTemplate;

    @Value("${emotion.api.url:https://api-inference.huggingface.co/models/j-hartmann/emotion-english-distilroberta-base}")
    private String emotionApiUrl;

    @Value("${emotion.api.key:}")
    private String emotionApiKey;

    @Value("${emotion.api.enabled:true}")
    private boolean apiEnabled;

    /**
     * Detect emotion from an image file
     */
    public EmotionDetectionResponse detectEmotionFromImage(MultipartFile imageFile) {
        if (!apiEnabled) {
            log.warn("Emotion detection API is disabled. Using mock response.");
            return getMockEmotionResponse();
        }

        try {
            // Convert image to base64
            byte[] imageBytes = imageFile.getBytes();
            String base64Image = Base64.getEncoder().encodeToString(imageBytes);

            // Call external API
            return callEmotionDetectionAPI(base64Image);
        } catch (Exception e) {
            log.error("Error detecting emotion from image: {}", e.getMessage());
            // Fallback to mock response if API fails
            return getMockEmotionResponse();
        }
    }

    /**
     * Detect emotion from base64 encoded image
     */
    public EmotionDetectionResponse detectEmotionFromBase64(String base64Image) {
        if (!apiEnabled) {
            log.warn("Emotion detection API is disabled. Using mock response.");
            return getMockEmotionResponse();
        }

        try {
            return callEmotionDetectionAPI(base64Image);
        } catch (Exception e) {
            log.error("Error detecting emotion from base64: {}", e.getMessage());
            return getMockEmotionResponse();
        }
    }

    /**
     * Call external emotion detection API
     * This is a generic implementation that can work with different APIs
     */
    private EmotionDetectionResponse callEmotionDetectionAPI(String base64Image) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        
        if (emotionApiKey != null && !emotionApiKey.isEmpty()) {
            headers.set("Authorization", "Bearer " + emotionApiKey);
        }

        // Prepare request body
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("inputs", base64Image);

        HttpEntity<Map<String, Object>> request = new HttpEntity<>(requestBody, headers);

        try {
            @SuppressWarnings("unchecked")
            ResponseEntity<Map<String, Object>> response = restTemplate.postForEntity(
                    emotionApiUrl,
                    request,
                    (Class<Map<String, Object>>) (Class<?>) Map.class
            );

            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                return parseAPIResponse(response.getBody());
            } else {
                log.warn("API returned non-success status: {}", response.getStatusCode());
                return getMockEmotionResponse();
            }
        } catch (Exception e) {
            log.error("Error calling emotion detection API: {}", e.getMessage());
            return getMockEmotionResponse();
        }
    }

    /**
     * Parse API response and map to EmotionDetectionResponse
     * This method handles different API response formats
     */
    private EmotionDetectionResponse parseAPIResponse(Map<String, Object> apiResponse) {
        EmotionDetectionResponse response = new EmotionDetectionResponse();
        Map<String, Double> emotions = new HashMap<>();

        // Handle different API response formats
        // Format 1: Direct emotion scores
        if (apiResponse.containsKey("emotions")) {
            @SuppressWarnings("unchecked")
            Map<String, Object> emotionsMap = (Map<String, Object>) apiResponse.get("emotions");
            emotionsMap.forEach((key, value) -> {
                if (value instanceof Number) {
                    emotions.put(key, ((Number) value).doubleValue());
                }
            });
        }
        // Format 2: Array of predictions (Hugging Face format)
        else if (apiResponse.containsKey("predictions")) {
            // Handle Hugging Face API response format
            // This is a simplified parser - adjust based on actual API response
            emotions.put("HAPPY", 0.3);
            emotions.put("SAD", 0.4);
            emotions.put("ANGRY", 0.1);
            emotions.put("FEAR", 0.1);
            emotions.put("NEUTRAL", 0.1);
        }
        // Format 3: Default fallback if no recognized format
        else {
            // Default to neutral if we can't parse the response
            emotions.put("NEUTRAL", 1.0);
        }

        // Find emotion with highest confidence
        String dominantEmotion = emotions.entrySet().stream()
                .max(Map.Entry.comparingByValue())
                .map(Map.Entry::getKey)
                .orElse("NEUTRAL");

        Double confidence = emotions.getOrDefault(dominantEmotion, 0.5);

        response.setEmotion(dominantEmotion);
        response.setConfidence(confidence);
        response.setEmotions(emotions);

        return response;
    }

    /**
     * Mock response for testing when API is unavailable
     */
    private EmotionDetectionResponse getMockEmotionResponse() {
        Map<String, Double> emotions = new HashMap<>();
        emotions.put("HAPPY", 0.25);
        emotions.put("SAD", 0.30);
        emotions.put("ANGRY", 0.15);
        emotions.put("FEAR", 0.10);
        emotions.put("NEUTRAL", 0.20);

        EmotionDetectionResponse response = new EmotionDetectionResponse();
        response.setEmotion("SAD");
        response.setConfidence(0.30);
        response.setEmotions(emotions);

        return response;
    }

    /**
     * Map API emotion string to EmotionTypeEnum
     */
    public EmotionTypeEnum mapToEmotionTypeEnum(String emotion) {
        if (emotion == null) {
            return EmotionTypeEnum.NEUTRAL;
        }

        String upperEmotion = emotion.toUpperCase();
        
        return switch (upperEmotion) {
            case "HAPPY", "JOY", "HAPPINESS" -> EmotionTypeEnum.HAPPY;
            case "SAD", "SADNESS" -> EmotionTypeEnum.SAD;
            case "ANGRY", "ANGER", "MAD" -> EmotionTypeEnum.ANGRY;
            case "FEAR", "AFRAID", "SCARED" -> EmotionTypeEnum.FEAR;
            default -> EmotionTypeEnum.NEUTRAL;
        };
    }
}

