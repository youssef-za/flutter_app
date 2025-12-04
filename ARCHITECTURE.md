# 🏗️ System Architecture Documentation

## Overview

This document describes the architecture of the Medical Emotion Monitoring System, including system components, data flow, technology stack, and design patterns.

---

## 🎯 Architecture Diagram (Text Description)

```
┌─────────────────────────────────────────────────────────────────┐
│                         CLIENT LAYER                             │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │              Flutter Mobile Application                   │  │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐ │  │
│  │  │  UI      │  │  State   │  │ Services │  │  Models  │ │  │
│  │  │  Layer   │  │Management│  │  Layer   │  │  Layer   │ │  │
│  │  └──────────┘  └──────────┘  └──────────┘  └──────────┘ │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ HTTPS/REST API
                              │ JWT Authentication
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      API GATEWAY LAYER                          │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │              Spring Boot REST Controllers                  │  │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐ │  │
│  │  │  Auth    │  │ Emotion  │  │   User   │  │  Alert   │ │  │
│  │  │Controller│  │Controller│  │Controller│  │Controller│ │  │
│  │  └──────────┘  └──────────┘  └──────────┘  └──────────┘ │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      BUSINESS LOGIC LAYER                       │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │              Spring Boot Services                         │  │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐ │  │
│  │  │  Auth    │  │ Emotion  │  │   User   │  │ Emotion   │ │  │
│  │  │ Service  │  │ Service  │  │ Service  │  │Detection  │ │  │
│  │  └──────────┘  └──────────┘  └──────────┘  │  Service  │ │  │
│  │                                              └──────────┘ │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      DATA ACCESS LAYER                          │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │              Spring Data JPA Repositories                 │  │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐ │  │
│  │  │   User   │  │ Emotion  │  │  Alert   │  │  Note    │ │  │
│  │  │Repository│  │Repository│  │Repository│  │Repository│ │  │
│  │  └──────────┘  └──────────┘  └──────────┘  └──────────┘ │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ JDBC
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      DATA STORAGE LAYER                         │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                    MySQL Database                         │  │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐ │  │
│  │  │  Users   │  │ Emotions │  │  Alerts  │  │  Notes   │ │  │
│  │  │  Table   │  │  Table   │  │  Table   │  │  Table   │ │  │
│  │  └──────────┘  └──────────┘  └──────────┘  └──────────┘ │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘

                              │
                              │ External API Calls
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    EXTERNAL SERVICES                            │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │   Luxand     │  │  HuggingFace │  │   EdenAI    │         │
│  │  Emotion API │  │  Emotion API │  │ Emotion API │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🏛️ Architecture Layers

### 1. Client Layer (Flutter)

#### Components
- **UI Layer**: Screens, widgets, and user interface components
- **State Management**: Provider for state management
- **Services Layer**: API service, navigation service, storage service
- **Models Layer**: Data models and DTOs

#### Responsibilities
- User interface rendering
- User interaction handling
- Local state management
- API communication
- Local data caching
- Offline data storage

#### Key Technologies
- Flutter 3.38.3
- Provider (state management)
- Dio (HTTP client)
- Hive (local storage - planned)
- flutter_secure_storage (secure storage)

---

### 2. API Gateway Layer (Spring Boot Controllers)

#### Components
- `AuthController` - Authentication endpoints
- `EmotionController` - Emotion-related endpoints
- `UserController` - User management endpoints
- `AlertController` - Alert endpoints
- `PatientNoteController` - Patient notes endpoints
- `PatientTagController` - Patient tags endpoints

#### Responsibilities
- Request/response handling
- Input validation
- Authentication/authorization
- Error handling
- Response formatting

#### Key Technologies
- Spring Boot 3.2.0
- Spring Security
- JWT Authentication
- Bean Validation

---

### 3. Business Logic Layer (Spring Boot Services)

#### Components
- `AuthService` - Authentication logic
- `EmotionService` - Emotion business logic
- `EmotionDetectionService` - External API integration
- `UserService` - User management logic
- `AlertService` - Alert generation logic
- `EmotionStatisticsService` - Statistics calculation

#### Responsibilities
- Business rule enforcement
- Data transformation
- External service integration
- Complex calculations
- Transaction management

#### Key Technologies
- Spring Framework
- Spring Transaction Management
- RestTemplate (HTTP client)

---

### 4. Data Access Layer (Spring Data JPA)

#### Components
- `UserRepository` - User data access
- `EmotionRepository` - Emotion data access
- `AlertRepository` - Alert data access
- `PatientNoteRepository` - Notes data access
- Custom query methods

#### Responsibilities
- Database operations
- Query execution
- Data persistence
- Transaction management

#### Key Technologies
- Spring Data JPA
- Hibernate ORM
- MySQL Connector

---

### 5. Data Storage Layer (MySQL)

#### Components
- User tables
- Emotion tables
- Relationship tables
- Indexes and constraints

#### Responsibilities
- Data persistence
- Data integrity
- Query optimization
- Backup and recovery

#### Key Technologies
- MySQL 8.0
- InnoDB storage engine

---

## 🔄 Data Flow

### Authentication Flow
```
User → Flutter App → AuthController → AuthService → UserRepository → MySQL
                                                      ↓
                                              JWT Token Generation
                                                      ↓
