package com.medical.emotionmonitoring.controller;

import com.medical.emotionmonitoring.dto.ErrorResponse;
import com.medical.emotionmonitoring.dto.PatientTagRequest;
import com.medical.emotionmonitoring.dto.PatientTagResponse;
import com.medical.emotionmonitoring.service.PatientTagService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/patient-tags")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class PatientTagController {

    private final PatientTagService patientTagService;
    private final com.medical.emotionmonitoring.repository.UserRepository userRepository;

    @PostMapping("/patient/{patientId}")
    public ResponseEntity<?> addTag(
            @PathVariable Long patientId,
            @Valid @RequestBody PatientTagRequest request) {
        try {
            Long doctorId = getCurrentUserId();
            PatientTagResponse response = patientTagService.addTag(patientId, doctorId, request);
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new ErrorResponse(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ErrorResponse("An error occurred while adding tag"));
        }
    }

    @GetMapping("/patient/{patientId}")
    public ResponseEntity<?> getTagsByPatientId(@PathVariable Long patientId) {
        try {
            List<PatientTagResponse> tags = patientTagService.getTagsByPatientId(patientId);
            return ResponseEntity.ok(tags);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ErrorResponse("An error occurred while fetching tags"));
        }
    }

    @GetMapping("/patient/{patientId}/doctor/{doctorId}")
    public ResponseEntity<?> getTagsByPatientIdAndDoctorId(
            @PathVariable Long patientId,
            @PathVariable Long doctorId) {
        try {
            Long currentUserId = getCurrentUserId();
            
            // Only doctors can view tags, and only their own tags
            if (!doctorId.equals(currentUserId)) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body(new ErrorResponse("Unauthorized: You can only view your own tags"));
            }
            
            List<PatientTagResponse> tags = patientTagService.getTagsByPatientIdAndDoctorId(patientId, doctorId);
            return ResponseEntity.ok(tags);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ErrorResponse("An error occurred while fetching tags"));
        }
    }

    @DeleteMapping("/patient/{patientId}/tag/{tag}")
    public ResponseEntity<?> removeTag(
            @PathVariable Long patientId,
            @PathVariable String tag) {
        try {
            Long doctorId = getCurrentUserId();
            patientTagService.removeTag(patientId, doctorId, tag);
            return ResponseEntity.ok(new java.util.HashMap<String, String>() {{
                put("message", "Tag removed successfully");
            }});
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new ErrorResponse(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ErrorResponse("An error occurred while removing tag"));
        }
    }

    @DeleteMapping("/{tagId}")
    public ResponseEntity<?> removeTagById(@PathVariable Long tagId) {
        try {
            Long doctorId = getCurrentUserId();
            patientTagService.removeTagById(tagId, doctorId);
            return ResponseEntity.ok(new java.util.HashMap<String, String>() {{
                put("message", "Tag removed successfully");
            }});
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new ErrorResponse(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ErrorResponse("An error occurred while removing tag"));
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
}


