# 🚨 Fonctionnement du Système d'Alertes

## Vue d'ensemble

Le système d'alertes permet d'**informer automatiquement les médecins** lorsqu'un événement important se produit avec leurs patients, notamment lors de la détection d'émotions.

---

## 📋 Structure des Alertes

### Entité Alert (Backend)

Une alerte contient les informations suivantes :

```java
- id : Identifiant unique
- message : Message descriptif de l'alerte
- createdAt : Date et heure de création
- isRead : Statut de lecture (lu/non lu)
- doctor : Médecin destinataire
- patient : Patient concerné
```

### Modèle Alert (Frontend)

```dart
- id : Identifiant
- message : Message
- createdAt : Date de création
- isRead : Statut lu/non lu
- patientId : ID du patient
- patientName : Nom du patient
- doctorId : ID du médecin
- doctorName : Nom du médecin
```

---

## 🔄 Cycle de Vie d'une Alerte

### 1. **Création d'Alerte** (Backend)

#### Déclencheurs automatiques :

**A. Détection d'émotion** (Temps réel)
- ✅ Chaque fois qu'un patient capture une émotion
- ✅ Délai anti-spam : 30 secondes (évite les doublons)
- ✅ Message : `"New emotion detected: Patient [Nom] has recorded a [TYPE] emotion with [X]% confidence."`

**B. 3 émotions SAD consécutives** (Alerte spéciale)
- ✅ Détecte un pattern de 3 émotions SAD consécutives
- ✅ Délai anti-spam : 1 heure
- ✅ Message : `"Alert: Patient [Nom] has recorded 3 consecutive SAD emotions. Please review their emotional state."`

#### Processus de création :

```
1. Patient capture une émotion
   ↓
2. EmotionService.createEmotionFromImage()
   ↓
3. Emotion sauvegardée en base de données
   ↓
4. createEmotionAlert() appelée automatiquement
   ↓
5. Vérification anti-spam (30 secondes)
   ↓
6. AlertService.createAlert()
   ↓
7. Recherche du médecin assigné au patient
   ↓
8. Alerte créée et sauvegardée
```

### 2. **Assignation du Médecin**

Le système trouve automatiquement le médecin approprié :

```java
1. Cherche d'abord le médecin assigné au patient
   ↓
2. Si trouvé → Alerte envoyée à ce médecin
   ↓
3. Si aucun médecin assigné → Premier médecin disponible
   ↓
4. Si aucun médecin → Erreur (système ne peut pas fonctionner)
```

### 3. **Stockage en Base de Données**

L'alerte est sauvegardée dans la table `alerts` avec :
- ✅ Statut initial : `isRead = false` (non lue)
- ✅ Timestamp automatique : `createdAt = now()`
- ✅ Relations : `doctor_id` et `patient_id`

---

## 📱 Affichage dans l'Application (Frontend)

### Dashboard du Médecin

#### Section Alertes

1. **Chargement initial** :
   ```
   Dashboard ouvert
   ↓
   AlertProvider.loadUnreadAlertsByDoctorId()
   ↓
   Affichage des alertes non lues
   ```

2. **Polling en temps réel** :
   ```
   startRealTimePolling() activé
   ↓
   Rafraîchissement automatique toutes les 10 secondes
   ↓
   Nouvelles alertes apparaissent automatiquement
   ```

3. **Affichage visuel** :
   - 🔴 Badge avec nombre d'alertes non lues
   - 📋 Liste des 3 dernières alertes non lues
   - ⚠️ Icône d'avertissement pour chaque alerte
   - 📅 Date et heure de création
   - 👤 Nom du patient concerné
   - ✉️ Message descriptif

### Actions Disponibles

#### Marquer comme lue
```
Clic sur le bouton "X" (fermer)
   ↓
AlertProvider.markAlertAsRead(alertId)
   ↓
API PUT /alerts/{alertId}/read
   ↓
Alerte retirée de la liste "non lue"
   ↓
Interface mise à jour
```

---

## 🔌 API Endpoints

### Backend (Spring Boot)

#### 1. Récupérer toutes les alertes d'un médecin
```
GET /alerts/doctor/{doctorId}
Authorization: Bearer [JWT Token]
Role: DOCTOR
Response: Liste de toutes les alertes (lues + non lues)
```

#### 2. Récupérer les alertes non lues
```
GET /alerts/doctor/{doctorId}/unread
Authorization: Bearer [JWT Token]
Role: DOCTOR
Response: Liste des alertes non lues uniquement
```

#### 3. Marquer une alerte comme lue
```
PUT /alerts/{alertId}/read
Authorization: Bearer [JWT Token]
Role: DOCTOR
Response: 200 OK
```

### Frontend (Flutter)

#### Service API
```dart
// Récupérer toutes les alertes
getAlertsByDoctorId(int doctorId)

// Récupérer les alertes non lues
getUnreadAlertsByDoctorId(int doctorId)

// Marquer comme lue
markAlertAsRead(int alertId)
```

---

## ⚙️ Configuration et Paramètres

### Délai Anti-Spam

**Pour les alertes d'émotion** :
- **Valeur** : 30 secondes
- **Fichier** : `EmotionService.java` ligne 103
- **Objectif** : Éviter les doublons si plusieurs émotions sont capturées rapidement
- **Modifiable** : Oui, changer `minusSeconds(30)`

**Pour les alertes SAD consécutives** :
- **Valeur** : 1 heure
- **Fichier** : `EmotionService.java` ligne 109
- **Objectif** : Éviter les alertes répétitives pour le même pattern
- **Modifiable** : Oui, changer `minusHours(1)`

### Fréquence de Polling

**Temps réel** :
- **Valeur** : 10 secondes
- **Fichier** : `alert_provider.dart` ligne 140
- **Objectif** : Rafraîchir les alertes automatiquement
- **Modifiable** : Oui, changer `Duration(seconds: 10)`

