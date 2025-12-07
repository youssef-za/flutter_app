# 📊 Database Schema Documentation

## Overview

This document describes the complete database schema for the Medical Emotion Monitoring System, including all tables, relationships, indexes, and constraints.

---

## 🗄️ Entity Relationship Diagram (Text Description)

```
┌─────────────┐         ┌──────────────┐
│    User     │─────────│   Emotion    │
│             │ 1:N     │              │
└─────────────┘         └──────────────┘
     │
     │ N:M
     │
┌─────────────┐
│DoctorPatient│
│ Assignment  │
└─────────────┘
     │
     │
┌─────────────┐         ┌──────────────┐
│   Doctor    │─────────│ PatientNote   │
│  (User)     │ 1:N     │              │
└─────────────┘         └──────────────┘
     │
     │ 1:N
     │
┌─────────────┐
│ PatientTag  │
└─────────────┘

┌─────────────┐
│    Alert    │
└─────────────┘

┌─────────────┐
│LoginAttempt │
└─────────────┘
```

---

## 📋 Tables

### 1. `users`

**Description**: Stores all users (both patients and doctors)

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | BIGINT | PRIMARY KEY, AUTO_INCREMENT | Unique user identifier |
| `full_name` | VARCHAR(100) | NOT NULL | User's full name |
| `email` | VARCHAR(255) | NOT NULL, UNIQUE | User's email address |
| `password` | VARCHAR(255) | NOT NULL | Hashed password (BCrypt) |
| `role` | ENUM('PATIENT', 'DOCTOR') | NOT NULL | User role |
| `is_account_non_locked` | BOOLEAN | DEFAULT TRUE | Account lock status |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Account creation date |
| `updated_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP ON UPDATE | Last update timestamp |

**Indexes**:
- PRIMARY KEY (`id`)
- UNIQUE INDEX (`email`)
- INDEX (`role`)

**Relationships**:
- One-to-Many with `emotions` (as patient)
- Many-to-Many with `users` (doctor-patient assignments)
- One-to-Many with `patient_notes` (as doctor)
- One-to-Many with `patient_tags` (as doctor)
- One-to-Many with `alerts` (as patient)

---

### 2. `emotions`

**Description**: Stores emotion detection records

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | BIGINT | PRIMARY KEY, AUTO_INCREMENT | Unique emotion identifier |
| `patient_id` | BIGINT | NOT NULL, FOREIGN KEY | Reference to patient user |
| `emotion_type` | ENUM('HAPPY', 'SAD', 'ANGRY', 'FEAR', 'SURPRISE', 'NEUTRAL') | NOT NULL | Detected emotion type |
| `confidence` | DECIMAL(5,2) | NOT NULL | Detection confidence (0-100) |
| `timestamp` | TIMESTAMP | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Detection timestamp |
| `image_url` | VARCHAR(1000) | NULL | URL to captured image (if stored) |
| `notes` | TEXT | NULL | Additional notes |

**Indexes**:
- PRIMARY KEY (`id`)
- INDEX (`patient_id`)
- INDEX (`timestamp`)
- INDEX (`emotion_type`)
- COMPOSITE INDEX (`patient_id`, `timestamp`)

**Relationships**:
- Many-to-One with `users` (patient)

**Foreign Keys**:
- `patient_id` → `users.id` (ON DELETE CASCADE)

---

### 3. `doctor_patient_assignments`

**Description**: Junction table for doctor-patient relationships

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `doctor_id` | BIGINT | NOT NULL, FOREIGN KEY | Reference to doctor user |
| `patient_id` | BIGINT | NOT NULL, FOREIGN KEY | Reference to patient user |
| `assigned_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Assignment date |
| `is_active` | BOOLEAN | DEFAULT TRUE | Active assignment status |

**Indexes**:
- PRIMARY KEY (`doctor_id`, `patient_id`)
- INDEX (`doctor_id`)
- INDEX (`patient_id`)

**Relationships**:
- Many-to-One with `users` (doctor)
- Many-to-One with `users` (patient)

**Foreign Keys**:
- `doctor_id` → `users.id` (ON DELETE CASCADE)
- `patient_id` → `users.id` (ON DELETE CASCADE)

---

### 4. `patient_notes`

