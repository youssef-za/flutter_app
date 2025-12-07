# 📋 Step-by-Step Implementation Plan
## Medical Emotion Monitoring System - Detailed Roadmap

**Project Duration**: 16 weeks (4 months)  
**Team Structure**: 2-3 developers  
**Sprint Duration**: 2 weeks  
**Total Sprints**: 8 sprints

---

## 📊 Project Phases Overview

| Phase | Duration | Focus | Priority |
|-------|----------|-------|----------|
| **Phase 1: Critical Fixes** | Weeks 1-4 | Security, Stability, Testing | 🔴 CRITICAL |
| **Phase 2: UI/UX Polish** | Weeks 5-6 | Design, Navigation, Onboarding | 🟠 HIGH |
| **Phase 3: New Features** | Weeks 7-10 | Push Notifications, Offline Mode | 🟡 HIGH |
| **Phase 4: Optimization** | Weeks 11-12 | Performance, Scalability | 🟢 MEDIUM |
| **Phase 5: Release Prep** | Weeks 13-16 | Compliance, Store Preparation | 🔴 CRITICAL |

---

## 🚨 PHASE 1: CRITICAL FIXES
**Duration**: 4 weeks (Sprints 1-2)  
**Goal**: Make the application production-ready from a security and stability perspective

### Sprint 1: Security & Error Handling (Weeks 1-2)

#### Task 1.1: Global Exception Handler
**Description**: Implement centralized error handling with consistent error responses  
**Estimated Time**: 8 hours  
**Priority**: 🔴 CRITICAL

**Files to Modify**:
- `backend/src/main/java/com/medical/emotionmonitoring/exception/GlobalExceptionHandler.java` (NEW)
- `backend/src/main/java/com/medical/emotionmonitoring/dto/ErrorResponse.java` (UPDATE)
- All controller classes (UPDATE - remove individual exception handling)

**New Classes/Services**:
- `GlobalExceptionHandler.java` - `@ControllerAdvice` class
- `ValidationException.java` - Custom exception
- `EntityNotFoundException.java` - Custom exception
- `ErrorResponse.java` - Enhanced DTO

**APIs to Add/Update**:
- All existing APIs will return consistent error format
- Error response structure:
  ```json
  {
    "timestamp": "2024-01-01T00:00:00Z",
    "status": 400,
    "error": "Bad Request",
    "message": "Validation failed",
    "path": "/api/emotions",
    "traceId": "abc123",
    "details": {}
  }
  ```

**Testing Plan**:
- Unit tests for exception handler
- Integration tests for error responses
- Test all error scenarios (400, 401, 403, 404, 500)

---

#### Task 1.2: Database Migrations (Flyway)
**Description**: Replace `ddl-auto=update` with Flyway migrations  
**Estimated Time**: 12 hours  
**Priority**: 🔴 CRITICAL

**Files to Modify**:
- `backend/pom.xml` (ADD Flyway dependency)
- `backend/src/main/resources/application.properties` (UPDATE)
- `backend/src/main/resources/db/migration/` (NEW directory)
- All entity classes (ADD explicit indexes)

**New Classes/Services**:
- Migration scripts:
  - `V1__Initial_schema.sql`
  - `V2__Add_indexes.sql`
  - `V3__Add_audit_logs.sql`

**APIs to Add/Update**: None

**Database Changes**:
- Create migration scripts for all existing tables
- Add indexes explicitly
- Add audit logging table

**Testing Plan**:
- Test migration on clean database
- Test rollback scenarios
- Test migration on existing database

---

#### Task 1.3: Security Headers & HTTPS
**Description**: Add security headers and enforce HTTPS  
**Estimated Time**: 6 hours  
**Priority**: 🔴 CRITICAL

**Files to Modify**:
- `backend/src/main/java/com/medical/emotionmonitoring/config/SecurityHeadersConfig.java` (NEW)
- `backend/src/main/resources/application.properties` (UPDATE)
- `backend/src/main/resources/application-prod.properties` (UPDATE)

**New Classes/Services**:
- `SecurityHeadersConfig.java` - Security headers configuration

**APIs to Add/Update**: None (infrastructure change)

**Testing Plan**:
- Verify all security headers are present
- Test HTTPS enforcement
- Security scan

---

