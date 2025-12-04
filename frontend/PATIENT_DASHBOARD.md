# Patient Dashboard - Documentation

## ✅ Fonctionnalités Implémentées

### 1. **Affichage de l'Émotion Actuelle**
- ✅ Carte visuelle avec l'émotion détectée la plus récente
- ✅ Icône grande et colorée selon le type d'émotion
- ✅ Affichage du type d'émotion en grand
- ✅ Pourcentage de confiance
- ✅ Date et heure de détection
- ✅ Design avec gradient et couleurs adaptées

### 2. **Bouton pour Capturer une Nouvelle Émotion**
- ✅ Bouton principal "Capture New Emotion"
- ✅ Utilise la caméra pour prendre une photo
- ✅ Détection automatique de l'émotion via l'API
- ✅ Sauvegarde automatique après détection
- ✅ Feedback visuel (loading, success, error)
- ✅ Rechargement automatique après capture

### 3. **Accès à l'Historique des Émotions**
- ✅ Bouton "View Emotion History"
- ✅ Navigation vers l'onglet History
- ✅ Intégration avec le système de navigation
- ✅ Pull-to-refresh pour recharger

### 4. **Fonctionnalités Bonus**
- ✅ Section de bienvenue personnalisée
- ✅ Statistiques rapides (Total, Happy, Sad)
- ✅ État vide si aucune émotion
- ✅ Design moderne et professionnel

## 📋 Structure du Code

### PatientDashboardTab (`lib/screens/home/tabs/patient_dashboard_tab.dart`)

```dart
- Welcome Section (nom de l'utilisateur)
- Current Emotion Card (émotion actuelle)
- Action Buttons (capture + history)
- Quick Stats (statistiques)
```

### HomeScreen (`lib/screens/home/home_screen.dart`)

```dart
- Détection du rôle (PATIENT vs DOCTOR)
- Affichage conditionnel du dashboard patient
- Navigation entre onglets
- Méthode switchToHistoryTab() pour navigation programmatique
```

## 🎨 Design

### Carte d'Émotion Actuelle
- **Gradient** : Couleur de l'émotion avec opacité
- **Icône** : Grande icône circulaire (64px)
- **Type** : Texte en grand (32px, bold)
- **Confidence** : Badge coloré avec pourcentage
- **Timestamp** : Date et heure formatées

### Couleurs par Émotion
- **HAPPY** : Vert (Colors.green)
- **SAD** : Bleu (Colors.blue)
- **ANGRY** : Rouge (Colors.red)
- **FEAR** : Orange (Colors.orange)
- **NEUTRAL** : Gris (Colors.grey)

### Boutons d'Action
- **Capture** : Bouton principal (primary color)
- **History** : Bouton outlined (secondary)

## 🔄 Flux de Fonctionnement

### Chargement Initial
1. Au chargement, récupère l'historique des émotions
2. Affiche la dernière émotion détectée
3. Calcule les statistiques

### Capture d'Émotion
1. Utilisateur clique sur "Capture New Emotion"
2. Ouverture de la caméra
3. Prise de photo
4. Envoi à l'API `/emotions/detect`
5. Réception de l'émotion détectée
6. Sauvegarde automatique
7. Mise à jour de l'affichage
8. Message de succès

### Navigation vers l'Historique
1. Utilisateur clique sur "View Emotion History"
2. Appel de `switchToHistoryTab()`
3. Changement d'onglet vers History
4. Affichage de la liste complète

## 📊 Statistiques Rapides

Affiche :
- **Total** : Nombre total d'émotions enregistrées
- **Happy** : Nombre d'émotions HAPPY
- **Sad** : Nombre d'émotions SAD

Calculées à partir de la liste des émotions chargées.

## 🎯 États de l'Interface

### État avec Émotion
- Carte d'émotion avec toutes les informations
- Statistiques affichées
- Boutons actifs

### État sans Émotion
- Message "No emotion detected yet"
- Icône neutre
- Instructions pour commencer
- Boutons toujours disponibles

### État de Chargement
- Indicateur de chargement
- Message "Loading your emotion..."

## 🚀 Utilisation

Le dashboard patient s'affiche automatiquement pour les utilisateurs avec le rôle `PATIENT`.

Pour les utilisateurs `DOCTOR`, l'ancien onglet `EmotionsTab` est affiché.

## 📝 Notes

- Le dashboard charge automatiquement l'historique au démarrage
- Pull-to-refresh disponible pour recharger
- Les émotions sont triées par date (plus récente en premier)
- La dernière émotion est automatiquement mise à jour après capture

