import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_profile.dart';

class StorageService {
  static const String _keyLanguage = 'selected_language';
  static const String _keyAuthToken = 'auth_token';
  static const String _keyUserProfile = 'user_profile';
  static const String _keyIsDarkMode = 'is_dark_mode';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageService must be initialized before use');
    }
    return _prefs!;
  }

  static bool get isInitialized => _prefs != null;

  // Language
  static String? getLanguage() => _prefs?.getString(_keyLanguage);
  static Future<bool> setLanguage(String code) async => _prefs?.setString(_keyLanguage, code) ?? false;

  // Auth Token
  static String? getAuthToken() => _prefs?.getString(_keyAuthToken);
  static Future<bool> setAuthToken(String token) async => _prefs?.setString(_keyAuthToken, token) ?? false;
  static Future<bool> clearAuthToken() async => _prefs?.remove(_keyAuthToken) ?? false;

  // User Profile
  static UserProfile? getUserProfile() {
    final raw = _prefs?.getString(_keyUserProfile);
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return UserProfile.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  static Future<bool> setUserProfile(UserProfile profile) async {
    return _prefs?.setString(_keyUserProfile, jsonEncode(profile.toJson())) ?? false;
  }

  static Future<bool> clearUserProfile() async => _prefs?.remove(_keyUserProfile) ?? false;

  // Theme mode
  static bool getIsDarkMode() => _prefs?.getBool(_keyIsDarkMode) ?? false;
  static Future<bool> setIsDarkMode(bool isDark) async => _prefs?.setBool(_keyIsDarkMode, isDark) ?? false;

  // Generic helpers
  static String? getString(String key) => _prefs?.getString(key);
  static Future<bool> setString(String key, String value) async => _prefs?.setString(key, value) ?? false;
  static Future<bool> remove(String key) async => _prefs?.remove(key) ?? false;

  // Full session logout
  static Future<void> clearSession() async {
    await clearAuthToken();
    await clearUserProfile();
  }
}
