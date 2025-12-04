# Register Screen - Documentation

## ✅ Fonctionnalités Implémentées

### 1. **Champs de Formulaire**
- ✅ **Full Name** : Champ texte avec validation (minimum 2 caractères)
- ✅ **Email** : Validation de format email
- ✅ **Password** : Masquage/affichage avec toggle
- ✅ **Confirm Password** : Vérification que les mots de passe correspondent

### 2. **Sélection de Rôle**
- ✅ **Patient** : Option avec icône santé (vert)
- ✅ **Doctor** : Option avec icône médicale (bleu)
- ✅ Interface visuelle avec sélection claire
- ✅ Validation obligatoire du rôle

### 3. **Intégration Spring Boot API**
- ✅ POST `/api/auth/register` avec tous les champs
- ✅ Envoi du rôle sélectionné (PATIENT ou DOCTOR)
- ✅ Gestion des erreurs réseau
- ✅ Gestion des erreurs d'inscription (email existant, etc.)

### 4. **Design Professionnel**
- ✅ Interface moderne avec Material Design 3
- ✅ Card avec bordure subtile
- ✅ Sélection de rôle visuelle avec icônes
- ✅ Espacement harmonieux
- ✅ Animations de chargement
- ✅ Feedback visuel pour les erreurs

## 📋 Structure du Code

### RegisterScreen (`lib/screens/auth/register_screen.dart`)

```dart
- Full Name field (validation)
- Email field (validation format)
- Role selection (Patient/Doctor)
- Password field (toggle visibility)
- Confirm Password field (match validation)
- Register button (avec loading state)
- Login link
```

### Backend Updates

#### RegisterRequest (`backend/src/main/java/.../dto/RegisterRequest.java`)
```java
- Ajout du champ role (optionnel, défaut: PATIENT)
```

#### UserService (`backend/src/main/java/.../service/UserService.java`)
```java
- Utilisation du rôle de la requête
- Fallback sur PATIENT si non fourni
```

### ApiService (`lib/services/api_service.dart`)

```dart
- register(fullName, email, password, {role?})
- Envoi du rôle dans la requête POST
```

### AuthProvider (`lib/providers/auth_provider.dart`)

```dart
- register(fullName, email, password, {role?})
- Gestion du rôle dans l'appel API
```

## 🎨 Design de la Sélection de Rôle

### Options Visuelles
- **Patient** : 
  - Icône : `health_and_safety_outlined`
  - Couleur : Vert
  - Label : "Patient"

- **Doctor** :
  - Icône : `medical_services_outlined`
  - Couleur : Bleu
  - Label : "Doctor"

### État Visuel
- **Non sélectionné** : Fond gris clair, bordure grise
- **Sélectionné** : Fond coloré (10% opacité), bordure colorée (2px), icône check

## 🔐 Validation

### Champs
- **Full Name** : Requis, minimum 2 caractères
- **Email** : Requis, format email valide
- **Role** : Requis (validation avant soumission)
- **Password** : Requis, minimum 6 caractères
- **Confirm Password** : Requis, doit correspondre au password

### Messages d'Erreur
- Messages clairs et contextuels
- Affichage via SnackBar
- Validation en temps réel

## 🚀 Flux d'Inscription

1. L'utilisateur remplit le formulaire
2. Sélectionne un rôle (Patient ou Doctor)
3. Validation côté client
4. Appel API via `AuthProvider.register()`
5. POST `/api/auth/register` avec :
   ```json
   {
     "fullName": "...",
     "email": "...",
     "password": "...",
     "role": "PATIENT" ou "DOCTOR"
   }
   ```
6. Réception du token JWT
7. Stockage sécurisé dans `SharedPreferences`
8. Redirection vers `HomeScreen`

## 📝 Notes Backend

### RegisterRequest
Le backend accepte maintenant un champ `role` optionnel :
- Si fourni : utilise le rôle spécifié
- Si non fourni : défaut à `PATIENT`

### Exemple de Requête
```json
{
  "fullName": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "role": "DOCTOR"
}
```

## 🎯 Utilisation

```dart
// Navigation vers Register
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const RegisterScreen()),
);

// Ou via route nommée
Navigator.pushNamed(context, AppRoutes.register);
```

## ✨ Améliorations Futures

- [ ] Validation côté serveur pour le rôle
- [ ] Restrictions de rôle (ex: seulement admin peut créer DOCTOR)
- [ ] Vérification email avant inscription
- [ ] Indicateur de force du mot de passe
- [ ] Conditions d'utilisation / Politique de confidentialité

