package com.medical.emotionmonitoring.repository;

import com.medical.emotionmonitoring.entity.Alert;
import com.medical.emotionmonitoring.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface AlertRepository extends JpaRepository<Alert, Long> {
    
    List<Alert> findByDoctor(User doctor);
    
    List<Alert> findByPatient(User patient);
    
    List<Alert> findByDoctorId(Long doctorId);
    
    List<Alert> findByPatientId(Long patientId);
    
    List<Alert> findByDoctorIdOrderByCreatedAtDesc(Long doctorId);
    
    List<Alert> findByPatientIdOrderByCreatedAtDesc(Long patientId);
    
    List<Alert> findByDoctorIdAndIsReadFalse(Long doctorId);
    
    List<Alert> findByPatientIdAndIsReadFalse(Long patientId);
    
    @Query("SELECT a FROM Alert a WHERE a.doctor.id = :doctorId AND a.isRead = false ORDER BY a.createdAt DESC")
    List<Alert> findUnreadAlertsByDoctorId(@Param("doctorId") Long doctorId);
    
    @Query("SELECT a FROM Alert a WHERE a.patient.id = :patientId AND a.isRead = false ORDER BY a.createdAt DESC")
    List<Alert> findUnreadAlertsByPatientId(@Param("patientId") Long patientId);
    
    @Query("SELECT a FROM Alert a WHERE a.doctor.id = :doctorId AND a.createdAt BETWEEN :startDate AND :endDate ORDER BY a.createdAt DESC")
    List<Alert> findByDoctorIdAndDateRange(
        @Param("doctorId") Long doctorId,
        @Param("startDate") LocalDateTime startDate,
        @Param("endDate") LocalDateTime endDate
    );
    
    @Query("SELECT a FROM Alert a WHERE a.patient.id = :patientId AND a.createdAt BETWEEN :startDate AND :endDate ORDER BY a.createdAt DESC")
    List<Alert> findByPatientIdAndDateRange(
        @Param("patientId") Long patientId,
        @Param("startDate") LocalDateTime startDate,
        @Param("endDate") LocalDateTime endDate
    );
    
    @Query("SELECT COUNT(a) FROM Alert a WHERE a.doctor.id = :doctorId AND a.isRead = false")
    Long countUnreadAlertsByDoctorId(@Param("doctorId") Long doctorId);
    
    @Query("SELECT COUNT(a) FROM Alert a WHERE a.patient.id = :patientId AND a.isRead = false")
    Long countUnreadAlertsByPatientId(@Param("patientId") Long patientId);
}

