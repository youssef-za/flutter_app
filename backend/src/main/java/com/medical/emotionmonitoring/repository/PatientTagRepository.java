package com.medical.emotionmonitoring.repository;

import com.medical.emotionmonitoring.entity.PatientTag;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PatientTagRepository extends JpaRepository<PatientTag, Long> {
    List<PatientTag> findByPatientId(Long patientId);
    List<PatientTag> findByPatientIdAndDoctorId(Long patientId, Long doctorId);
    Optional<PatientTag> findByPatientIdAndDoctorIdAndTag(Long patientId, Long doctorId, String tag);
    void deleteByPatientIdAndDoctorIdAndTag(Long patientId, Long doctorId, String tag);
}

