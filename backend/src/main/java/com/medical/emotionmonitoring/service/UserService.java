package com.medical.emotionmonitoring.service;

import com.medical.emotionmonitoring.dto.RegisterRequest;
import com.medical.emotionmonitoring.dto.UserResponse;
import com.medical.emotionmonitoring.entity.Role;
import com.medical.emotionmonitoring.entity.User;
import com.medical.emotionmonitoring.repository.UserRepository;
import com.medical.emotionmonitoring.validation.PasswordValidator;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Transactional
    public UserResponse register(RegisterRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new RuntimeException("Email already exists");
        }

        // Validate password strength
        PasswordValidator.ValidationResult passwordValidation = PasswordValidator.validate(request.getPassword());
        if (!passwordValidation.isValid()) {
            throw new RuntimeException(passwordValidation.getMessage());
        }

        User user = new User();
        user.setFullName(request.getFullName());
        user.setEmail(request.getEmail());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setRole(request.getRole() != null ? request.getRole() : Role.PATIENT);

        User savedUser = userRepository.save(user);
        return mapToUserResponse(savedUser);
    }

    public UserResponse getUserById(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return mapToUserResponse(user);
    }

    public UserResponse getUserByEmail(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return mapToUserResponse(user);
    }

    public List<UserResponse> getAllUsers() {
        return userRepository.findAll().stream()
                .map(this::mapToUserResponse)
                .collect(Collectors.toList());
    }

    public List<UserResponse> getPatients() {
        return userRepository.findAll().stream()
                .filter(user -> user.getRole() == Role.PATIENT)
                .map(this::mapToUserResponse)
                .collect(Collectors.toList());
    }

    @Transactional
    public UserResponse updateUserProfile(String email, com.medical.emotionmonitoring.dto.UpdateProfileRequest request) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));

        // Check if email is being changed and if it's already taken
        if (!user.getEmail().equals(request.getEmail())) {
            if (userRepository.existsByEmail(request.getEmail())) {
                throw new RuntimeException("Email already exists");
            }
        }

        user.setFullName(request.getFullName());
        user.setEmail(request.getEmail());

        // Update patient profile fields
        if (user.getRole() == Role.PATIENT) {
            user.setAge(request.getAge());
            user.setGender(request.getGender());
            user.setProfilePicture(request.getProfilePicture());
        }

        // Update doctor profile fields
        if (user.getRole() == Role.DOCTOR) {
            user.setSpecialty(request.getSpecialty());
        }

        User updatedUser = userRepository.save(user);
        return mapToUserResponse(updatedUser);
    }

    @Transactional
    public void changePassword(String email, String currentPassword, String newPassword) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));

        // Verify current password
        if (!passwordEncoder.matches(currentPassword, user.getPassword())) {
            throw new RuntimeException("Current password is incorrect");
        }

        // Validate new password strength
        PasswordValidator.ValidationResult passwordValidation = PasswordValidator.validate(newPassword);
        if (!passwordValidation.isValid()) {
            throw new RuntimeException(passwordValidation.getMessage());
        }

        // Update password
        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
    }

    @Transactional
    public void assignPatientToDoctor(Long doctorId, Long patientId) {
        User doctor = userRepository.findById(doctorId)
                .orElseThrow(() -> new RuntimeException("Doctor not found"));
        
        if (doctor.getRole() != Role.DOCTOR) {
            throw new RuntimeException("User is not a doctor");
        }

        User patient = userRepository.findById(patientId)
                .orElseThrow(() -> new RuntimeException("Patient not found"));
        
        if (patient.getRole() != Role.PATIENT) {
            throw new RuntimeException("User is not a patient");
        }

        if (doctor.getAssignedPatients() == null) {
            doctor.setAssignedPatients(new java.util.ArrayList<>());
        }

        if (!doctor.getAssignedPatients().contains(patient)) {
            doctor.getAssignedPatients().add(patient);
            userRepository.save(doctor);
        }
    }

    @Transactional
    public void unassignPatientFromDoctor(Long doctorId, Long patientId) {
        User doctor = userRepository.findById(doctorId)
                .orElseThrow(() -> new RuntimeException("Doctor not found"));
        
        if (doctor.getRole() != Role.DOCTOR) {
            throw new RuntimeException("User is not a doctor");
        }

        if (doctor.getAssignedPatients() != null) {
            doctor.getAssignedPatients().removeIf(patient -> patient.getId().equals(patientId));
            userRepository.save(doctor);
        }
    }

    @Transactional
    public UserResponse updatePatientInfo(Long patientId, Long doctorId, 
                                         com.medical.emotionmonitoring.dto.UpdatePatientRequest request) {
        User patient = userRepository.findById(patientId)
                .orElseThrow(() -> new RuntimeException("Patient not found"));

        if (patient.getRole() != Role.PATIENT) {
            throw new RuntimeException("User is not a patient");
        }

        User doctor = userRepository.findById(doctorId)
                .orElseThrow(() -> new RuntimeException("Doctor not found"));

        if (doctor.getRole() != Role.DOCTOR) {
            throw new RuntimeException("User is not a doctor");
        }

        // Check if email is already taken by another user
        if (!patient.getEmail().equals(request.getEmail())) {
            userRepository.findByEmail(request.getEmail()).ifPresent(existingUser -> {
                if (!existingUser.getId().equals(patientId)) {
                    throw new RuntimeException("Email already exists");
                }
            });
        }

        patient.setFullName(request.getFullName());
        patient.setEmail(request.getEmail());
        
        if (request.getAge() != null) {
            patient.setAge(request.getAge());
        }
        
        if (request.getGender() != null) {
            // Convert String to Gender enum if needed
            try {
                patient.setGender(com.medical.emotionmonitoring.entity.Gender.valueOf(request.getGender()));
            } catch (IllegalArgumentException e) {
                throw new RuntimeException("Invalid gender value: " + request.getGender());
            }
        }

        User updatedPatient = userRepository.save(patient);
        return mapToUserResponse(updatedPatient);
    }

    private UserResponse mapToUserResponse(User user) {
        UserResponse response = new UserResponse();
        response.setId(user.getId());
        response.setFullName(user.getFullName());
        response.setEmail(user.getEmail());
        response.setRole(user.getRole());
        response.setCreatedAt(user.getCreatedAt());

        // Patient profile fields
        response.setAge(user.getAge());
        response.setGender(user.getGender());
        response.setProfilePicture(user.getProfilePicture());
        response.setLastConnectedDate(user.getLastConnectedDate());

        // Doctor profile fields
        response.setSpecialty(user.getSpecialty());
        if (user.getAssignedPatients() != null) {
            response.setAssignedPatientIds(
                    user.getAssignedPatients().stream()
                            .map(User::getId)
                            .collect(java.util.stream.Collectors.toList())
            );
            response.setAssignedPatientsCount(user.getAssignedPatients().size());
        } else {
            response.setAssignedPatientsCount(0);
        }

        return response;
    }
}

