import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../storage/storage_service.dart';

/// Centralized environment configuration loaded from .env file and runtime overrides
class EnvConfig {
  static const String _sarvamKeyStorageKey = 'custom_sarvam_api_key';
  static const String _ec2UrlStorageKey = 'custom_ec2_backend_url';

  static const String _defaultEc2Url = 'http://54.224.97.138:30442';
  static const String _defaultSarvamUrl = 'https://api.sarvam.ai';

  /// Initialize dotenv safely (will not throw if .env is missing or invalid)
  static Future<void> init() async {
    try {
      await dotenv.load(fileName: ".env");
      debugPrint('[EnvConfig] Successfully loaded .env file');
    } catch (e) {
      debugPrint('[EnvConfig] Note: .env file could not be loaded ($e). Using defaults/storage.');
    }
  }

  /// Backend EC2 URL
  /// Order of precedence:
  /// 1. Custom runtime override in local storage
  /// 2. EC2_BACKEND_URL from .env
  /// 3. EC2_BACKEND_URL from --dart-define
  /// 4. Default host constant (http://54.224.97.138:30442)
  static String get ec2BackendUrl {
    final customUrl = StorageService.getString(_ec2UrlStorageKey);
    if (customUrl != null && customUrl.trim().isNotEmpty) {
      return customUrl.trim();
    }

    final envUrl = dotenv.env['EC2_BACKEND_URL'];
    if (envUrl != null && envUrl.trim().isNotEmpty) {
      return envUrl.trim();
    }

    const dartDefineUrl = String.fromEnvironment('EC2_BACKEND_URL', defaultValue: '');
    if (dartDefineUrl.trim().isNotEmpty) {
      return dartDefineUrl.trim();
    }

    return _defaultEc2Url;
  }

  /// Set a runtime custom backend URL
  static Future<void> setCustomEc2BackendUrl(String url) async {
    await StorageService.setString(_ec2UrlStorageKey, url.trim());
  }

  /// Sarvam AI Subscription Key
  /// Order of precedence:
  /// 1. Custom runtime override in local storage
  /// 2. SARVAM_API_KEY from .env
  /// 3. SARVAM_API_KEY from --dart-define
  static String get sarvamApiKey {
    final storedKey = StorageService.getString(_sarvamKeyStorageKey);
    if (storedKey != null && storedKey.trim().isNotEmpty) {
      return storedKey.trim();
    }

    final envKey = dotenv.env['SARVAM_API_KEY'];
    if (envKey != null && envKey.trim().isNotEmpty && !envKey.contains('your_sarvam_api_key')) {
      return envKey.trim();
    }

    const dartDefineKey = String.fromEnvironment('SARVAM_API_KEY', defaultValue: '');
    return dartDefineKey.trim();
  }

  /// Set a runtime Sarvam API key
  static Future<void> setCustomSarvamApiKey(String key) async {
    await StorageService.setString(_sarvamKeyStorageKey, key.trim());
  }

  /// Check whether a valid Sarvam API key is configured
  static bool get hasSarvamApiKey {
    final key = sarvamApiKey;
    return key.isNotEmpty && !key.contains('your_sarvam_api_key');
  }

  /// Sarvam AI Base URL
  static String get sarvamBaseUrl {
    final envUrl = dotenv.env['SARVAM_API_URL'];
    if (envUrl != null && envUrl.trim().isNotEmpty) {
      return envUrl.trim();
    }
    return _defaultSarvamUrl;
  }
}