**Description**: Doctor's notes for patients

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | BIGINT | PRIMARY KEY, AUTO_INCREMENT | Unique note identifier |
| `patient_id` | BIGINT | NOT NULL, FOREIGN KEY | Reference to patient user |
| `doctor_id` | BIGINT | NOT NULL, FOREIGN KEY | Reference to doctor user |
| `note` | TEXT | NOT NULL | Note content |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |
| `updated_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP ON UPDATE | Last update timestamp |

**Indexes**:
- PRIMARY KEY (`id`)
- INDEX (`patient_id`)
- INDEX (`doctor_id`)
- INDEX (`created_at`)

**Relationships**:
- Many-to-One with `users` (patient)
- Many-to-One with `users` (doctor)

**Foreign Keys**:
- `patient_id` → `users.id` (ON DELETE CASCADE)
- `doctor_id` → `users.id` (ON DELETE CASCADE)

---

### 5. `patient_tags`

**Description**: Tags for organizing patients (e.g., "urgent", "follow-up")

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | BIGINT | PRIMARY KEY, AUTO_INCREMENT | Unique tag identifier |
| `patient_id` | BIGINT | NOT NULL, FOREIGN KEY | Reference to patient user |
| `doctor_id` | BIGINT | NOT NULL, FOREIGN KEY | Reference to doctor user |
| `tag_type` | VARCHAR(50) | NOT NULL | Tag type (e.g., "URGENT", "STABLE") |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |

**Indexes**:
- PRIMARY KEY (`id`)
- INDEX (`patient_id`)
- INDEX (`doctor_id`)
- INDEX (`tag_type`)

**Relationships**:
- Many-to-One with `users` (patient)
- Many-to-One with `users` (doctor)

**Foreign Keys**:
- `patient_id` → `users.id` (ON DELETE CASCADE)
- `doctor_id` → `users.id` (ON DELETE CASCADE)

---

### 6. `alerts`

**Description**: System alerts for critical emotions or events

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | BIGINT | PRIMARY KEY, AUTO_INCREMENT | Unique alert identifier |
| `patient_id` | BIGINT | NOT NULL, FOREIGN KEY | Reference to patient user |
| `alert_type` | VARCHAR(50) | NOT NULL | Alert type |
| `message` | TEXT | NOT NULL | Alert message |
| `severity` | ENUM('LOW', 'MEDIUM', 'HIGH', 'CRITICAL') | NOT NULL | Alert severity |
| `is_read` | BOOLEAN | DEFAULT FALSE | Read status |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |

**Indexes**:
- PRIMARY KEY (`id`)
- INDEX (`patient_id`)
- INDEX (`is_read`)
- INDEX (`severity`)
- INDEX (`created_at`)

**Relationships**:
- Many-to-One with `users` (patient)

**Foreign Keys**:
- `patient_id` → `users.id` (ON DELETE CASCADE)

---

### 7. `login_attempts`

**Description**: Tracks failed login attempts for security

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | BIGINT | PRIMARY KEY, AUTO_INCREMENT | Unique attempt identifier |
| `email` | VARCHAR(255) | NOT NULL | Email address attempted |
| `attempt_count` | INT | DEFAULT 0 | Number of failed attempts |
| `last_attempt_time` | TIMESTAMP | NULL | Last attempt timestamp |
| `is_locked` | BOOLEAN | DEFAULT FALSE | Lock status |
| `locked_until` | TIMESTAMP | NULL | Lock expiration time |

**Indexes**:
- PRIMARY KEY (`id`)
- INDEX (`email`)
- INDEX (`is_locked`)
- INDEX (`last_attempt_time`)

---

## 🔗 Relationships Summary

### One-to-Many Relationships
- **User → Emotions**: One user (patient) can have many emotions
- **User (Doctor) → Patient Notes**: One doctor can have many notes
- **User (Doctor) → Patient Tags**: One doctor can tag many patients
- **User (Patient) → Alerts**: One patient can have many alerts

### Many-to-Many Relationships
- **User (Doctor) ↔ User (Patient)**: Doctors can be assigned to multiple patients, patients can have multiple doctors (via `doctor_patient_assignments`)

---

## 📈 Indexes Strategy

### Performance Indexes
- **User email**: Unique index for fast login lookups
- **Emotion patient_id + timestamp**: Composite index for patient history queries
- **Alert patient_id + is_read**: Composite index for unread alerts
- **Login attempts email**: Index for security checks

### Query Optimization
- All foreign keys are indexed
- Frequently queried columns are indexed
- Composite indexes for common query patterns

---

## 🔒 Constraints

### Primary Keys
- All tables have `id` as PRIMARY KEY (BIGINT, AUTO_INCREMENT)

### Foreign Keys
- All foreign keys have ON DELETE CASCADE
- Ensures referential integrity

### Unique Constraints
- `users.email` - Unique email addresses
- `doctor_patient_assignments(doctor_id, patient_id)` - Unique assignments

### Check Constraints
- `emotions.confidence` - Between 0 and 100
- `users.role` - Only 'PATIENT' or 'DOCTOR'

---

## 📊 Data Types

### Common Types
- **BIGINT**: For IDs (allows for large scale)
- **VARCHAR**: For variable-length strings
- **TEXT**: For long text content
- **TIMESTAMP**: For date/time (with timezone support)
- **BOOLEAN**: For true/false values
- **DECIMAL**: For precise numeric values (confidence scores)
- **ENUM**: For fixed value sets (roles, emotion types)

---

## 🔄 Future Schema Additions

### Planned Tables
- `refresh_tokens` - For refresh token system
- `fcm_tokens` - For push notifications
- `notifications` - Notification history
- `conversations` - For messaging system
- `messages` - For doctor-patient messages
- `video_calls` - For telemedicine
- `appointments` - For scheduling
- `emotion_insights` - For weekly/monthly insights
- `emotion_predictions` - For AI predictions
- `risk_assessments` - For risk scoring

---

## 📝 Migration Notes

### Current State
- Using `hibernate.ddl-auto=update` (development)
- **MUST** migrate to Flyway/Liquibase for production

### Migration Strategy
1. Create initial migration with all current tables
2. Add indexes in separate migrations
3. Add new tables as needed
4. Use `validate` mode in production

---

## 🔍 Query Examples

### Get Patient Emotions (Last 7 Days)
```sql
SELECT * FROM emotions
WHERE patient_id = ?
  AND timestamp >= DATE_SUB(NOW(), INTERVAL 7 DAY)
ORDER BY timestamp DESC;
```

### Get Unread Alerts for Doctor's Patients
```sql
SELECT a.* FROM alerts a
JOIN doctor_patient_assignments dpa ON a.patient_id = dpa.patient_id
WHERE dpa.doctor_id = ?
  AND a.is_read = FALSE
ORDER BY a.created_at DESC;
```

### Get Patient Statistics
```sql
SELECT 
  emotion_type,
  COUNT(*) as count,
  AVG(confidence) as avg_confidence
FROM emotions
WHERE patient_id = ?
GROUP BY emotion_type;
```

---

**Last Updated**: 2024
**Version**: 1.0.0
**Database**: MySQL 8.0


