import 'package:flutter/material.dart';
import '../core/storage/storage_service.dart';
import '../models/iot_sensor.dart';

class AppStateProvider extends ChangeNotifier {
  String _currentLanguage = 'en';
  bool _isDarkMode = false;
  IotSensorData _iotData = IotSensorData();

  String get currentLanguage => _currentLanguage;
  bool get isDarkMode => _isDarkMode;
  IotSensorData get iotData => _iotData;

  AppStateProvider() {
    _loadInitialState();
  }

  void _loadInitialState() {
    _currentLanguage = StorageService.getLanguage() ?? 'en';
    _isDarkMode = StorageService.getIsDarkMode();
  }

  Future<void> setLanguage(String code) async {
    _currentLanguage = code;
    await StorageService.setLanguage(code);
    notifyListeners();
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
