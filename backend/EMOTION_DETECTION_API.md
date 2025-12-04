# 🎭 API de Détection d'Émotions

## 📡 API Utilisée

Le projet utilise **Hugging Face Inference API** pour la détection d'émotions à partir d'images.

### 🔗 Détails de l'API

- **Service** : Hugging Face Inference API
- **Modèle** : `j-hartmann/emotion-english-distilroberta-base`
- **URL** : `https://api-inference.huggingface.co/models/j-hartmann/emotion-english-distilroberta-base`
- **Type** : API REST
- **Authentification** : Bearer Token (optionnel)

### 📋 Modèle de Machine Learning

**Modèle** : `j-hartmann/emotion-english-distilroberta-base`

- **Type** : DistilRoBERTa (version légère de RoBERTa)
- **Tâche** : Classification d'émotions en anglais
- **Émotions détectées** :
  - 😊 **HAPPY** (Joie)
  - 😢 **SAD** (Tristesse)
  - 😠 **ANGRY** (Colère)
  - 😨 **FEAR** (Peur)
  - 😐 **NEUTRAL** (Neutre)

### 🔧 Configuration

L'API est configurée dans `application.properties` :

```properties
# Emotion Detection API Configuration
emotion.api.url=https://api-inference.huggingface.co/models/j-hartmann/emotion-english-distilroberta-base
emotion.api.key=${EMOTION_API_KEY:}
emotion.api.enabled=${EMOTION_API_ENABLED:true}
```

### 🔑 Clé API (Optionnelle)

**Note** : La clé API est **optionnelle** pour Hugging Face Inference API. Cependant, avec une clé API :

- ✅ **Avantages** :
  - Pas de limite de taux (rate limiting)
  - Réponses plus rapides
  - Accès prioritaire
  - Plus de stabilité

- ⚠️ **Sans clé API** :
  - Limite de taux (rate limiting)
  - Peut être plus lent
  - Peut retourner des erreurs si le modèle n'est pas chargé

### 📝 Comment Obtenir une Clé API Hugging Face

1. Créer un compte sur [Hugging Face](https://huggingface.co/)
2. Aller dans [Settings > Access Tokens](https://huggingface.co/settings/tokens)
3. Créer un nouveau token avec les permissions "Read"
4. Copier le token
5. Configurer dans `application.properties` ou variable d'environnement :
   ```properties
   emotion.api.key=VOTRE_CLE_API
   ```

Ou via variable d'environnement :
```bash
export EMOTION_API_KEY=VOTRE_CLE_API
```

### 🔄 Fonctionnement

1. **Réception d'image** : L'application reçoit une image (fichier ou base64)
2. **Conversion** : L'image est convertie en base64
3. **Appel API** : Requête POST vers l'API Hugging Face avec l'image encodée
4. **Traitement** : Le modèle analyse l'image et retourne les scores d'émotions
5. **Parsing** : Les résultats sont parsés et mappés vers `EmotionTypeEnum`
6. **Retour** : L'émotion dominante avec son score de confiance est retournée

### 📊 Format de Réponse

L'API Hugging Face retourne généralement un format comme :

```json
[
  {
    "label": "sadness",
    "score": 0.85
  },
  {
    "label": "joy",
    "score": 0.10
  },
  ...
]
```

Le service parse cette réponse et la convertit en :

```json
{
  "emotion": "SAD",
  "confidence": 0.85,
  "emotions": {
    "HAPPY": 0.10,
    "SAD": 0.85,
    "ANGRY": 0.03,
    "FEAR": 0.01,
    "NEUTRAL": 0.01
  }
}
```

### 🛡️ Gestion d'Erreurs

Le service implémente un système de **fallback** :

1. **Si l'API est désactivée** : Retourne une réponse mock
2. **Si l'API échoue** : Retourne une réponse mock avec des valeurs par défaut
3. **Si le parsing échoue** : Retourne "NEUTRAL" avec confiance 0.5

### 🧪 Mode Mock

Pour tester sans l'API, vous pouvez :

1. **Désactiver l'API** dans `application.properties` :
   ```properties
   emotion.api.enabled=false
   ```

2. **Ou via variable d'environnement** :
   ```bash
   export EMOTION_API_ENABLED=false
   ```

### 🔗 Ressources

- **Hugging Face** : https://huggingface.co/
- **Modèle** : https://huggingface.co/j-hartmann/emotion-english-distilroberta-base
- **Documentation API** : https://huggingface.co/docs/api-inference/index
- **Inference API** : https://huggingface.co/inference-api

### 💡 Alternatives

Si vous souhaitez utiliser une autre API de détection d'émotions, vous pouvez :

1. **Modifier l'URL** dans `application.properties`
2. **Adapter le parser** dans `EmotionDetectionService.parseAPIResponse()`
3. **Configurer l'authentification** si nécessaire

**Autres APIs populaires** :
- Google Cloud Vision API
- AWS Rekognition
- Microsoft Azure Face API
- Face++ API
- Kairos API

### 📝 Notes Importantes

⚠️ **Important** : Le modèle `j-hartmann/emotion-english-distilroberta-base` est conçu pour analyser du **texte**, pas des images. Pour la détection d'émotions faciales à partir d'images, vous devriez utiliser un modèle de vision comme :

- `j-hartmann/emotion-english-distilroberta-base` (texte)
- Modèles de vision pour images (à rechercher sur Hugging Face)

**Recommandation** : Pour la détection d'émotions faciales, considérez utiliser un modèle spécialisé en vision comme ceux de la catégorie "image-classification" sur Hugging Face.

