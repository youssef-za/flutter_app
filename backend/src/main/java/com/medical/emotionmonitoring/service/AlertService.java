package com.medical.emotionmonitoring.service;

import com.medical.emotionmonitoring.entity.Alert;
import com.medical.emotionmonitoring.entity.Role;
import com.medical.emotionmonitoring.entity.User;
import com.medical.emotionmonitoring.repository.AlertRepository;
import com.medical.emotionmonitoring.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AlertService {

    private final AlertRepository alertRepository;
    private final UserRepository userRepository;

    @Transactional
    public Alert createAlert(Long patientId, String message) {
        User patient = userRepository.findById(patientId)
                .orElseThrow(() -> new RuntimeException("Patient not found"));

        // Find an available doctor (first doctor in the system)
        // In a real system, you might have a doctor-patient assignment table
        User doctor = findAvailableDoctor()
                .orElseThrow(() -> new RuntimeException(
                        "No doctor available in the system. Please create a doctor user first."));

        // Check if similar alert already exists (avoid duplicates)
        Alert alert = new Alert();
        alert.setMessage(message);
        alert.setPatient(patient);
        alert.setDoctor(doctor);
        alert.setIsRead(false);

        return alertRepository.save(alert);
    }

    /**
     * Find an available doctor
     * In a production system, this would use a doctor-patient assignment table
     */
    private Optional<User> findAvailableDoctor() {
        List<User> doctors = userRepository.findAll().stream()
                .filter(user -> user.getRole() == Role.DOCTOR)
                .toList();

        if (doctors.isEmpty()) {
            return Optional.empty();
        }

        // Return the first available doctor
        // In a real system, you might implement load balancing or assignment logic
        return Optional.of(doctors.get(0));
    }

    public List<Alert> getAlertsByDoctorId(Long doctorId) {
        return alertRepository.findByDoctorIdOrderByCreatedAtDesc(doctorId);
    }

    public List<Alert> getAlertsByPatientId(Long patientId) {
        return alertRepository.findByPatientIdOrderByCreatedAtDesc(patientId);
    }

    public List<Alert> getUnreadAlertsByDoctorId(Long doctorId) {
        return alertRepository.findUnreadAlertsByDoctorId(doctorId);
    }

    public void markAsRead(Long alertId) {
        Alert alert = alertRepository.findById(alertId)
                .orElseThrow(() -> new RuntimeException("Alert not found"));
        alert.setIsRead(true);
        alertRepository.save(alert);
    }
}

