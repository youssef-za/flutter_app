# Emotion History Charts - Documentation

## ✅ Fonctionnalités Implémentées

### 1. **Graphique en Ligne (Line Chart)**
- ✅ Évolution de la confiance moyenne par jour
- ✅ Courbe lissée avec points de données
- ✅ Zone remplie sous la courbe
- ✅ Axes avec labels formatés
- ✅ Dates formatées sur l'axe X
- ✅ Pourcentages de confiance sur l'axe Y

### 2. **Graphique en Barres (Bar Chart)**
- ✅ Distribution des émotions par type
- ✅ Comptage de chaque type d'émotion
- ✅ Couleurs distinctes par type
- ✅ Labels sur les axes
- ✅ Échelle automatique

### 3. **Graphique en Secteurs (Pie Chart)**
- ✅ Répartition en pourcentage
- ✅ Légende avec compteurs
- ✅ Couleurs par type d'émotion
- ✅ Affichage des pourcentages

### 4. **Chargement depuis l'API Spring Boot**
- ✅ Utilise `EmotionProvider.loadEmotionHistory()`
- ✅ Appel GET `/api/emotions/patient/{patientId}`
- ✅ Parsing des données JSON
- ✅ Gestion des erreurs
- ✅ Pull-to-refresh

## 📋 Structure du Code

### EmotionChart Widget (`lib/widgets/emotion_chart.dart`)

```dart
- EmotionChart : Widget principal
  - _buildLineChart() : Graphique en ligne
  - _buildBarChart() : Graphique en barres
  - _buildPieChart() : Graphique en secteurs
  - _buildLegend() : Légende pour le pie chart
  - _getEmotionColor() : Couleurs par type
```

### ChartsTab (`lib/screens/home/tabs/charts_tab.dart`)

```dart
- Sélecteur de type de graphique
- Affichage conditionnel selon le type
- Chargement des données depuis l'API
- Pull-to-refresh
```

### HistoryTab (`lib/screens/home/tabs/history_tab.dart`)

```dart
- Intégration du graphique en ligne
- Affichage au-dessus de la liste
- Données chargées depuis l'API
```

## 🎨 Types de Graphiques

### Line Chart (Trend)
- **Données** : Confiance moyenne par jour
- **Visualisation** : Courbe avec points
- **Utilité** : Voir l'évolution dans le temps
- **Couleur** : Bleu avec zone remplie

### Bar Chart (Distribution)
- **Données** : Nombre d'émotions par type
- **Visualisation** : Barres verticales
- **Utilité** : Comparer les fréquences
- **Couleurs** : Par type d'émotion

### Pie Chart (Breakdown)
- **Données** : Pourcentage par type
- **Visualisation** : Secteurs circulaires
- **Utilité** : Voir la répartition globale
- **Légende** : Avec compteurs

## 📊 Traitement des Données

### Line Chart
```dart
// Groupement par date
Map<String, List<EmotionModel>> groupedByDate

// Calcul moyenne par jour
avgConfidence = sum(confidences) / count

// Création des spots
FlSpot(index, avgConfidence * 100)
```

### Bar Chart
```dart
// Comptage par type
Map<String, int> emotionCounts

// Création des barres
BarChartGroupData(x: index, barRods: [...])
```

### Pie Chart
```dart
// Comptage par type
Map<String, int> emotionCounts

// Calcul pourcentages
percentage = (count / total) * 100

// Création des sections
PieChartSectionData(value: count, ...)
```

## 🔄 Flux de Données

1. **Chargement** : `EmotionProvider.loadEmotionHistory(patientId)`
2. **API Call** : GET `/api/emotions/patient/{patientId}`
3. **Parsing** : Conversion JSON → `List<EmotionModel>`
4. **Traitement** : Groupement/Comptage selon le type de graphique
5. **Affichage** : Rendu avec fl_chart

## 🎯 Utilisation

### Dans HistoryTab
Le graphique en ligne est automatiquement affiché au-dessus de la liste.

### Dans ChartsTab (optionnel)
Onglet dédié avec sélecteur de type de graphique.

### Widget Standalone
```dart
EmotionChart(
  emotions: emotionList,
  chartType: ChartType.line, // ou bar, pie
)
```

## 📝 Notes Techniques

### fl_chart Configuration
- **LineChart** : Courbe lissée avec points et zone remplie
- **BarChart** : Barres verticales avec couleurs
- **PieChart** : Secteurs avec légende

### Formatage des Dates
- Utilise `intl` package pour le formatage
- Format court : `MM/dd` pour les axes
- Format complet : `MMM dd, yyyy` pour les détails

### Couleurs par Émotion
- **HAPPY** : Vert (Colors.green)
- **SAD** : Bleu (Colors.blue)
- **ANGRY** : Rouge (Colors.red)
- **FEAR** : Orange (Colors.orange)
- **NEUTRAL** : Gris (Colors.grey)

## ✨ Améliorations Futures

- [ ] Filtrage par période (semaine, mois, année)
- [ ] Graphique combiné (line + bar)
- [ ] Export des graphiques en image
- [ ] Animations de transition
- [ ] Zoom et pan sur les graphiques
- [ ] Statistiques détaillées (moyenne, médiane, etc.)

