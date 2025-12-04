package com.medical.emotionmonitoring.repository;

import com.medical.emotionmonitoring.entity.PatientNote;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PatientNoteRepository extends JpaRepository<PatientNote, Long> {
    List<PatientNote> findByPatientIdOrderByCreatedAtDesc(Long patientId);
    List<PatientNote> findByDoctorIdOrderByCreatedAtDesc(Long doctorId);
    List<PatientNote> findByPatientIdAndDoctorIdOrderByCreatedAtDesc(Long patientId, Long doctorId);
}

