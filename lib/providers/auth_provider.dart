import 'package:flutter/material.dart';
import '../core/storage/storage_service.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  UserProfile? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserProfile? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null && StorageService.getAuthToken() != null;

  AuthProvider() {
    _initSession();
  }

  void _initSession() {
    _user = StorageService.getUserProfile();
  }

  Future<bool> checkSession() async {
    final token = StorageService.getAuthToken();
    if (token == null || token.isEmpty) {
      _user = null;
      notifyListeners();
      return false;
    }

    _user = StorageService.getUserProfile();
    try {
      final remoteProfile = await AuthService.getMe();
      if (remoteProfile != null) {
        _user = remoteProfile;
      }
    } catch (_) {}

    notifyListeners();
    return _user != null;
  }

  Future<bool> login({
    required String identifier,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final session = await AuthService.login(
        identifier: identifier,
        password: password,
      );
      if (session != null) {
        _user = session.user;
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  /// Strictly passes the existing database fields to the backend
  Future<bool> register({
    required String password,
    String? phone,
    String? email,
    String? fullName,
    int? age,
    String? state,
    String? district,
    String? village,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final session = await AuthService.register(
        password: password,
        phone: phone,
        email: email,
        fullName: fullName,
        age: age,
        state: state,
        district: district,
        village: village,
      );
      if (session != null) {
        _user = session.user;
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await AuthService.logout();
    _user = null;
    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
