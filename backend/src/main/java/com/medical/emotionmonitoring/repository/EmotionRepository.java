package com.medical.emotionmonitoring.repository;

import com.medical.emotionmonitoring.entity.Emotion;
import com.medical.emotionmonitoring.entity.EmotionTypeEnum;
import com.medical.emotionmonitoring.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface EmotionRepository extends JpaRepository<Emotion, Long> {
    
    List<Emotion> findByPatient(User patient);
    
    List<Emotion> findByPatientId(Long patientId);
    
    List<Emotion> findByPatientIdOrderByTimestampDesc(Long patientId);
    
    List<Emotion> findByPatientIdAndEmotionType(Long patientId, EmotionTypeEnum emotionType);
    
    @Query("SELECT e FROM Emotion e WHERE e.patient.id = :patientId AND e.timestamp BETWEEN :startDate AND :endDate ORDER BY e.timestamp DESC")
    List<Emotion> findByPatientIdAndDateRange(
        @Param("patientId") Long patientId,
        @Param("startDate") LocalDateTime startDate,
        @Param("endDate") LocalDateTime endDate
    );
    
    @Query("SELECT COUNT(e) FROM Emotion e WHERE e.patient.id = :patientId AND e.emotionType = :emotionType")
    Long countByPatientIdAndEmotionType(@Param("patientId") Long patientId, @Param("emotionType") EmotionTypeEnum emotionType);
    
    @Query("SELECT e FROM Emotion e WHERE e.patient.id = :patientId ORDER BY e.confidence DESC")
    List<Emotion> findByPatientIdOrderByConfidenceDesc(Long patientId);
}

