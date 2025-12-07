import 'package:flutter/foundation.dart';
import '../models/patient_tag_model.dart';
import '../services/api_service.dart';

class PatientTagProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _errorMessage;
  List<PatientTagModel> _tags = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<PatientTagModel> get tags => _tags;

  List<PatientTagModel> getTagsByPatientId(int patientId) {
    return _tags.where((tag) => tag.patientId == patientId).toList();
  }

  Future<bool> loadTagsByPatientId(int patientId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getPatientTags(patientId);
      
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data as List<dynamic>;
        _tags = data.map((json) => PatientTagModel.fromJson(json as Map<String, dynamic>)).toList();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Failed to load tags';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Failed to load tags. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> addTag(int patientId, String tag) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.addPatientTag(patientId, tag);
      
      if (response.statusCode == 201 && response.data != null) {
        final newTag = PatientTagModel.fromJson(response.data as Map<String, dynamic>);
        _tags.add(newTag);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Failed to add tag';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Failed to add tag. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeTag(int patientId, String tag) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.removePatientTag(patientId, tag);
      
      if (response.statusCode == 200) {
        _tags.removeWhere((t) => t.patientId == patientId && t.tag == tag);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Failed to remove tag';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Failed to remove tag. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeTagById(int tagId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.removePatientTagById(tagId);
      
      if (response.statusCode == 200) {
        _tags.removeWhere((t) => t.id == tagId);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Failed to remove tag';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Failed to remove tag. Please try again.';
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


