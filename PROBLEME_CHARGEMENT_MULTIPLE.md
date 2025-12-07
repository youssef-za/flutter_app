# 🐛 Problème : Chargements Multiples et Erreurs setState()

## 📋 Description du Problème

Votre application Flutter charge les données plusieurs fois, causant :
- ⚠️ Ralentissements (lag)
- ⚠️ Erreurs "setState() or markNeedsBuild() called during build"
- ⚠️ Appels API multiples inutiles
- ⚠️ Consommation excessive de ressources

---

## 🔍 Causes Identifiées dans Votre Code

### Problème 1 : `addPostFrameCallback()` appelé à chaque rebuild

**Fichier** : `doctor_dashboard_tab.dart`

```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _loadData(); // ❌ Peut être appelé plusieurs fois
    _startRealTimePolling();
  });
}
```

**Problème** : Si le widget est reconstruit, `addPostFrameCallback` peut être appelé plusieurs fois, déclenchant plusieurs chargements.

### Problème 2 : Pas de protection contre les chargements simultanés

**Fichier** : `doctor_dashboard_tab.dart`

```dart
Future<void> _loadData() async {
  // ❌ Aucune vérification si un chargement est déjà en cours
  await Future.wait([
    patientProvider.loadPatients(),
    alertProvider.loadAlertsByDoctorId(doctorId),
    alertProvider.loadUnreadAlertsByDoctorId(doctorId),
  ]);
}
```

**Problème** : Si `_loadData()` est appelé plusieurs fois rapidement, plusieurs requêtes API sont lancées simultanément.

### Problème 3 : `_applyFilters()` appelle `setState()` dans un listener

**Fichier** : `doctor_dashboard_tab.dart`

```dart
void _onSearchChanged() {
  setState(() {
    _searchQuery = _searchController.text.toLowerCase();
    _applyFilters(); // ❌ Appelé pendant setState()
  });
}
```

**Problème** : `_applyFilters()` appelle aussi `setState()`, ce qui peut causer des conflits.

### Problème 4 : `_getTabs()` recrée les widgets à chaque build

**Fichier** : `home_screen.dart`

```dart
@override
Widget build(BuildContext context) {
  return IndexedStack(
    children: _getTabs(), // ❌ Recrée les tabs à chaque build
  );
}
```

**Problème** : Chaque rebuild recrée les tabs, déclenchant leurs `initState()` à nouveau.

### Problème 5 : Polling qui déclenche des notifyListeners() multiples

**Fichier** : `alert_provider.dart`

```dart
_pollingTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
  loadUnreadAlertsByDoctorId(_currentDoctorId!, silent: true);
  // ❌ notifyListeners() appelé toutes les 10 secondes
});
```

**Problème** : Le polling peut déclencher des rebuilds même si les données n'ont pas changé.

---

## ✅ Solutions Complètes

### Solution 1 : Ajouter un flag pour éviter les chargements multiples

**Fichier** : `doctor_dashboard_tab.dart`

```dart
class _DoctorDashboardTabState extends State<DoctorDashboardTab> {
  bool _isLoading = false;
  bool _hasInitialized = false; // ✅ Nouveau flag
  
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasInitialized) { // ✅ Vérifier avant de charger
        _hasInitialized = true;
        _loadData();
        _startRealTimePolling();
      }
    });
  }

  Future<void> _loadData() async {
    if (_isLoading) return; // ✅ Éviter les chargements simultanés
    
    _isLoading = true;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser != null) {
      final doctorId = authProvider.currentUser!.id;
      
      final patientProvider = Provider.of<PatientProvider>(context, listen: false);
      final alertProvider = Provider.of<AlertProvider>(context, listen: false);
      
      try {
        await Future.wait([
          patientProvider.loadPatients(),
          alertProvider.loadAlertsByDoctorId(doctorId),
          alertProvider.loadUnreadAlertsByDoctorId(doctorId),
        ]);
        
        if (mounted) {
          _applyFilters();
          
          // Ensure real-time polling is active
          if (!alertProvider.isPolling) {
            alertProvider.startRealTimePolling(doctorId);
          }
        }
      } finally {
        if (mounted) {
          _isLoading = false;
        }
      }
    }
  }
}
```

### Solution 2 : Débouncer les recherches

**Fichier** : `doctor_dashboard_tab.dart`

