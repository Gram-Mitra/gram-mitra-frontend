import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

/// API Endpoints mapping 1-to-1 to the Gram Mitra Node.js / Express backend
class ApiEndpoints {
  /// Resolves standard development host for local emulator or web/desktop
  static String get defaultHost {
    if (kIsWeb) return 'http://100.26.205.34:30442';
    try {
      if (Platform.isAndroid) {
        // Standard Android emulator loopback alias
        return 'http://100.26.205.34:30442';
      }
    } catch (_) {}
    return 'http://100.26.205.34:30442';
  }

  static String baseUrl = defaultHost;

  // Authentication & Unified Profiles (Supabase)
  static String get authRegister => '$baseUrl/api/v1/auth/register';
  static String get authLogin => '$baseUrl/api/v1/auth/login';
  static String get authMe => '$baseUrl/api/v1/auth/me';
  static String get authLogout => '$baseUrl/api/v1/auth/logout';

  // Superstitions / Daily Insights (Myth vs Fact)
  static String get superstitionsRandom => '$baseUrl/api/v1/superstitions/random';
  static String get superstitions => '$baseUrl/api/v1/superstitions';

  // Healthcare & Veterinary (Human & Animal Facilities + Helplines)
  static String get healthcareFacilities => '$baseUrl/api/v1/healthcare';
  static String get healthcareHospitals => '$baseUrl/api/v1/healthcare/hospitals';
  static String get healthcareVeterinary => '$baseUrl/api/v1/healthcare/veterinary';
  static String get healthcareEmergency => '$baseUrl/api/v1/healthcare/emergency';
  static String get healthcareServices => '$baseUrl/api/v1/healthcare/services';

  // Government Schemes & data.gov.in PM-KISAN
  static String get schemesCatalog => '$baseUrl/api/v1/schemes/catalog';
  static String get schemesLive => '$baseUrl/api/v1/schemes';
  static String get schemesStats => '$baseUrl/api/v1/schemes/stats';
  static String get ngos => '$baseUrl/api/v1/ngos';

  // Farmer Marketplace
  static String get marketplaceProducts => '$baseUrl/api/v1/marketplace/products';
  static String get marketplaceCategories => '$baseUrl/api/v1/marketplace/categories';
  static String get marketplaceOrders => '$baseUrl/api/v1/marketplace/orders';

  // Village Problems & Grievances
  static String get villageProblems => '$baseUrl/api/v1/village-problems';
  static String get villageProblemsStats => '$baseUrl/api/v1/village-problems/stats';

  // AI Voice Assistant & Mentor
  static String get voiceQuery => '$baseUrl/api/v1/voice/query';
  static String get voiceConfig => '$baseUrl/api/v1/voice/config';
  static String get voiceSession => '$baseUrl/api/v1/voice/session';
}
