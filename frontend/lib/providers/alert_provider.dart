import 'package:flutter/foundation.dart';
import '../models/alert_model.dart';
import '../services/api_service.dart';

class AlertProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _errorMessage;
  List<AlertModel> _alerts = [];
  List<AlertModel> _unreadAlerts = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<AlertModel> get alerts => _alerts;
  List<AlertModel> get unreadAlerts => _unreadAlerts;
  int get unreadCount => _unreadAlerts.length;

  Future<bool> loadAlertsByDoctorId(int doctorId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getAlertsByDoctorId(doctorId);
      
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data as List<dynamic>;
        _alerts = data.map((json) => AlertModel.fromJson(json as Map<String, dynamic>)).toList();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Failed to load alerts';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Failed to load alerts. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> loadUnreadAlertsByDoctorId(int doctorId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getUnreadAlertsByDoctorId(doctorId);
      
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data as List<dynamic>;
        _unreadAlerts = data.map((json) => AlertModel.fromJson(json as Map<String, dynamic>)).toList();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Failed to load unread alerts';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Failed to load unread alerts. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> markAlertAsRead(int alertId) async {
    try {
      final response = await _apiService.markAlertAsRead(alertId);
      
      if (response.statusCode == 200) {
        // Update local state
        final alert = _alerts.firstWhere((a) => a.id == alertId);
        final index = _alerts.indexOf(alert);
        _alerts[index] = AlertModel(
          id: alert.id,
          message: alert.message,
          createdAt: alert.createdAt,
          isRead: true,
          patientId: alert.patientId,
          patientName: alert.patientName,
          doctorId: alert.doctorId,
          doctorName: alert.doctorName,
        );
        
        // Remove from unread list
        _unreadAlerts.removeWhere((a) => a.id == alertId);
        
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

