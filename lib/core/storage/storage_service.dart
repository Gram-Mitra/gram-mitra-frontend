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

  // Language
  static String? getLanguage() => prefs.getString(_keyLanguage);
  static Future<bool> setLanguage(String code) => prefs.setString(_keyLanguage, code);

  // Auth Token
  static String? getAuthToken() => prefs.getString(_keyAuthToken);
  static Future<bool> setAuthToken(String token) => prefs.setString(_keyAuthToken, token);
  static Future<bool> clearAuthToken() => prefs.remove(_keyAuthToken);

  // User Profile
  static UserProfile? getUserProfile() {
    final raw = prefs.getString(_keyUserProfile);
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return UserProfile.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  static Future<bool> setUserProfile(UserProfile profile) {
    return prefs.setString(_keyUserProfile, jsonEncode(profile.toJson()));
  }

  static Future<bool> clearUserProfile() => prefs.remove(_keyUserProfile);

  // Theme mode
  static bool getIsDarkMode() => prefs.getBool(_keyIsDarkMode) ?? false;
  static Future<bool> setIsDarkMode(bool isDark) => prefs.setBool(_keyIsDarkMode, isDark);

  // Full session logout
  static Future<void> clearSession() async {
    await clearAuthToken();
    await clearUserProfile();
  }
}
