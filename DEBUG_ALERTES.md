# 🔧 Guide de Débogage des Alertes

## Problème : Les alertes ne sont pas créées automatiquement

### ✅ Corrections Appliquées

1. **Logs détaillés ajoutés** dans `EmotionService.createEmotionAlert()`
2. **Gestion d'erreurs améliorée** avec messages spécifiques
3. **Confirmation visuelle** pour le patient après détection

---

## 🔍 Vérifications à Faire

### 1. Vérifier les Logs Backend

Après qu'un patient capture une émotion, vérifiez les logs Spring Boot :

**Logs attendus** :
```
🔔 Attempting to create alert for patient {id} - emotion: {TYPE}
📤 Creating alert with message: {message}
✅ Real-time alert CREATED SUCCESSFULLY! Alert ID: {id} for patient {id}
```

**Si vous voyez des erreurs** :
```
❌ Entity not found while creating alert...
❌ Runtime error while creating alert...
⚠️ WARNING: No doctor available in the system!
```

### 2. Vérifier qu'un Médecin Existe

**Problème courant** : Aucun médecin dans le système

**Solution** :
```sql
-- Vérifier les médecins
SELECT * FROM users WHERE role = 'DOCTOR';

-- Si aucun médecin, en créer un via l'API ou directement en base
```

**Via l'API** :
```
POST /api/auth/register
{
  "fullName": "Dr. Smith",
  "email": "doctor@example.com",
  "password": "Password123!",
  "role": "DOCTOR"
}
```

### 3. Vérifier l'Assignation Patient-Médecin

**Vérifier si le patient est assigné à un médecin** :
```sql
SELECT 
  u.id as patient_id,
  u.full_name as patient_name,
  d.id as doctor_id,
  d.full_name as doctor_name
FROM users u
LEFT JOIN doctor_patient_assignments dpa ON u.id = dpa.patient_id
LEFT JOIN users d ON dpa.doctor_id = d.id
WHERE u.role = 'PATIENT' AND u.id = {patient_id};
```

**Si aucun médecin assigné** :
- L'alerte sera envoyée au premier médecin disponible
- Mais il faut qu'au moins un médecin existe !

### 4. Vérifier la Base de Données

**Vérifier si les alertes sont créées** :
```sql
-- Voir toutes les alertes
SELECT * FROM alerts ORDER BY created_at DESC LIMIT 10;

-- Voir les alertes non lues d'un médecin
SELECT * FROM alerts 
WHERE doctor_id = {doctor_id} 
AND is_read = false 
ORDER BY created_at DESC;
```

### 5. Vérifier le Frontend

**Confirmation visuelle** :
- Après capture d'émotion, le patient doit voir :
  - ✅ "Emotion détectée et enregistrée !"
  - ✅ "Une alerte a été envoyée automatiquement à votre médecin"

**Si cette confirmation n'apparaît pas** :
- Vérifier que `detectEmotionFromBase64()` retourne `success = true`
- Vérifier les logs Flutter pour les erreurs

---

## 🐛 Problèmes Courants et Solutions

### Problème 1 : "No doctor available in the system"

**Symptôme** : Logs montrent `⚠️ WARNING: No doctor available`

**Solution** :
1. Créer un compte médecin via l'API d'inscription
2. Vérifier que le rôle est bien `DOCTOR`
3. Réessayer la détection d'émotion

### Problème 2 : Alerte créée mais pas visible dans le dashboard

**Vérifications** :
1. Le médecin est-il connecté avec le bon compte ?
2. Le polling est-il actif ? (`alertProvider.isPolling`)
3. Vérifier les logs réseau dans Flutter DevTools
4. Vérifier que l'API `/alerts/doctor/{id}/unread` retourne les alertes

### Problème 3 : Alerte en double

**Cause** : Délai anti-spam trop court ou logique défaillante

**Solution** :
- Vérifier que le délai de 30 secondes est respecté
- Vérifier les logs pour voir si l'alerte est bien détectée comme duplicate

### Problème 4 : Exception silencieuse

**Symptôme** : Aucun log d'erreur mais aucune alerte créée

**Solution** :
- Vérifier les logs complets (pas seulement ERROR, mais aussi DEBUG)
- Vérifier que `createEmotionAlert()` est bien appelée
- Ajouter un breakpoint dans `createEmotionAlert()` pour déboguer

