import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../core/config/env_config.dart';

class SupportedLanguage {
  final String code;
  final String sarvamCode;
  final String nativeLabel;
  final String englishLabel;
  final String region;

  const SupportedLanguage({
    required this.code,
    required this.sarvamCode,
    required this.nativeLabel,
    required this.englishLabel,
    required this.region,
  });
}

class SarvamService {
  // In-memory cache to prevent duplicate API calls: key = "$sourceLang:$targetLang:$text"
  static final Map<String, String> _translationCache = {};

  /// All supported Indian languages supported by Sarvam AI Mayura model
  static const List<SupportedLanguage> supportedLanguages = [
    SupportedLanguage(
      code: 'en',
      sarvamCode: 'en-IN',
      nativeLabel: 'English',
      englishLabel: 'English',
      region: 'Universal',
    ),
    SupportedLanguage(
      code: 'hi',
      sarvamCode: 'hi-IN',
      nativeLabel: 'हिंदी',
      englishLabel: 'Hindi',
      region: 'उत्तर भारत',
    ),
    SupportedLanguage(
      code: 'mr',
      sarvamCode: 'mr-IN',
      nativeLabel: 'मराठी',
      englishLabel: 'Marathi',
      region: 'महाराष्ट्र',
    ),
    SupportedLanguage(
      code: 'gu',
      sarvamCode: 'gu-IN',
      nativeLabel: 'ગુજરાતી',
      englishLabel: 'Gujarati',
      region: 'ગુજરાત',
    ),
    SupportedLanguage(
      code: 'te',
      sarvamCode: 'te-IN',
      nativeLabel: 'తెలుగు',
      englishLabel: 'Telugu',
      region: 'ఆంధ్రప్రదేశ్ & తెలంగాణ',
    ),
    SupportedLanguage(
      code: 'ta',
      sarvamCode: 'ta-IN',
      nativeLabel: 'தமிழ்',
      englishLabel: 'Tamil',
      region: 'தமிழ்நாடு',
    ),
    SupportedLanguage(
      code: 'bn',
      sarvamCode: 'bn-IN',
      nativeLabel: 'বাংলা',
      englishLabel: 'Bengali',
      region: 'পশ্চিমবঙ্গ',
    ),
    SupportedLanguage(
      code: 'kn',
      sarvamCode: 'kn-IN',
      nativeLabel: 'ಕನ್ನಡ',
      englishLabel: 'Kannada',
      region: 'ಕರ್ನಾಟಕ',
    ),
    SupportedLanguage(
      code: 'ml',
      sarvamCode: 'ml-IN',
      nativeLabel: 'മലയാളം',
      englishLabel: 'Malayalam',
      region: 'കേരളം',
    ),
    SupportedLanguage(
      code: 'pa',
      sarvamCode: 'pa-IN',
      nativeLabel: 'ਪੰਜਾਬੀ',
      englishLabel: 'Punjabi',
      region: 'ਪੰਜਾਬ',
    ),
    SupportedLanguage(
      code: 'od',
      sarvamCode: 'od-IN',
      nativeLabel: 'ଓଡ଼ିଆ',
      englishLabel: 'Odia',
      region: 'ଓଡ଼ିଶା',
    ),
  ];

  /// Convert standard 2-letter code to Sarvam BCP-47 language tag (e.g. 'hi' -> 'hi-IN')
  static String toSarvamLanguageCode(String code) {
    final lang = supportedLanguages.firstWhere(
      (element) => element.code == code.toLowerCase() || element.sarvamCode.toLowerCase() == code.toLowerCase(),
      orElse: () => const SupportedLanguage(
        code: 'en',
        sarvamCode: 'en-IN',
        nativeLabel: 'English',
        englishLabel: 'English',
        region: 'Universal',
      ),
    );
    return lang.sarvamCode;
  }

  /// Translate a string from [sourceLanguage] to [targetLanguage] using Sarvam.ai
  static Future<String> translate({
    required String text,
    required String targetLanguage,
    String sourceLanguage = 'en',
    String mode = 'formal',
  }) async {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty) return text;

    final targetSarvamCode = toSarvamLanguageCode(targetLanguage);
    final sourceSarvamCode = toSarvamLanguageCode(sourceLanguage);

    // If source and target are the same, no translation needed
    if (targetSarvamCode == sourceSarvamCode) {
      return text;
    }

    final cacheKey = '$sourceSarvamCode:$targetSarvamCode:$trimmedText';
    if (_translationCache.containsKey(cacheKey)) {
      return _translationCache[cacheKey]!;
    }

    final apiKey = EnvConfig.sarvamApiKey;
    if (apiKey.isEmpty) {
      debugPrint('[SarvamService] SARVAM_API_KEY is not set in .env. Skipping Sarvam API call.');
      return text;
    }

    final url = Uri.parse('${EnvConfig.sarvamBaseUrl}/translate');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'api-subscription-key': apiKey,
        },
        body: jsonEncode({
          'input': trimmedText,
          'source_language_code': sourceSarvamCode,
          'target_language_code': targetSarvamCode,
          'speaker_gender': 'Female',
          'mode': mode,
          'model': 'mayura:v1',
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        final translatedText = decoded['translated_text']?.toString();
        if (translatedText != null && translatedText.isNotEmpty) {
          _translationCache[cacheKey] = translatedText;
          return translatedText;
        }
      } else {
        debugPrint('[SarvamService] Translate error (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      debugPrint('[SarvamService] Translate network error: $e');
    }

    // Gracefully fallback to original text if API is unavailable or fails
    return text;
  }

  /// Batch translate multiple texts efficiently
  static Future<List<String>> translateBatch({
    required List<String> texts,
    required String targetLanguage,
    String sourceLanguage = 'en',
  }) async {
    return Future.wait(texts.map((t) => translate(
          text: t,
          targetLanguage: targetLanguage,
          sourceLanguage: sourceLanguage,
        )));
  }

  /// Test a Sarvam API key to verify connectivity
  static Future<bool> testApiKey(String apiKey) async {
    if (apiKey.trim().isEmpty) return false;
    try {
      final url = Uri.parse('${EnvConfig.sarvamBaseUrl}/translate');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'api-subscription-key': apiKey.trim(),
        },
        body: jsonEncode({
          'input': 'Hello Farmer',
          'source_language_code': 'en-IN',
          'target_language_code': 'hi-IN',
          'mode': 'formal',
          'model': 'mayura:v1',
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('[SarvamService] testApiKey error: $e');
      return false;
    }
  }

  /// Clear the runtime translation cache if needed
  static void clearCache() {
    _translationCache.clear();
  }
}
