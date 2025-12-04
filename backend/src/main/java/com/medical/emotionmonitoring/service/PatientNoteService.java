package com.medical.emotionmonitoring.service;

import com.medical.emotionmonitoring.dto.PatientNoteRequest;
import com.medical.emotionmonitoring.dto.PatientNoteResponse;
import com.medical.emotionmonitoring.entity.PatientNote;
import com.medical.emotionmonitoring.entity.Role;
import com.medical.emotionmonitoring.entity.User;
import com.medical.emotionmonitoring.repository.PatientNoteRepository;
import com.medical.emotionmonitoring.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PatientNoteService {

    private final PatientNoteRepository patientNoteRepository;
    private final UserRepository userRepository;

    @Transactional
    public PatientNoteResponse createNote(Long patientId, Long doctorId, PatientNoteRequest request) {
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

        PatientNote note = new PatientNote();
        note.setPatient(patient);
        note.setDoctor(doctor);
        note.setNote(request.getNote());

        PatientNote savedNote = patientNoteRepository.save(note);
        return mapToResponse(savedNote);
    }

    public List<PatientNoteResponse> getNotesByPatientId(Long patientId, Long currentUserId, Role currentUserRole) {
        // Authorization: Patients can only view their own notes, Doctors can view any patient's notes
        if (currentUserRole == Role.PATIENT && !patientId.equals(currentUserId)) {
            throw new RuntimeException("Unauthorized: Patients can only view their own notes");
        }

        List<PatientNote> notes = patientNoteRepository.findByPatientIdOrderByCreatedAtDesc(patientId);
        return notes.stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    public List<PatientNoteResponse> getNotesByDoctorId(Long doctorId) {
        List<PatientNote> notes = patientNoteRepository.findByDoctorIdOrderByCreatedAtDesc(doctorId);
        return notes.stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    @Transactional
    public PatientNoteResponse updateNote(Long noteId, Long doctorId, PatientNoteRequest request) {
        PatientNote note = patientNoteRepository.findById(noteId)
                .orElseThrow(() -> new RuntimeException("Note not found"));

        // Only the doctor who created the note can update it
        if (!note.getDoctor().getId().equals(doctorId)) {
            throw new RuntimeException("Unauthorized: Only the doctor who created the note can update it");
        }

        note.setNote(request.getNote());
        PatientNote updatedNote = patientNoteRepository.save(note);
        return mapToResponse(updatedNote);
    }

    @Transactional
    public void deleteNote(Long noteId, Long doctorId) {
        PatientNote note = patientNoteRepository.findById(noteId)
                .orElseThrow(() -> new RuntimeException("Note not found"));

        // Only the doctor who created the note can delete it
        if (!note.getDoctor().getId().equals(doctorId)) {
            throw new RuntimeException("Unauthorized: Only the doctor who created the note can delete it");
        }

        patientNoteRepository.delete(note);
    }

    private PatientNoteResponse mapToResponse(PatientNote note) {
        PatientNoteResponse response = new PatientNoteResponse();
        response.setId(note.getId());
        response.setNote(note.getNote());
        response.setPatientId(note.getPatient().getId());
        response.setPatientName(note.getPatient().getFullName());
        response.setDoctorId(note.getDoctor().getId());
        response.setDoctorName(note.getDoctor().getFullName());
        response.setCreatedAt(note.getCreatedAt());
        response.setUpdatedAt(note.getUpdatedAt());
        return response;
    }
}