#### Task 1.4: API Rate Limiting
**Description**: Implement rate limiting to prevent abuse  
**Estimated Time**: 10 hours  
**Priority**: 🔴 CRITICAL

**Files to Modify**:
- `backend/pom.xml` (ADD Bucket4j dependency)
- `backend/src/main/java/com/medical/emotionmonitoring/config/RateLimitConfig.java` (NEW)
- `backend/src/main/java/com/medical/emotionmonitoring/filter/RateLimitFilter.java` (NEW)
- `backend/src/main/resources/application.properties` (UPDATE)

**New Classes/Services**:
- `RateLimitConfig.java` - Rate limiting configuration
- `RateLimitFilter.java` - Rate limiting filter

**APIs to Add/Update**:
- All APIs will have rate limiting
- Rate limits:
  - Login: 5 requests/minute
  - Emotion detection: 10 requests/minute
  - General API: 100 requests/minute

**Testing Plan**:
- Test rate limiting triggers
- Test rate limit reset
- Load testing

---

#### Task 1.5: Password Reset Flow
**Description**: Implement password reset functionality  
**Estimated Time**: 16 hours  
**Priority**: 🔴 CRITICAL

**Files to Modify**:
- `backend/src/main/java/com/medical/emotionmonitoring/controller/AuthController.java` (UPDATE)
- `backend/src/main/java/com/medical/emotionmonitoring/service/AuthService.java` (UPDATE)
- `backend/src/main/java/com/medical/emotionmonitoring/entity/PasswordResetToken.java` (NEW)
- `backend/src/main/java/com/medical/emotionmonitoring/repository/PasswordResetTokenRepository.java` (NEW)
- `frontend/lib/screens/auth/forgot_password_screen.dart` (NEW)
- `frontend/lib/screens/auth/reset_password_screen.dart` (NEW)

**New Classes/Services**:
- `PasswordResetToken.java` - Entity
- `PasswordResetTokenRepository.java` - Repository
- Email service (or use existing if available)

**APIs to Add/Update**:
- `POST /api/auth/forgot-password` - Request password reset
- `POST /api/auth/reset-password` - Reset password with token
- `POST /api/auth/validate-reset-token` - Validate reset token

**Database Changes**:
```sql
CREATE TABLE password_reset_tokens (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    token VARCHAR(255) NOT NULL UNIQUE,
    expires_at TIMESTAMP NOT NULL,
    used BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    INDEX idx_token (token),
    INDEX idx_user (user_id)
);
```

**Testing Plan**:
- Test password reset flow
- Test token expiration
- Test token reuse prevention

---

### Sprint 2: Testing & Database Optimization (Weeks 3-4)

#### Task 1.6: Comprehensive Test Suite
**Description**: Add unit and integration tests  
**Estimated Time**: 24 hours  
**Priority**: 🔴 CRITICAL

**Files to Modify**:
- `backend/src/test/java/com/medical/emotionmonitoring/` (NEW - multiple test files)
- `frontend/test/` (UPDATE - add more tests)
- `backend/pom.xml` (UPDATE - test dependencies)
- `frontend/pubspec.yaml` (UPDATE - test dependencies)

**New Classes/Services**:
- Service layer tests (80%+ coverage)
- Repository tests
- Controller integration tests
- Frontend widget tests
- Frontend integration tests

**APIs to Add/Update**: None

**Testing Plan**:
- Achieve 80%+ code coverage
- Test all critical paths
- Integration test suite
- E2E test scenarios

---

#### Task 1.7: Database Indexing
**Description**: Add explicit indexes for performance  
**Estimated Time**: 8 hours  
**Priority**: 🟠 HIGH

**Files to Modify**:
- All entity classes (ADD `@Index` annotations)
- Migration script `V2__Add_indexes.sql` (UPDATE)

**New Classes/Services**: None

**APIs to Add/Update**: None

**Database Changes**:
```sql
-- Composite indexes
CREATE INDEX idx_emotion_patient_timestamp ON emotions(user_id, timestamp DESC);
CREATE INDEX idx_alert_patient_unread ON alerts(patient_id, is_read, created_at DESC);
CREATE INDEX idx_note_patient_doctor ON patient_notes(patient_id, doctor_id, created_at DESC);
CREATE INDEX idx_login_attempt_email_time ON login_attempts(email, last_attempt_time);
```

