# Doctor Dashboard - Documentation

## ✅ Fonctionnalités Implémentées

### 1. **Liste des Patients**
- ✅ Affichage de tous les patients enregistrés
- ✅ Informations patient (nom, email)
- ✅ Avatar avec initiale
- ✅ Badge d'émotion la plus récente
- ✅ Détails de la dernière émotion enregistrée
- ✅ Indicateur si aucun enregistrement

### 2. **Dernières Émotions des Patients**
- ✅ Affichage de l'émotion la plus récente pour chaque patient
- ✅ Type d'émotion avec badge coloré
- ✅ Niveau de confiance
- ✅ Date et heure de l'enregistrement
- ✅ Icônes par type d'émotion

### 3. **Alertes en Temps Réel**
- ✅ Affichage des alertes non lues
- ✅ Compteur d'alertes non lues
- ✅ Détails de l'alerte (patient, message, date)
- ✅ Marquer comme lu
- ✅ Affichage des 3 dernières alertes
- ✅ Lien pour voir toutes les alertes

### 4. **Statistiques d'Émotions**
- ✅ Vue d'ensemble (Total patients, Patients actifs)
- ✅ Graphiques d'émotions (via EmotionChart)
- ✅ Statistiques par patient

## 📋 Structure du Code

### Backend

#### AlertController (`backend/src/main/java/com/medical/emotionmonitoring/controller/AlertController.java`)
- `GET /alerts/doctor/{doctorId}` - Récupérer toutes les alertes d'un médecin
- `GET /alerts/doctor/{doctorId}/unread` - Récupérer les alertes non lues
- `PUT /alerts/{alertId}/read` - Marquer une alerte comme lue

#### UserController (`backend/src/main/java/com/medical/emotionmonitoring/controller/UserController.java`)
- `GET /users/patients` - Récupérer tous les patients (DOCTOR uniquement)

#### AlertService (`backend/src/main/java/com/medical/emotionmonitoring/service/AlertService.java`)
- `getAlertsByDoctorId()` - Récupérer les alertes par ID médecin
- `getUnreadAlertsByDoctorId()` - Récupérer les alertes non lues
- `markAsRead()` - Marquer une alerte comme lue

#### UserService (`backend/src/main/java/com/medical/emotionmonitoring/service/UserService.java`)
- `getPatients()` - Récupérer tous les patients (filtre PATIENT)

### Frontend

#### Models
- `AlertModel` (`lib/models/alert_model.dart`) - Modèle pour les alertes
- `UserModel` (`lib/models/user_model.dart`) - Modèle pour les utilisateurs (déjà existant)
- `EmotionModel` (`lib/models/emotion_model.dart`) - Modèle pour les émotions (déjà existant)

#### Providers
- `AlertProvider` (`lib/providers/alert_provider.dart`) - Gestion des alertes
- `PatientProvider` (`lib/providers/patient_provider.dart`) - Gestion des patients et leurs émotions

#### Services
- `ApiService` (`lib/services/api_service.dart`) - Endpoints pour patients et alertes

#### Screens
- `DoctorDashboardTab` (`lib/screens/home/tabs/doctor_dashboard_tab.dart`) - Dashboard principal

## 🎨 Interface Utilisateur

### Section Welcome
- Message de bienvenue personnalisé
- Icône médicale
- Design avec gradient

### Section Alertes
- Badge avec compteur d'alertes non lues
- Cartes d'alerte avec:
  - Icône d'avertissement
  - Nom du patient
  - Message de l'alerte
  - Date et heure
  - Bouton pour marquer comme lu
- Affichage des 3 dernières alertes
- Lien "View all alerts" si plus de 3

### Section Statistiques
- Cartes de statistiques:
  - Total Patients
  - Patients Actifs (avec émotions enregistrées)
- Design avec icônes et couleurs

### Section Patients
- Liste de cartes patient avec:
  - Avatar avec initiale
  - Nom complet
  - Email
  - Badge d'émotion la plus récente
  - Détails de la dernière émotion:
    - Type d'émotion
    - Date et heure
    - Niveau de confiance
  - Message si aucune émotion enregistrée

## 🔄 Flux de Données

### Chargement des Données
1. **Patients** : `PatientProvider.loadPatients()`
   - Appel API: `GET /users/patients`
   - Pour chaque patient, chargement de l'historique d'émotions
   - Extraction de la dernière émotion

2. **Alertes** : `AlertProvider.loadAlertsByDoctorId()`
   - Appel API: `GET /alerts/doctor/{doctorId}`
   - Appel API: `GET /alerts/doctor/{doctorId}/unread`

3. **Marquer comme lu** : `AlertProvider.markAlertAsRead()`
   - Appel API: `PUT /alerts/{alertId}/read`
   - Mise à jour de l'état local

## 🎯 Utilisation

### Accès au Dashboard
Le dashboard médecin est automatiquement affiché lorsque:
- L'utilisateur connecté a le rôle `DOCTOR`
- Navigation vers l'onglet Dashboard dans `HomeScreen`

### Refresh
- Pull-to-refresh disponible
- Recharge toutes les données (patients, alertes)

### Navigation
- Clic sur une carte patient (TODO: navigation vers détails patient)
- Clic sur "View all alerts" (TODO: navigation vers écran alertes complet)

## 📝 Notes Techniques

### Sécurité
- Tous les endpoints nécessitent l'authentification JWT
- Endpoints patients et alertes réservés aux DOCTOR
- Vérification du rôle côté backend avec `@PreAuthorize("hasRole('DOCTOR')")`

### Performance
- Chargement parallèle des données (patients et alertes)
- Chargement des émotions pour chaque patient en parallèle
- Mise en cache des données dans les providers

### Gestion d'Erreurs
- Affichage d'états de chargement
- Gestion des erreurs réseau
- Messages d'erreur utilisateur-friendly
- États vides (no patients, no alerts)

## ✨ Améliorations Futures

- [ ] Navigation vers détails patient
- [ ] Écran complet des alertes avec filtres
- [ ] Graphiques d'émotions par patient
- [ ] Recherche et filtrage des patients
- [ ] Notifications push pour nouvelles alertes
- [ ] Export des données patient
- [ ] Statistiques avancées (tendances, moyennes)
- [ ] Communication directe avec les patients

