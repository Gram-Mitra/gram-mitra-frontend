import 'package:flutter/material.dart';
import '../core/localization/app_translations.dart';
import '../core/storage/storage_service.dart';
import '../models/iot_sensor.dart';

class AppStateProvider extends ChangeNotifier {
  String _currentLanguage = 'en';
  bool _isDarkMode = false;
  bool _isTranslating = false;
  IotSensorData _iotData = IotSensorData();

  String get currentLanguage => _currentLanguage;
  bool get isDarkMode => _isDarkMode;
  bool get isTranslating => _isTranslating;
  IotSensorData get iotData => _iotData;

  AppStateProvider() {
    _loadInitialState();
  }

  void _loadInitialState() {
    _currentLanguage = StorageService.getLanguage() ?? 'en';
    _isDarkMode = StorageService.getIsDarkMode();
    if (_currentLanguage != 'en') {
      AppTranslations.prefetchTranslations(_currentLanguage);
    }
  }

  Future<void> setLanguage(String code) async {
    _currentLanguage = code;
    await StorageService.setLanguage(code);
    notifyListeners();

    // Prefetch translations via Sarvam AI if this language isn't statically bundled
    if (!AppTranslations.hasStaticTranslations(code)) {
      _isTranslating = true;
      notifyListeners();
      await AppTranslations.prefetchTranslations(code);
      _isTranslating = false;
      notifyListeners();
    }
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await StorageService.setIsDarkMode(_isDarkMode);
    notifyListeners();
  }

  void togglePump() {
    _iotData = _iotData.copyWith(isPumpOn: !_iotData.isPumpOn);
    notifyListeners();
  }

  void updateSoilMoisture(double moisture) {
    _iotData = _iotData.copyWith(soilMoisture: moisture);
    notifyListeners();
  }
}
