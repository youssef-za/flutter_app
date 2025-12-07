# 🚨 Implémentation des Alertes en Temps Réel

## Vue d'ensemble

Cette fonctionnalité garantit que **chaque émotion détectée sur le visage d'un patient envoie automatiquement une alerte en temps réel au médecin assigné**.

## Modifications apportées

### 1. Backend - Création d'alertes pour chaque émotion

**Fichier** : `backend/src/main/java/com/medical/emotionmonitoring/service/EmotionService.java`

#### Changements :
- ✅ **Méthode `createEmotionAlert()`** : Crée une alerte pour chaque émotion détectée
- ✅ **Délai anti-spam réduit** : De 5 minutes à **30 secondes** pour un temps réel optimal
- ✅ **Appel automatique** : La méthode est appelée dans :
  - `createEmotion()` - Pour les émotions créées manuellement
  - `createEmotionFromImage()` - Pour les émotions détectées depuis une image

#### Logique :
```java
// Vérifie si une alerte similaire existe dans les 30 dernières secondes
// Si oui, évite les doublons
// Sinon, crée une nouvelle alerte avec :
// - Type d'émotion (HAPPY, SAD, ANGRY, FEAR, NEUTRAL)
// - Niveau de confiance (pourcentage)
// - Nom du patient
```

### 2. Backend - Assignation intelligente des médecins

**Fichier** : `backend/src/main/java/com/medical/emotionmonitoring/service/AlertService.java`

#### Changements :
- ✅ **Méthode `findDoctorForPatient()`** : Trouve le médecin assigné au patient
- ✅ **Fallback** : Si aucun médecin n'est assigné, utilise le premier médecin disponible
- ✅ **Priorité** : Les médecins assignés ont la priorité

### 3. Frontend - Polling en temps réel

**Fichier** : `frontend/lib/providers/alert_provider.dart`

#### Changements :
- ✅ **Polling automatique** : Rafraîchit les alertes toutes les **10 secondes**
- ✅ **Mode silencieux** : Les mises à jour en arrière-plan n'affichent pas de loader
- ✅ **Gestion du cycle de vie** : Démarre automatiquement au chargement du dashboard, s'arrête à la fermeture

#### Méthodes ajoutées :
```dart
void startRealTimePolling(int doctorId)  // Démarre le polling
void stopPolling()                        // Arrête le polling
```

### 4. Frontend - Intégration dans le Dashboard

**Fichier** : `frontend/lib/screens/home/tabs/doctor_dashboard_tab.dart`

#### Changements :
- ✅ **Démarrage automatique** : Le polling démarre quand le dashboard s'affiche
- ✅ **Arrêt automatique** : Le polling s'arrête quand l'écran est fermé
- ✅ **Rafraîchissement** : Les alertes sont mises à jour automatiquement toutes les 10 secondes

## Flux de fonctionnement

### 1. Détection d'émotion
```
Patient capture une émotion
    ↓
EmotionService.createEmotionFromImage()
    ↓
Emotion sauvegardée en base de données
    ↓
createEmotionAlert() appelée automatiquement
```

### 2. Création d'alerte
```
createEmotionAlert()
    ↓
Vérifie les alertes récentes (30 secondes)
    ↓
Si aucune alerte similaire → Crée une nouvelle alerte
    ↓
Trouve le médecin assigné au patient
    ↓
Alerte sauvegardée en base de données
```

### 3. Affichage en temps réel
```
Dashboard du médecin ouvert
    ↓
startRealTimePolling() appelé
    ↓
Polling toutes les 10 secondes
    ↓
loadUnreadAlertsByDoctorId() (mode silencieux)
    ↓
Interface mise à jour automatiquement
    ↓
Nouvelles alertes affichées immédiatement
```

## Exemple de message d'alerte

```
New emotion detected: Patient John Doe has recorded a SAD emotion with 85.3% confidence.
```

## Configuration

### Délai anti-spam
- **Actuel** : 30 secondes
- **Fichier** : `EmotionService.java` ligne 101
- **Modifiable** : Changez `minusSeconds(30)` pour ajuster

### Fréquence de polling
- **Actuel** : 10 secondes
- **Fichier** : `alert_provider.dart` ligne 132
- **Modifiable** : Changez `Duration(seconds: 10)` pour ajuster

## Avantages

1. ✅ **Temps réel** : Les alertes arrivent en moins de 10 secondes
2. ✅ **Pas de spam** : Protection contre les doublons (30 secondes)
3. ✅ **Assignation intelligente** : Les alertes vont au bon médecin
4. ✅ **Performance** : Polling silencieux sans impact sur l'UI
5. ✅ **Automatique** : Aucune action requise de la part du médecin

## Tests recommandés

1. **Test de détection** :
   - Capturer une émotion depuis l'app patient
   - Vérifier qu'une alerte est créée dans la base de données
   - Vérifier que l'alerte apparaît dans le dashboard du médecin

2. **Test de temps réel** :
   - Ouvrir le dashboard du médecin
   - Capturer une nouvelle émotion depuis l'app patient
   - Vérifier que l'alerte apparaît dans les 10 secondes

3. **Test anti-spam** :
   - Capturer plusieurs émotions rapidement (moins de 30 secondes)
   - Vérifier qu'une seule alerte est créée

4. **Test d'assignation** :
   - Assigner un patient à un médecin spécifique
   - Capturer une émotion
   - Vérifier que l'alerte va au bon médecin

## Notes importantes

- ⚠️ Le polling consomme des ressources réseau. 10 secondes est un bon compromis entre temps réel et performance.
- ⚠️ Le délai de 30 secondes évite le spam mais permet toujours un temps réel acceptable.
- ⚠️ Si aucun médecin n'est assigné, l'alerte va au premier médecin disponible.
- ⚠️ Les alertes pour "3 émotions SAD consécutives" continuent de fonctionner en plus des alertes individuelles.

## Améliorations futures possibles

1. **WebSockets** : Remplacer le polling par WebSockets pour un vrai temps réel instantané
2. **Notifications push** : Ajouter des notifications push pour les alertes critiques
3. **Filtrage intelligent** : Permettre aux médecins de filtrer les types d'alertes
4. **Priorités** : Ajouter des niveaux de priorité aux alertes (critique, normal, info)

