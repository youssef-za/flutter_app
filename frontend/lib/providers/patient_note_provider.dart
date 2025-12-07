import 'package:flutter/foundation.dart';
import '../models/patient_note_model.dart';
import '../services/api_service.dart';
import '../services/api_exception.dart';

class PatientNoteProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _errorMessage;
  List<PatientNoteModel> _notes = [];
  
  // Protection contre les chargements simultanés
  final Map<int, bool> _loadingPatients = {}; // patientId -> isLoading
  
  // Cache pour éviter les requêtes répétées
  final Map<int, DateTime> _lastLoadTime = {}; // patientId -> last load time
  static const Duration _cacheDuration = Duration(seconds: 30); // Cache de 30 secondes

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<PatientNoteModel> get notes => _notes;
  
  // Vérifier si les notes pour un patient sont déjà chargées
  bool hasNotesForPatient(int patientId) {
    return _notes.any((note) => note.patientId == patientId);
  }
  
  // Vérifier si le cache est encore valide
  bool _isCacheValid(int patientId) {
    final lastLoad = _lastLoadTime[patientId];
    if (lastLoad == null) return false;
    return DateTime.now().difference(lastLoad) < _cacheDuration;
  }

  Future<bool> loadNotesByPatientId(int patientId, {bool forceRefresh = false}) async {
    // Éviter les chargements simultanés pour le même patient
    if (_loadingPatients[patientId] == true) {
      return false; // Déjà en cours de chargement
    }
    
    // Si le cache est valide et qu'on a déjà des notes, ne pas recharger
    if (!forceRefresh && _isCacheValid(patientId) && hasNotesForPatient(patientId)) {
      return true; // Utiliser les données en cache
    }
    
    _loadingPatients[patientId] = true;
    _isLoading = true;
    _errorMessage = null;
    
    // Notifier après le frame actuel pour éviter setState() during build
    Future.microtask(() => notifyListeners());

    try {
      final response = await _apiService.getPatientNotes(patientId);
      
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data as List<dynamic>;
        final newNotes = data.map((json) => PatientNoteModel.fromJson(json as Map<String, dynamic>)).toList();
        
        // Vérifier si les données ont vraiment changé avant de notifier
        if (!_notesEqual(_notes, newNotes)) {
          _notes = newNotes;
        }
        _isLoading = false;
        _loadingPatients[patientId] = false;
        _lastLoadTime[patientId] = DateTime.now(); // Mettre à jour le cache
        
        // Notifier après le frame actuel pour éviter setState() during build
        Future.microtask(() => notifyListeners());
        return true;
      } else {
        _errorMessage = 'Failed to load notes';
        _isLoading = false;
        _loadingPatients[patientId] = false;
        Future.microtask(() => notifyListeners());
        return false;
      }
    } catch (e) {
      _errorMessage = 'Failed to load notes. Please try again.';
      _isLoading = false;
      _loadingPatients[patientId] = false;
      Future.microtask(() => notifyListeners());
      return false;
    } finally {
      // S'assurer que le flag est toujours réinitialisé
      _loadingPatients[patientId] = false;
    }
  }
  
  // Invalider le cache pour un patient (après création/modification/suppression)
  void _invalidateCache(int patientId) {
    _lastLoadTime.remove(patientId);
  }
  
  // Helper pour comparer les listes de notes
  bool _notesEqual(List<PatientNoteModel> list1, List<PatientNoteModel> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i].id != list2[i].id || 
          list1[i].note != list2[i].note ||
          list1[i].patientId != list2[i].patientId) {
        return false;
      }
    }
    return true;
  }

  Future<bool> createNote(int patientId, String note) async {
    _isLoading = true;
    _errorMessage = null;
    Future.microtask(() => notifyListeners());

    try {
      final response = await _apiService.createPatientNote(patientId, note);
      
      if (response.statusCode == 201 && response.data != null) {
        final newNote = PatientNoteModel.fromJson(response.data as Map<String, dynamic>);
        _notes.insert(0, newNote);
        _isLoading = false;
        _invalidateCache(patientId); // Invalider le cache après création
        Future.microtask(() => notifyListeners());
        return true;
      } else {
        _errorMessage = 'Failed to create note';
        _isLoading = false;
        Future.microtask(() => notifyListeners());
        return false;
      }
    } catch (e) {
      _errorMessage = 'Failed to create note. Please try again.';
      _isLoading = false;
      Future.microtask(() => notifyListeners());
      return false;
    }
  }

  Future<bool> updateNote(int noteId, String note) async {
    _isLoading = true;
    _errorMessage = null;
    Future.microtask(() => notifyListeners());

    try {
      final response = await _apiService.updatePatientNote(noteId, note);
      
      if (response.statusCode == 200 && response.data != null) {
        final updatedNote = PatientNoteModel.fromJson(response.data as Map<String, dynamic>);
        final index = _notes.indexWhere((n) => n.id == noteId);
        if (index != -1) {
          _notes[index] = updatedNote;
          _invalidateCache(updatedNote.patientId); // Invalider le cache après modification
        }
        _isLoading = false;
        Future.microtask(() => notifyListeners());
        return true;
      } else {
        _errorMessage = 'Failed to update note';
        _isLoading = false;
        Future.microtask(() => notifyListeners());
        return false;
      }
    } catch (e) {
      _errorMessage = 'Failed to update note. Please try again.';
      _isLoading = false;
      Future.microtask(() => notifyListeners());
      return false;
    }
  }

  Future<bool> deleteNote(int noteId) async {
    _isLoading = true;
    _errorMessage = null;
    Future.microtask(() => notifyListeners());

    try {
      final response = await _apiService.deletePatientNote(noteId);
      
      if (response.statusCode == 200) {
        // Trouver la note avant de la supprimer pour obtenir le patientId
        final deletedNoteIndex = _notes.indexWhere((n) => n.id == noteId);
        if (deletedNoteIndex != -1) {
          final patientId = _notes[deletedNoteIndex].patientId;
          _notes.removeAt(deletedNoteIndex);
          _invalidateCache(patientId); // Invalider le cache après suppression
        } else {
          // Note déjà supprimée localement, supprimer quand même de la liste
          _notes.removeWhere((n) => n.id == noteId);
        }
        _isLoading = false;
        Future.microtask(() => notifyListeners());
        return true;
      } else {
        _errorMessage = 'Failed to delete note';
        _isLoading = false;
        Future.microtask(() => notifyListeners());
        return false;
      }
    } catch (e) {
      _errorMessage = 'Failed to delete note. Please try again.';
      _isLoading = false;
      Future.microtask(() => notifyListeners());
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}


