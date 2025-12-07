package com.medical.emotionmonitoring.controller;

import com.medical.emotionmonitoring.dto.ErrorResponse;
import com.medical.emotionmonitoring.dto.PatientNoteRequest;
import com.medical.emotionmonitoring.dto.PatientNoteResponse;
import com.medical.emotionmonitoring.service.PatientNoteService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/patient-notes")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class PatientNoteController {

    private final PatientNoteService patientNoteService;
    private final com.medical.emotionmonitoring.repository.UserRepository userRepository;

    @PostMapping("/patient/{patientId}")
    public ResponseEntity<?> createNote(
            @PathVariable Long patientId,
            @Valid @RequestBody PatientNoteRequest request) {
        try {
            Long doctorId = getCurrentUserId();
            PatientNoteResponse response = patientNoteService.createNote(patientId, doctorId, request);
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new ErrorResponse(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ErrorResponse("An error occurred while creating note"));
        }
    }

    @GetMapping("/patient/{patientId}")
    public ResponseEntity<?> getNotesByPatientId(@PathVariable Long patientId) {
        try {
            Long currentUserId = getCurrentUserId();
            com.medical.emotionmonitoring.entity.Role currentUserRole = getCurrentUserRole();
            
            List<PatientNoteResponse> notes = patientNoteService.getNotesByPatientId(
                    patientId, currentUserId, currentUserRole);
            
            return ResponseEntity.ok(notes);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(new ErrorResponse(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ErrorResponse("An error occurred while fetching notes"));
        }
    }

    @GetMapping("/doctor/{doctorId}")
    public ResponseEntity<?> getNotesByDoctorId(@PathVariable Long doctorId) {
        try {
            Long currentUserId = getCurrentUserId();
            
            // Only doctors can view their own notes
            if (!doctorId.equals(currentUserId)) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body(new ErrorResponse("Unauthorized: You can only view your own notes"));
            }
            
            List<PatientNoteResponse> notes = patientNoteService.getNotesByDoctorId(doctorId);
            return ResponseEntity.ok(notes);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ErrorResponse("An error occurred while fetching notes"));
        }
    }

    @PutMapping("/{noteId}")
    public ResponseEntity<?> updateNote(
            @PathVariable Long noteId,
            @Valid @RequestBody PatientNoteRequest request) {
        try {
            Long doctorId = getCurrentUserId();
            PatientNoteResponse response = patientNoteService.updateNote(noteId, doctorId, request);
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new ErrorResponse(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ErrorResponse("An error occurred while updating note"));
        }
    }

    @DeleteMapping("/{noteId}")
    public ResponseEntity<?> deleteNote(@PathVariable Long noteId) {
        try {
            Long doctorId = getCurrentUserId();
            patientNoteService.deleteNote(noteId, doctorId);
            return ResponseEntity.ok(new java.util.HashMap<String, String>() {{
                put("message", "Note deleted successfully");
            }});
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new ErrorResponse(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ErrorResponse("An error occurred while deleting note"));
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

    private com.medical.emotionmonitoring.entity.Role getCurrentUserRole() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getPrincipal() instanceof org.springframework.security.core.userdetails.UserDetails) {
            String email = ((org.springframework.security.core.userdetails.UserDetails) authentication.getPrincipal()).getUsername();
            com.medical.emotionmonitoring.entity.User user = userRepository.findByEmail(email)
                    .orElseThrow(() -> new RuntimeException("User not found"));
            return user.getRole();
        }
        throw new RuntimeException("User not authenticated");
    }
}