User ← Flutter App ← AuthController ← AuthService ← JWT Token
```

### Emotion Detection Flow
```
User → Flutter App → EmotionController → EmotionService → EmotionDetectionService
                                                              ↓
                                                      External API (Luxand/HuggingFace)
                                                              ↓
User ← Flutter App ← EmotionController ← EmotionService ← Emotion Detection Result
                                                              ↓
                                                      EmotionRepository → MySQL
```

### Alert Generation Flow
```
Emotion Created → AlertService → Check Alert Rules → Generate Alert
                                                              ↓
                                                      AlertRepository → MySQL
                                                              ↓
                                                      Push Notification (Future)
```

---

## 🔐 Security Architecture

### Authentication
- **JWT Tokens**: Stateless authentication
- **Token Storage**: Secure storage in Flutter app
- **Token Validation**: Spring Security filter chain
- **Password Hashing**: BCrypt

### Authorization
- **Role-Based Access Control**: Patient vs Doctor roles
- **Method Security**: `@PreAuthorize` annotations
- **Endpoint Protection**: Spring Security configuration

### Data Security
- **HTTPS**: Encrypted communication (production)
- **Input Validation**: Server-side validation
- **SQL Injection Prevention**: Parameterized queries (JPA)
- **XSS Prevention**: Input sanitization

---

## 📦 Design Patterns

### Backend Patterns
- **Repository Pattern**: Data access abstraction
- **Service Layer Pattern**: Business logic separation
- **DTO Pattern**: Data transfer objects
- **Factory Pattern**: Object creation
- **Strategy Pattern**: Multiple emotion detection APIs

### Frontend Patterns
- **Provider Pattern**: State management
- **Repository Pattern**: Data access abstraction
- **Service Pattern**: Business logic separation
- **Singleton Pattern**: Service instances

---

## 🔌 Integration Points

### External APIs
- **Luxand API**: Primary emotion detection
- **HuggingFace API**: Fallback emotion detection
- **EdenAI API**: Alternative emotion detection

### Future Integrations
- **Firebase Cloud Messaging**: Push notifications
- **AWS S3 / Cloud Storage**: File storage
- **Redis**: Caching layer
- **Email Service**: Notifications

---

## 📊 Scalability Considerations

### Horizontal Scaling
- **Stateless Backend**: JWT tokens enable horizontal scaling
- **Database Replication**: Read replicas for read-heavy operations
- **Load Balancing**: Multiple backend instances

### Vertical Scaling
- **Connection Pooling**: HikariCP for database connections
- **Caching**: Application-level caching (planned)
- **Query Optimization**: Indexes and query tuning

### Performance Optimization
- **Database Indexing**: Optimized queries
- **Pagination**: Limit data transfer
- **Lazy Loading**: On-demand data loading
- **Compression**: Response compression (planned)

---

## 🔄 Deployment Architecture

### Development
```
Local Machine
├── Flutter App (Hot Reload)
├── Spring Boot (Local)
└── MySQL (Local/Docker)
```

### Production (Planned)
```
Cloud Infrastructure
├── Flutter App (App Stores)
├── Spring Boot (Cloud - AWS/GCP/Azure)
├── MySQL (Managed Database)
├── Redis (Cache)
├── S3/Cloud Storage (Files)
└── CDN (Static Assets)
```

---

## 🧪 Testing Architecture

### Backend Testing
- **Unit Tests**: Service and repository tests
- **Integration Tests**: Controller tests with test database
- **Security Tests**: Authentication and authorization tests

### Frontend Testing
- **Unit Tests**: Provider and service tests
- **Widget Tests**: UI component tests
- **Integration Tests**: End-to-end user flows

---

## 📝 Code Organization

### Backend Structure
```
com.medical.emotionmonitoring/
├── controller/     # REST endpoints
├── service/        # Business logic
├── repository/     # Data access
├── entity/         # JPA entities
├── dto/            # Data transfer objects
├── security/       # Security configuration
└── validation/     # Custom validators
```

### Frontend Structure
```
lib/
├── config/         # Configuration
├── models/         # Data models
├── providers/      # State management
├── screens/        # UI screens
├── services/       # Business services
└── widgets/        # Reusable widgets
```

---

## 🔮 Future Architecture Enhancements

### Microservices (Optional)
- **Auth Service**: Separate authentication service
- **Emotion Service**: Emotion detection service
- **Notification Service**: Push notification service
- **Analytics Service**: Analytics and reporting

### Event-Driven Architecture
- **Message Queue**: RabbitMQ/Kafka for events
- **Event Sourcing**: Track all state changes
- **CQRS**: Separate read/write models

### API Gateway
- **Spring Cloud Gateway**: Centralized API management
- **Rate Limiting**: API throttling
- **Request Routing**: Service routing

---

**Last Updated**: 2024
**Version**: 1.0.0
**Architecture Style**: Layered Architecture (Monolithic)

