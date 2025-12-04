package com.medical.emotionmonitoring.dto;

import com.medical.emotionmonitoring.entity.Gender;
import com.medical.emotionmonitoring.entity.Role;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserResponse {
    private Long id;
    private String fullName;
    private String email;
    private Role role;
    private LocalDateTime createdAt;
    
    // Patient profile fields
    private Integer age;
    private Gender gender;
    private String profilePicture;
    private LocalDateTime lastConnectedDate;
    
    // Doctor profile fields
    private String specialty;
    private List<Long> assignedPatientIds; // List of patient IDs assigned to this doctor
    private Integer assignedPatientsCount; // Count of assigned patients
}