```dart
import 'dart:async';

class _DoctorDashboardTabState extends State<DoctorDashboardTab> {
  Timer? _searchDebounce; // ✅ Timer pour débouncer
  
  void _onSearchChanged() {
    // ✅ Annuler le timer précédent
    _searchDebounce?.cancel();
    
    // ✅ Créer un nouveau timer (attendre 300ms après la dernière frappe)
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _searchQuery = _searchController.text.toLowerCase();
        });
        _applyFilters(); // Appeler après setState()
      }
    });
  }
  
  void _applyFilters() {
    final patientProvider = Provider.of<PatientProvider>(context, listen: false);
    List<UserModel> filtered = List.from(patientProvider.patients);
    
    // ... logique de filtrage ...
    
    if (mounted) {
      setState(() {
        _filteredPatients = filtered;
      });
    }
  }
  
  @override
  void dispose() {
    _searchDebounce?.cancel(); // ✅ Nettoyer le timer
    _searchController.dispose();
    _stopRealTimePolling();
    super.dispose();
  }
}
```

### Solution 3 : Mémoriser les tabs dans `HomeScreen`

**Fichier** : `home_screen.dart`

```dart
class _HomeScreenState extends State<HomeScreen> {
  late int _currentIndex;
  List<Widget>? _cachedTabs; // ✅ Cache des tabs
  
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab ?? 0;
  }

  List<Widget> _getTabs() {
    // ✅ Retourner les tabs en cache si disponibles
    if (_cachedTabs != null) {
      return _cachedTabs!;
    }
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isPatient = authProvider.currentUser?.role == 'PATIENT';

    _cachedTabs = isPatient
        ? [
            const PatientDashboardTab(),
            const HistoryTab(),
            const ProfileTab(),
          ]
        : [
            const DoctorDashboardTab(),
            const HistoryTab(),
            const ProfileTab(),
          ];
    
    return _cachedTabs!;
  }
  
  // ✅ Invalider le cache si nécessaire (par exemple, après logout/login)
  void _invalidateTabsCache() {
    _cachedTabs = null;
  }
}
```

### Solution 4 : Optimiser le Provider pour éviter les notifyListeners() inutiles

**Fichier** : `alert_provider.dart`

```dart
Future<bool> loadUnreadAlertsByDoctorId(int doctorId, {bool silent = false}) async {
  if (!silent) {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
  }

  try {
    final response = await _apiService.getUnreadAlertsByDoctorId(doctorId);
    
    if (response.statusCode == 200 && response.data != null) {
      final List<dynamic> data = response.data as List<dynamic>;
      final newAlerts = data.map((json) => AlertModel.fromJson(json as Map<String, dynamic>)).toList();
      
      // ✅ Vérifier si les données ont vraiment changé
      if (!_listsEqual(_unreadAlerts, newAlerts)) {
        _unreadAlerts = newAlerts;
        if (!silent) {
          _isLoading = false;
        }
        notifyListeners(); // ✅ Notifier seulement si les données ont changé
      } else {
        if (!silent) {
          _isLoading = false;
        }
        // ✅ Ne pas notifier si les données sont identiques
      }
      return true;
    } else {
      if (!silent) {
        _errorMessage = 'Failed to load unread alerts';
        _isLoading = false;
        notifyListeners();
      }
      return false;
    }
  } catch (e) {
    if (!silent) {
      _errorMessage = 'Failed to load unread alerts. Please try again.';
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }
}

// ✅ Helper pour comparer les listes
bool _listsEqual(List<AlertModel> list1, List<AlertModel> list2) {
  if (list1.length != list2.length) return false;
  for (int i = 0; i < list1.length; i++) {
    if (list1[i].id != list2[i].id || list1[i].isRead != list2[i].isRead) {
      return false;
    }
  }
  return true;
}
```

### Solution 5 : Utiliser `AutomaticKeepAliveClientMixin` pour préserver l'état

**Fichier** : `doctor_dashboard_tab.dart`

```dart
class _DoctorDashboardTabState extends State<DoctorDashboardTab> 
    with AutomaticKeepAliveClientMixin { // ✅ Préserver l'état
  
  @override
  bool get wantKeepAlive => true; // ✅ Garder l'état en vie
  
  @override
  Widget build(BuildContext context) {
    super.build(context); // ✅ Nécessaire avec AutomaticKeepAliveClientMixin
    
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        // ... reste du code ...
      ),
    );
  }
}
```

---

## 🔧 Corrections Complètes à Appliquer

### Correction 1 : `doctor_dashboard_tab.dart` (Complet)