---

## 📊 Types d'Alertes

### 1. Alerte d'Émotion Détectée

**Déclencheur** : Chaque émotion capturée par un patient

**Exemple de message** :
```
"New emotion detected: Patient John Doe has recorded a SAD emotion with 85.3% confidence."
```

**Informations incluses** :
- ✅ Nom du patient
- ✅ Type d'émotion (HAPPY, SAD, ANGRY, FEAR, NEUTRAL)
- ✅ Niveau de confiance (pourcentage)

### 2. Alerte d'Émotions SAD Consécutives

**Déclencheur** : 3 émotions SAD consécutives détectées

**Exemple de message** :
```
"Alert: Patient John Doe has recorded 3 consecutive SAD emotions. Please review their emotional state."
```

**Informations incluses** :
- ✅ Nom du patient
- ✅ Pattern détecté (3 SAD consécutives)
- ✅ Recommandation d'action

---

## 🔍 Flux Complet : Exemple Concret

### Scénario : Patient capture une émotion SAD

```
1. PATIENT
   └─> Ouvre l'application
   └─> Prend une photo de son visage
   └─> Emotion détectée : SAD (85% confiance)

2. BACKEND
   └─> EmotionService.createEmotionFromImage()
   └─> Emotion sauvegardée en base
   └─> createEmotionAlert() appelée
   └─> Vérification anti-spam (30 secondes)
   └─> AlertService.createAlert()
   └─> Recherche du médecin assigné
   └─> Alerte créée avec :
       - message: "New emotion detected: Patient John Doe has recorded a SAD emotion with 85.0% confidence."
       - isRead: false
       - doctor: Dr. Smith (médecin assigné)
       - patient: John Doe

3. BASE DE DONNÉES
   └─> INSERT INTO alerts (message, is_read, doctor_id, patient_id, created_at)
   └─> Alerte sauvegardée

4. FRONTEND (Dashboard Médecin)
   └─> Polling actif (toutes les 10 secondes)
   └─> loadUnreadAlertsByDoctorId() appelée
   └─> Nouvelle alerte détectée
   └─> Interface mise à jour automatiquement
   └─> Badge "1" affiché
   └─> Alerte visible dans la liste

5. MÉDECIN
   └─> Voit la nouvelle alerte
   └─> Lit le message
   └─> Clique sur "X" pour marquer comme lue
   └─> Alerte retirée de la liste "non lue"
```

---

## 🎯 Avantages du Système

### ✅ Temps Réel
- Alertes visibles en moins de 10 secondes
- Polling automatique sans action requise

### ✅ Anti-Spam Intelligent
- Protection contre les doublons (30 secondes)
- Évite la surcharge d'alertes

### ✅ Assignation Automatique
- Les alertes vont au bon médecin
- Fallback si aucun médecin assigné

### ✅ Interface Intuitive
- Badge avec compteur d'alertes
- Affichage clair et lisible
- Actions simples (marquer comme lue)

### ✅ Performance
- Polling silencieux (pas de loader)
- Mise à jour optimisée
- Gestion du cycle de vie automatique

---

## 🔧 Maintenance et Dépannage

### Problèmes Courants

#### 1. Alertes ne s'affichent pas
**Vérifications** :
- ✅ Le polling est-il actif ? (`alertProvider.isPolling`)
- ✅ Le médecin est-il correctement authentifié ?
- ✅ Y a-t-il des erreurs dans la console ?

#### 2. Alertes en double
**Cause** : Délai anti-spam trop court
**Solution** : Augmenter `minusSeconds(30)` dans `EmotionService.java`

#### 3. Alertes ne sont pas créées
**Vérifications** :
- ✅ Y a-t-il un médecin dans le système ?
- ✅ Le patient est-il assigné à un médecin ?
- ✅ Vérifier les logs backend pour les erreurs

### Logs Utiles

**Backend** :
```
✅ Real-time alert created for patient {} due to detected emotion: {} (confidence: {})
❌ Failed to create alert for patient {}: {}
```

**Frontend** :
- Console Flutter pour les erreurs API
- Network tab pour vérifier les requêtes

---

## 📈 Statistiques et Métriques

### Métriques Disponibles

- **Nombre d'alertes non lues** : `alertProvider.unreadCount`
- **Total d'alertes** : `alertProvider.alerts.length`
- **Statut du polling** : `alertProvider.isPolling`

### Endpoints de Statistiques (Futur)

```
GET /alerts/doctor/{doctorId}/stats
Response: {
  "total": 50,
  "unread": 5,
  "read": 45,
  "today": 10,
  "thisWeek": 30
}
```

---

## 🚀 Améliorations Futures Possibles

1. **WebSockets** : Remplacer le polling par WebSockets pour un vrai temps réel instantané
2. **Notifications Push** : Alertes push sur mobile même si l'app est fermée
3. **Filtres** : Filtrer par type d'émotion, date, patient
4. **Priorités** : Niveaux de priorité (critique, normal, info)
5. **Historique** : Page dédiée pour voir toutes les alertes (lues + non lues)
6. **Actions rapides** : Boutons pour contacter le patient directement depuis l'alerte

---

## 📝 Résumé

Le système d'alertes fonctionne de manière **automatique et en temps réel** :

1. ✅ **Détection** : Chaque émotion déclenche une alerte
2. ✅ **Assignation** : Alerte envoyée au médecin assigné
3. ✅ **Stockage** : Sauvegardée en base de données
4. ✅ **Affichage** : Visible dans le dashboard en moins de 10 secondes
5. ✅ **Gestion** : Peut être marquée comme lue

**Tout est automatique** - Aucune action manuelle requise ! 🎉