---

## 🧪 Test Manuel

### Test 1 : Créer une Alerte

1. **Créer un médecin** (si pas déjà fait)
2. **Créer un patient** (si pas déjà fait)
3. **Assigner le patient au médecin** (optionnel, mais recommandé)
4. **Se connecter en tant que patient**
5. **Capturer une émotion**
6. **Vérifier les logs backend** :
   ```
   ✅ Real-time alert CREATED SUCCESSFULLY!
   ```
7. **Vérifier la base de données** :
   ```sql
   SELECT * FROM alerts ORDER BY created_at DESC LIMIT 1;
   ```
8. **Se connecter en tant que médecin**
9. **Ouvrir le dashboard**
10. **Vérifier que l'alerte apparaît** (dans les 10 secondes)

### Test 2 : Vérifier le Polling

1. **Ouvrir le dashboard médecin**
2. **Ouvrir Flutter DevTools → Network**
3. **Observer les requêtes** :
   - Doit voir `GET /alerts/doctor/{id}/unread` toutes les 10 secondes
4. **Capturer une nouvelle émotion en tant que patient**
5. **Observer** : La nouvelle alerte doit apparaître dans les 10 secondes

---

## 📊 Logs à Surveiller

### Backend (Spring Boot)

**Logs de succès** :
```
INFO  - 🔔 Attempting to create alert for patient 1 - emotion: SAD
INFO  - 📤 Creating alert with message: New emotion detected: Patient John Doe...
INFO  - ✅ Real-time alert CREATED SUCCESSFULLY! Alert ID: 5 for patient 1
```

**Logs d'erreur** :
```
ERROR - ❌ Entity not found while creating alert for patient 1: Patient not found
ERROR - ❌ Runtime error while creating alert for patient 1: No doctor available
WARN  - ⚠️ WARNING: No doctor available in the system!
```

### Frontend (Flutter)

**Console logs** :
- Vérifier les erreurs réseau
- Vérifier les réponses API
- Vérifier les erreurs de parsing JSON

---

## 🔧 Commandes SQL Utiles

### Voir toutes les alertes récentes
```sql
SELECT 
  a.id,
  a.message,
  a.created_at,
  a.is_read,
  p.full_name as patient_name,
  d.full_name as doctor_name
FROM alerts a
JOIN users p ON a.patient_id = p.id
JOIN users d ON a.doctor_id = d.id
ORDER BY a.created_at DESC
LIMIT 20;
```

### Compter les alertes par médecin
```sql
SELECT 
  d.full_name as doctor_name,
  COUNT(*) as total_alerts,
  SUM(CASE WHEN a.is_read = false THEN 1 ELSE 0 END) as unread_alerts
FROM alerts a
JOIN users d ON a.doctor_id = d.id
GROUP BY d.id, d.full_name;
```

### Voir les alertes d'aujourd'hui
```sql
SELECT * FROM alerts 
WHERE DATE(created_at) = CURDATE()
ORDER BY created_at DESC;
```

---

## ✅ Checklist de Vérification

Avant de dire que ça ne marche pas, vérifiez :

- [ ] Au moins un médecin existe dans le système
- [ ] Le patient est créé et peut se connecter
- [ ] La détection d'émotion fonctionne (l'émotion est sauvegardée)
- [ ] Les logs backend montrent la tentative de création d'alerte
- [ ] Aucune erreur dans les logs backend
- [ ] L'alerte est présente dans la table `alerts`
- [ ] Le médecin peut se connecter
- [ ] Le dashboard médecin charge les alertes
- [ ] Le polling est actif (vérifier dans Flutter DevTools)
- [ ] La confirmation apparaît pour le patient après détection

---

## 🚀 Si Rien Ne Fonctionne

1. **Vérifier la connexion à la base de données**
2. **Vérifier que Spring Boot démarre sans erreur**
3. **Vérifier que Flutter peut communiquer avec le backend**
4. **Vérifier les logs complets (backend + frontend)**
5. **Tester avec un patient et un médecin fraîchement créés**
6. **Vérifier que les endpoints API sont accessibles**

---

## 📞 Support

Si le problème persiste après toutes ces vérifications :
1. Copier les logs backend complets
2. Copier les logs Flutter
3. Copier les résultats des requêtes SQL
4. Vérifier la configuration de la base de données

