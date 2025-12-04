import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/emotion_model.dart';
import '../services/api_service.dart';

class PatientProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _errorMessage;
  List<UserModel> _patients = [];
  Map<int, EmotionModel?> _patientLatestEmotions = {};

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<UserModel> get patients => _patients;
  Map<int, EmotionModel?> get patientLatestEmotions => _patientLatestEmotions;

  EmotionModel? getLatestEmotionForPatient(int patientId) {
    return _patientLatestEmotions[patientId];
  }

  Future<bool> loadPatients() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getPatients();
      
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data as List<dynamic>;
        _patients = data
            .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
            .where((user) => user.role == 'PATIENT')
            .toList();
        
        // Load latest emotion for each patient
        await _loadLatestEmotionsForPatients();
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Failed to load patients';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Failed to load patients. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> _loadLatestEmotionsForPatients() async {
    _patientLatestEmotions.clear();
    
    for (var patient in _patients) {
      try {
        final response = await _apiService.getEmotionHistory(patient.id);
        if (response.statusCode == 200 && response.data != null) {
          final List<dynamic> data = response.data as List<dynamic>;
          if (data.isNotEmpty) {
            final emotions = data.map((json) => EmotionModel.fromJson(json as Map<String, dynamic>)).toList();
            // Get the most recent emotion (first in the list if sorted by date desc)
            _patientLatestEmotions[patient.id] = emotions.first;
          }
        }
      } catch (e) {
        // Continue if error loading emotion for one patient
      }
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