```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ... autres imports ...

class _DoctorDashboardTabState extends State<DoctorDashboardTab> 
    with AutomaticKeepAliveClientMixin {
  
  final TextEditingController _searchController = TextEditingController();
  FilterPeriod _selectedFilter = FilterPeriod.all;
  String? _sortBy = 'recent';
  List<UserModel> _filteredPatients = [];
  String _searchQuery = '';
  
  // ✅ Flags pour éviter les chargements multiples
  bool _isLoading = false;
  bool _hasInitialized = false;
  Timer? _searchDebounce;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasInitialized && mounted) {
        _hasInitialized = true;
        _loadData();
        _startRealTimePolling();
      }
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _stopRealTimePolling();
    super.dispose();
  }

  void _startRealTimePolling() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser != null && authProvider.currentUser!.isDoctor) {
      final alertProvider = Provider.of<AlertProvider>(context, listen: false);
      alertProvider.startRealTimePolling(authProvider.currentUser!.id);
    }
  }

  void _stopRealTimePolling() {
    final alertProvider = Provider.of<AlertProvider>(context, listen: false);
    alertProvider.stopPolling();
  }

  void _onSearchChanged() {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _searchQuery = _searchController.text.toLowerCase();
        });
        _applyFilters();
      }
    });
  }

  void _applyFilters() {
    final patientProvider = Provider.of<PatientProvider>(context, listen: false);
    List<UserModel> filtered = List.from(patientProvider.patients);
    
    // ... logique de filtrage existante ...
    
    if (mounted) {
      setState(() {
        _filteredPatients = filtered;
      });
    }
  }

  Future<void> _loadData() async {
    if (_isLoading) return; // ✅ Éviter les chargements simultanés
    
    _isLoading = true;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser != null) {
      final doctorId = authProvider.currentUser!.id;
      
      final patientProvider = Provider.of<PatientProvider>(context, listen: false);
      final alertProvider = Provider.of<AlertProvider>(context, listen: false);
      
      try {
        await Future.wait([
          patientProvider.loadPatients(),
          alertProvider.loadAlertsByDoctorId(doctorId),
          alertProvider.loadUnreadAlertsByDoctorId(doctorId),
        ]);
        
        if (mounted) {
          _applyFilters();
          
          if (!alertProvider.isPolling) {
            alertProvider.startRealTimePolling(doctorId);
          }
        }
      } finally {
        if (mounted) {
          _isLoading = false;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // ✅ Nécessaire avec AutomaticKeepAliveClientMixin
    
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // ... reste du code ...
        ),
      ),
    );
  }
}
```

---

## 📊 Résumé des Problèmes et Solutions

| Problème | Cause | Solution |
|----------|-------|----------|
| Chargements multiples | `addPostFrameCallback` appelé plusieurs fois | Flag `_hasInitialized` |
| Appels API simultanés | Pas de protection | Flag `_isLoading` |
| Recherche déclenche trop de rebuilds | Pas de debouncing | Timer avec 300ms de délai |
| Tabs recréés à chaque build | `_getTabs()` dans build() | Cache des tabs |
| notifyListeners() inutiles | Pas de comparaison des données | Comparer avant de notifier |
| État perdu lors du changement d'onglet | Pas de préservation | `AutomaticKeepAliveClientMixin` |

---

## ✅ Checklist de Vérification

Après avoir appliqué les corrections :

- [ ] Ajout de flags pour éviter les chargements multiples
- [ ] Debouncing pour les recherches (300ms)
- [ ] Cache des tabs dans `HomeScreen`
- [ ] Comparaison des données avant `notifyListeners()`
- [ ] `AutomaticKeepAliveClientMixin` pour préserver l'état
- [ ] Nettoyage des timers dans `dispose()`
- [ ] Vérification de `mounted` avant `setState()`

---

## 🎯 Résultat Attendu

Après ces corrections :

- ✅ **Un seul chargement** au démarrage
- ✅ **Pas d'erreurs** "setState() during build"
- ✅ **Recherche fluide** avec debouncing
- ✅ **Performance améliorée** (moins de rebuilds)
- ✅ **Pas de lag** lors du changement d'onglets
- ✅ **Économie de ressources** (moins d'appels API)

---

## 🚀 Prochaines Étapes

1. Appliquer les corrections une par une
2. Tester chaque correction individuellement
3. Vérifier les logs pour confirmer qu'il n'y a plus de chargements multiples
4. Monitorer les performances avec Flutter DevTools

Ces corrections devraient résoudre complètement vos problèmes de chargements multiples et d'erreurs setState() ! 🎉

