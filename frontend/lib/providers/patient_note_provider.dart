import 'package:flutter/foundation.dart';
import '../models/patient_note_model.dart';
import '../services/api_service.dart';
import '../services/api_exception.dart';

class PatientNoteProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _errorMessage;
  List<PatientNoteModel> _notes = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<PatientNoteModel> get notes => _notes;

  Future<bool> loadNotesByPatientId(int patientId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getPatientNotes(patientId);
      
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data as List<dynamic>;
        _notes = data.map((json) => PatientNoteModel.fromJson(json as Map<String, dynamic>)).toList();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Failed to load notes';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Failed to load notes. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> createNote(int patientId, String note) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.createPatientNote(patientId, note);
      
      if (response.statusCode == 201 && response.data != null) {
        final newNote = PatientNoteModel.fromJson(response.data as Map<String, dynamic>);
        _notes.insert(0, newNote);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Failed to create note';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Failed to create note. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateNote(int noteId, String note) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.updatePatientNote(noteId, note);
      
      if (response.statusCode == 200 && response.data != null) {
        final updatedNote = PatientNoteModel.fromJson(response.data as Map<String, dynamic>);
        final index = _notes.indexWhere((n) => n.id == noteId);
        if (index != -1) {
          _notes[index] = updatedNote;
        }
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Failed to update note';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Failed to update note. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteNote(int noteId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.deletePatientNote(noteId);
      
      if (response.statusCode == 200) {
        _notes.removeWhere((n) => n.id == noteId);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Failed to delete note';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Failed to delete note. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