**Testing Plan**:
- Query performance testing
- Index usage verification
- Slow query analysis

---

#### Task 1.8: API Pagination
**Description**: Add pagination to all list endpoints  
**Estimated Time**: 16 hours  
**Priority**: 🟠 HIGH

**Files to Modify**:
- `backend/src/main/java/com/medical/emotionmonitoring/controller/EmotionController.java` (UPDATE)
- `backend/src/main/java/com/medical/emotionmonitoring/controller/UserController.java` (UPDATE)
- `backend/src/main/java/com/medical/emotionmonitoring/controller/AlertController.java` (UPDATE)
- `backend/src/main/java/com/medical/emotionmonitoring/service/EmotionService.java` (UPDATE)
- `frontend/lib/providers/emotion_provider.dart` (UPDATE)
- `frontend/lib/providers/patient_provider.dart` (UPDATE)

**New Classes/Services**:
- `PageResponse.java` - Generic pagination DTO

**APIs to Add/Update**:
- `GET /api/emotions?page=0&size=20` - Paginated emotions
- `GET /api/users/patients?page=0&size=20` - Paginated patients
- `GET /api/alerts?page=0&size=20` - Paginated alerts

**Response Format**:
```json
{
  "content": [...],
  "page": 0,
  "size": 20,
  "totalElements": 100,
  "totalPages": 5,
  "first": true,
  "last": false
}
```

**Testing Plan**:
- Test pagination with various page sizes
- Test edge cases (empty results, last page)
- Frontend pagination UI testing

---

#### Task 1.9: Strong JWT Secret & Token Management
**Description**: Improve JWT security and add token management  
**Estimated Time**: 8 hours  
**Priority**: 🔴 CRITICAL

**Files to Modify**:
- `backend/src/main/resources/application.properties` (UPDATE)
- `backend/src/main/java/com/medical/emotionmonitoring/service/JwtService.java` (UPDATE)
- `backend/src/main/java/com/medical/emotionmonitoring/security/JwtAuthenticationFilter.java` (UPDATE)

**New Classes/Services**: None

**APIs to Add/Update**: None

**Testing Plan**:
- Test JWT generation and validation
- Test token expiration
- Security testing

---

### Phase 1 Milestones

**Milestone 1.1**: Security Hardened (End of Week 2)
- ✅ Global exception handler implemented
- ✅ Security headers configured
- ✅ Rate limiting active
- ✅ Password reset functional

**Milestone 1.2**: Production Ready (End of Week 4)
- ✅ Database migrations in place
- ✅ Test suite with 80%+ coverage
- ✅ API pagination implemented
- ✅ Database indexes optimized

---

## 🎨 PHASE 2: UI/UX POLISH
**Duration**: 2 weeks (Sprint 3)  
**Goal**: Improve user experience and visual design

### Sprint 3: Design System & Navigation (Weeks 5-6)

#### Task 2.1: Medical Design System
**Description**: Create comprehensive design system  
**Estimated Time**: 16 hours  
**Priority**: 🟠 HIGH

**Files to Modify**:
- `frontend/lib/config/app_theme.dart` (UPDATE)
- `frontend/lib/widgets/` (UPDATE - all widgets)
- `frontend/lib/config/design_tokens.dart` (NEW)

**New Classes/Services**:
- `DesignTokens.dart` - Design system constants
- Updated theme with medical color palette
- Component library documentation

**APIs to Add/Update**: None

**Testing Plan**:
- Visual regression testing
- Design system documentation
- Component testing

---

#### Task 2.2: Improved Navigation
**Description**: Enhance navigation structure and deep linking  
**Estimated Time**: 12 hours  
**Priority**: 🟠 HIGH

**Files to Modify**:
- `frontend/lib/config/app_routes.dart` (UPDATE)
- `frontend/lib/services/navigation_service.dart` (UPDATE)
- `frontend/lib/screens/home/home_screen.dart` (UPDATE)
- All screen files (UPDATE - add deep linking)

**New Classes/Services**:
- Deep linking handler
- Navigation state manager
- Breadcrumb component

**APIs to Add/Update**: None

**Testing Plan**:
- Deep linking testing
- Navigation flow testing
- Back button handling

---

#### Task 2.3: Comprehensive Onboarding
**Description**: Create onboarding flow for new users  
**Estimated Time**: 20 hours  
**Priority**: 🟠 HIGH

