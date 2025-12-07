package com.medical.emotionmonitoring.service;

import com.medical.emotionmonitoring.dto.PatientTagRequest;
import com.medical.emotionmonitoring.dto.PatientTagResponse;
import com.medical.emotionmonitoring.entity.PatientTag;
import com.medical.emotionmonitoring.entity.Role;
import com.medical.emotionmonitoring.entity.User;
import com.medical.emotionmonitoring.repository.PatientTagRepository;
import com.medical.emotionmonitoring.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PatientTagService {

    private final PatientTagRepository patientTagRepository;
    private final UserRepository userRepository;

    @Transactional
    public PatientTagResponse addTag(Long patientId, Long doctorId, PatientTagRequest request) {
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

        // Check if tag already exists
        patientTagRepository.findByPatientIdAndDoctorIdAndTag(patientId, doctorId, request.getTag())
                .ifPresent(tag -> {
                    throw new RuntimeException("Tag already exists for this patient");
                });

        PatientTag tag = new PatientTag();
        tag.setPatient(patient);
        tag.setDoctor(doctor);
        tag.setTag(request.getTag());

        PatientTag savedTag = patientTagRepository.save(tag);
        return mapToResponse(savedTag);
    }

    public List<PatientTagResponse> getTagsByPatientId(Long patientId) {
        List<PatientTag> tags = patientTagRepository.findByPatientId(patientId);
        return tags.stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    public List<PatientTagResponse> getTagsByPatientIdAndDoctorId(Long patientId, Long doctorId) {
        List<PatientTag> tags = patientTagRepository.findByPatientIdAndDoctorId(patientId, doctorId);
        return tags.stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    @Transactional
    public void removeTag(Long patientId, Long doctorId, String tag) {
        PatientTag patientTag = patientTagRepository
                .findByPatientIdAndDoctorIdAndTag(patientId, doctorId, tag)
                .orElseThrow(() -> new RuntimeException("Tag not found"));

        // Only the doctor who created the tag can remove it
        if (!patientTag.getDoctor().getId().equals(doctorId)) {
            throw new RuntimeException("Unauthorized: Only the doctor who created the tag can remove it");
        }

        patientTagRepository.delete(patientTag);
    }

    @Transactional
    public void removeTagById(Long tagId, Long doctorId) {
        PatientTag tag = patientTagRepository.findById(tagId)
                .orElseThrow(() -> new RuntimeException("Tag not found"));

        // Only the doctor who created the tag can remove it
        if (!tag.getDoctor().getId().equals(doctorId)) {
            throw new RuntimeException("Unauthorized: Only the doctor who created the tag can remove it");
        }

        patientTagRepository.delete(tag);
    }

    private PatientTagResponse mapToResponse(PatientTag tag) {
        PatientTagResponse response = new PatientTagResponse();
        response.setId(tag.getId());
        response.setTag(tag.getTag());
        response.setPatientId(tag.getPatient().getId());
        response.setPatientName(tag.getPatient().getFullName());
        response.setDoctorId(tag.getDoctor().getId());
        response.setDoctorName(tag.getDoctor().getFullName());
        response.setCreatedAt(tag.getCreatedAt());
        response.setUpdatedAt(tag.getUpdatedAt());
        return response;
    }
}