**Files to Modify**:
- `frontend/lib/screens/onboarding/` (NEW directory)
- `frontend/lib/providers/onboarding_provider.dart` (NEW)
- `frontend/lib/main.dart` (UPDATE)

**New Classes/Services**:
- `WelcomeScreen.dart`
- `FeatureHighlightScreen.dart`
- `PermissionRequestScreen.dart`
- `ProfileSetupScreen.dart`
- `TutorialScreen.dart`
- `OnboardingProvider.dart`

**APIs to Add/Update**:
- `PUT /api/users/onboarding-complete` - Mark onboarding complete

**Database Changes**:
```sql
ALTER TABLE users ADD COLUMN onboarding_completed BOOLEAN DEFAULT FALSE;
ALTER TABLE users ADD COLUMN onboarding_completed_at TIMESTAMP NULL;
```

**Testing Plan**:
- Onboarding flow testing
- Permission handling testing
- Skip functionality testing

---

#### Task 2.4: Animations & Transitions
**Description**: Add smooth animations throughout the app  
**Estimated Time**: 10 hours  
**Priority**: 🟡 MEDIUM

**Files to Modify**:
- All screen files (UPDATE - add transitions)
- `frontend/lib/widgets/` (UPDATE - add animations)

**New Classes/Services**:
- Custom page transitions
- Animation utilities
- Micro-interaction components

**APIs to Add/Update**: None

**Testing Plan**:
- Animation performance testing
- Visual testing

---

### Phase 2 Milestones

**Milestone 2.1**: Polished UI (End of Week 6)
- ✅ Design system implemented
- ✅ Navigation improved
- ✅ Onboarding flow complete
- ✅ Animations added

---

## 🚀 PHASE 3: NEW FEATURES
**Duration**: 4 weeks (Sprints 4-5)  
**Goal**: Add essential new features

### Sprint 4: Push Notifications & Offline Mode (Weeks 7-8)

#### Task 3.1: Push Notifications System
**Description**: Implement Firebase Cloud Messaging  
**Estimated Time**: 24 hours  
**Priority**: 🟠 HIGH

**Files to Modify**:
- `backend/pom.xml` (ADD Firebase Admin SDK)
- `backend/src/main/java/com/medical/emotionmonitoring/service/NotificationService.java` (NEW)
- `backend/src/main/java/com/medical/emotionmonitoring/controller/NotificationController.java` (NEW)
- `frontend/pubspec.yaml` (ADD firebase_messaging)
- `frontend/lib/services/notification_service.dart` (NEW)
- `frontend/lib/main.dart` (UPDATE)

**New Classes/Services**:
- `NotificationService.java` - Backend notification service
- `NotificationController.java` - Notification endpoints
- `FcmToken.java` - Entity
- `Notification.dart` - Frontend service
- `NotificationHandler.dart` - Frontend handler

**APIs to Add/Update**:
- `POST /api/notifications/register` - Register FCM token
- `POST /api/notifications/send` - Send notification (admin)
- `GET /api/notifications/history` - Get notification history
- `PUT /api/notifications/preferences` - Update preferences

**Database Changes**:
```sql
CREATE TABLE fcm_tokens (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    token VARCHAR(500) NOT NULL,
    device_type VARCHAR(50),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    UNIQUE KEY unique_token (token)
);

CREATE TABLE notifications (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    title VARCHAR(255) NOT NULL,
    body TEXT NOT NULL,
    type VARCHAR(50) NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

**Testing Plan**:
- Notification delivery testing
- Token management testing
- Background/foreground handling

---

#### Task 3.2: Offline Mode with Hive
**Description**: Implement local storage and sync  
**Estimated Time**: 32 hours  
**Priority**: 🟠 HIGH

**Files to Modify**:
- `frontend/pubspec.yaml` (ADD hive, hive_flutter)
- `frontend/lib/services/offline_service.dart` (NEW)
- `frontend/lib/services/sync_manager.dart` (NEW)
- `frontend/lib/models/` (UPDATE - add Hive adapters)
- All providers (UPDATE - add offline support)

**New Classes/Services**:
- `OfflineService.dart` - Local storage service
- `SyncManager.dart` - Sync coordination
- Hive adapters for all models
- Offline queue manager

**APIs to Add/Update**:
- `POST /api/sync/emotions` - Sync emotions
- `POST /api/sync/notes` - Sync notes
- `GET /api/sync/status` - Get sync status
- `POST /api/sync/resolve-conflict` - Resolve conflicts

**Database Changes**:
```sql
ALTER TABLE emotions ADD COLUMN sync_status VARCHAR(50) DEFAULT 'SYNCED';
ALTER TABLE emotions ADD COLUMN last_synced_at TIMESTAMP NULL;
ALTER TABLE patient_notes ADD COLUMN sync_status VARCHAR(50) DEFAULT 'SYNCED';
ALTER TABLE patient_notes ADD COLUMN last_synced_at TIMESTAMP NULL;
```

**Testing Plan**:
- Offline functionality testing
- Sync conflict resolution testing
- Data integrity testing

---

### Sprint 5: Enhanced Features (Weeks 9-10)

#### Task 3.3: Improved Emotion Detection
**Description**: Multi-model ensemble and preprocessing  
**Estimated Time**: 20 hours  
**Priority**: 🟡 MEDIUM

**Files to Modify**:
- `backend/src/main/java/com/medical/emotionmonitoring/service/EmotionDetectionService.java` (UPDATE)
- `backend/src/main/java/com/medical/emotionmonitoring/service/EmotionDetectionEnsembleService.java` (NEW)
- `backend/src/main/java/com/medical/emotionmonitoring/service/ImagePreprocessingService.java` (NEW)

**New Classes/Services**:
- `EmotionDetectionEnsembleService.java` - Ensemble service
- `ImagePreprocessingService.java` - Image processing

**APIs to Add/Update**: None (internal improvement)

**Database Changes**:
```sql
CREATE TABLE emotion_detection_logs (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    emotion_id BIGINT NOT NULL,
    model_name VARCHAR(100) NOT NULL,
    confidence DECIMAL(5,2),
    response_time_ms INT,
    FOREIGN KEY (emotion_id) REFERENCES emotions(id)
);
```

**Testing Plan**:
- Accuracy testing
- Performance testing
- Model comparison

---

#### Task 3.4: Analytics Integration
**Description**: Add analytics and performance monitoring  
**Estimated Time**: 16 hours  
**Priority**: 🟡 MEDIUM

**Files to Modify**:
- `backend/pom.xml` (ADD Actuator)
- `backend/src/main/java/com/medical/emotionmonitoring/config/ActuatorConfig.java` (NEW)
- `frontend/pubspec.yaml` (ADD firebase_analytics)
- `frontend/lib/services/analytics_service.dart` (NEW)

**New Classes/Services**:
- `AnalyticsService.dart` - Frontend analytics
- Actuator endpoints configuration

**APIs to Add/Update**:
- Actuator endpoints: `/actuator/health`, `/actuator/metrics`

**Testing Plan**:
- Analytics event tracking
- Performance monitoring
- Error tracking

---

### Phase 3 Milestones

**Milestone 3.1**: Core Features Complete (End of Week 8)
- ✅ Push notifications working
- ✅ Offline mode functional

**Milestone 3.2**: Enhanced Features (End of Week 10)
- ✅ Improved emotion detection
- ✅ Analytics integrated

---

## ⚡ PHASE 4: OPTIMIZATION
**Duration**: 2 weeks (Sprint 6)  
**Goal**: Performance and scalability improvements

### Sprint 6: Performance & Scalability (Weeks 11-12)

#### Task 4.1: Backend Performance Optimization
**Description**: Caching, query optimization, async processing  
**Estimated Time**: 20 hours  
**Priority**: 🟡 MEDIUM

**Files to Modify**:
- `backend/pom.xml` (ADD Redis, cache dependencies)
- `backend/src/main/java/com/medical/emotionmonitoring/config/CacheConfig.java` (NEW)
- All service classes (UPDATE - add caching)

**New Classes/Services**:
- `CacheConfig.java` - Redis cache configuration
- Cache managers

**APIs to Add/Update**: None (internal optimization)

**Testing Plan**:
- Performance benchmarking
- Cache hit rate testing
- Load testing

---

#### Task 4.2: Frontend Performance Optimization
**Description**: Code splitting, image optimization, lazy loading  
**Estimated Time**: 16 hours  
**Priority**: 🟡 MEDIUM

**Files to Modify**:
- All screen files (UPDATE - lazy loading)
- `frontend/lib/main.dart` (UPDATE - code splitting)
- Image handling (UPDATE - optimization)

**New Classes/Services**: None

**APIs to Add/Update**: None

**Testing Plan**:
- Bundle size analysis
- Performance profiling
- Load time testing

---

#### Task 4.3: Database Query Optimization
**Description**: Optimize queries, add connection pooling  
**Estimated Time**: 12 hours  
**Priority**: 🟡 MEDIUM

**Files to Modify**:
- All repository classes (UPDATE - query optimization)
- `backend/src/main/resources/application.properties` (UPDATE)

**New Classes/Services**: None

**APIs to Add/Update**: None

**Testing Plan**:
- Query performance testing
- Connection pool monitoring
- Slow query analysis

---

### Phase 4 Milestones

**Milestone 4.1**: Optimized Performance (End of Week 12)
- ✅ Backend caching implemented
- ✅ Frontend optimized
- ✅ Database queries optimized

---

## 🏥 PHASE 5: RELEASE PREP
**Duration**: 4 weeks (Sprints 7-8)  
**Goal**: Compliance and store preparation

### Sprint 7: Compliance & Security (Weeks 13-14)

#### Task 5.1: HIPAA Compliance
**Description**: Implement HIPAA requirements  
**Estimated Time**: 32 hours  
**Priority**: 🔴 CRITICAL

**Files to Modify**:
- `backend/src/main/java/com/medical/emotionmonitoring/entity/AuditLog.java` (NEW)
- `backend/src/main/java/com/medical/emotionmonitoring/service/AuditService.java` (NEW)
- All controllers (UPDATE - add audit logging)

**New Classes/Services**:
- `AuditLog.java` - Entity
- `AuditService.java` - Audit logging service
- Encryption utilities

**APIs to Add/Update**: None (internal compliance)

**Database Changes**:
```sql
CREATE TABLE audit_logs (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT,
    action VARCHAR(100) NOT NULL,
    resource_type VARCHAR(50),
    resource_id BIGINT,
    ip_address VARCHAR(45),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    details JSON
);
```

**Testing Plan**:
- Audit log verification
- Encryption testing
- Compliance audit

---

#### Task 5.2: GDPR Compliance
**Description**: Implement GDPR requirements  
**Estimated Time**: 20 hours  
**Priority**: 🔴 CRITICAL

**Files to Modify**:
- `backend/src/main/java/com/medical/emotionmonitoring/controller/UserController.java` (UPDATE)
- `backend/src/main/java/com/medical/emotionmonitoring/service/UserService.java` (UPDATE)
- `frontend/lib/screens/profile/` (UPDATE - add GDPR options)

**New Classes/Services**:
- Consent management service
- Data export service
- Data deletion service

**APIs to Add/Update**:
- `GET /api/users/export-data` - Export user data
- `DELETE /api/users/data` - Delete user data
- `POST /api/users/consent` - Manage consent

**Database Changes**:
```sql
CREATE TABLE user_consents (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    consent_type VARCHAR(50) NOT NULL,
    granted BOOLEAN NOT NULL,
    granted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

**Testing Plan**:
- Data export testing
- Data deletion testing
- Consent management testing

---

### Sprint 8: Store Preparation (Weeks 15-16)

#### Task 5.3: App Store Preparation
**Description**: Prepare for iOS App Store  
**Estimated Time**: 16 hours  
**Priority**: 🔴 CRITICAL

**Files to Modify**:
- `frontend/ios/` (UPDATE - configuration)
- `frontend/pubspec.yaml` (UPDATE - app info)
- `frontend/assets/` (ADD - app icons, screenshots)

**New Classes/Services**: None

**APIs to Add/Update**: None

**Testing Plan**:
- App Store guidelines compliance
- Icon and screenshot preparation
- Metadata preparation

---

#### Task 5.4: Play Store Preparation
**Description**: Prepare for Google Play Store  
**Estimated Time**: 16 hours  
**Priority**: 🔴 CRITICAL

**Files to Modify**:
- `frontend/android/` (UPDATE - configuration)
- `frontend/pubspec.yaml` (UPDATE - app info)
- `frontend/assets/` (ADD - app icons, screenshots)

**New Classes/Services**: None

**APIs to Add/Update**: None

**Testing Plan**:
- Play Store guidelines compliance
- Icon and screenshot preparation
- Metadata preparation

---

#### Task 5.5: Privacy Policy & Terms
**Description**: Create privacy policy and terms of service  
**Estimated Time**: 8 hours  
**Priority**: 🔴 CRITICAL

**Files to Modify**:
- `frontend/lib/screens/legal/` (NEW - privacy, terms screens)
- Documentation (ADD - privacy policy, terms)

**New Classes/Services**: None

**APIs to Add/Update**: None

**Testing Plan**:
- Legal review
- User acceptance flow

---

### Phase 5 Milestones

**Milestone 5.1**: Compliance Complete (End of Week 14)
- ✅ HIPAA compliant
- ✅ GDPR compliant

**Milestone 5.2**: Ready for Release (End of Week 16)
- ✅ App Store ready
- ✅ Play Store ready
- ✅ All documentation complete

---

## 📅 SPRINT STRUCTURE

### Sprint Template (2 weeks)

**Week 1**:
- Monday: Sprint planning, task assignment
- Tuesday-Thursday: Development
- Friday: Code review, testing

**Week 2**:
- Monday-Wednesday: Development continuation
- Thursday: Sprint review, demo
- Friday: Retrospective, next sprint planning

### Daily Standup (15 minutes)
- What did you complete yesterday?
- What will you work on today?
- Any blockers?

---

## 🌿 FEATURE BRANCH NAMING

### Naming Convention
```
{type}/{phase}-{task-number}-{short-description}
```

### Types
- `feat/` - New feature
- `fix/` - Bug fix
- `refactor/` - Code refactoring
- `docs/` - Documentation
- `test/` - Testing
- `chore/` - Maintenance

### Examples
```
feat/phase1-1.1-global-exception-handler
fix/phase1-1.2-database-migrations
feat/phase3-3.1-push-notifications
refactor/phase4-4.1-backend-optimization
```

### Branch Workflow
1. Create feature branch from `develop`
2. Develop and commit
3. Create pull request to `develop`
4. Code review
5. Merge to `develop`
6. After phase completion, merge `develop` to `main`

---

## 🧪 TESTING PLAN

### Test Levels

#### Unit Tests
- **Backend**: Service layer, utilities, validators
- **Frontend**: Providers, services, utilities
- **Target Coverage**: 80%+

#### Integration Tests
- **Backend**: Controller endpoints, database operations
- **Frontend**: Widget tests, screen tests
- **Target Coverage**: 70%+

#### E2E Tests
- Critical user flows
- Authentication flow
- Emotion detection flow
- Doctor-patient interaction flow

### Test Execution

#### Before Each Commit
- Run unit tests
- Run linters
- Check code coverage

#### Before Each PR
- All unit tests
- Integration tests
- Code review

#### Before Release
- Full test suite
- E2E tests
- Performance tests
- Security tests

### Test Tools
- **Backend**: JUnit, Mockito, TestContainers
- **Frontend**: Flutter Test, Golden Tests
- **E2E**: Flutter Driver, Integration Tests

---

## 📊 PROGRESS TRACKING

### Metrics to Track
- Tasks completed per sprint
- Code coverage percentage
- Bug count and resolution time
- Performance metrics
- User feedback (after release)

### Reporting
- Weekly progress reports
- Sprint retrospectives
- Phase completion reports
- Release readiness assessment

---

## 🎯 SUCCESS CRITERIA

### Phase 1 Success
- ✅ All critical security issues resolved
- ✅ Test coverage > 80%
- ✅ No critical bugs
- ✅ Production-ready infrastructure

### Phase 2 Success
- ✅ Design system implemented
- ✅ Onboarding flow complete
- ✅ User satisfaction > 4/5

### Phase 3 Success
- ✅ Push notifications working
- ✅ Offline mode functional
- ✅ All new features tested

### Phase 4 Success
- ✅ Performance improved by 50%
- ✅ Scalability validated
- ✅ Load testing passed

### Phase 5 Success
- ✅ Compliance certified
- ✅ Store listings approved
- ✅ Ready for production release

---

**Last Updated**: 2024  
**Version**: 1.0.0  
**Status**: Ready for Implementation


