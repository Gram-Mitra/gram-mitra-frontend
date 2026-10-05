import 'package:flutter_test/flutter_test.dart';
import 'package:gram_mitra/core/config/env_config.dart';
import 'package:gram_mitra/core/localization/app_translations.dart';
import 'package:gram_mitra/services/sarvam_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Sarvam AI & Multilingual Integration Tests', () {
    test('SarvamService maps ISO language codes to Sarvam BCP-47 codes correctly', () {
      expect(SarvamService.toSarvamLanguageCode('hi'), equals('hi-IN'));
      expect(SarvamService.toSarvamLanguageCode('mr'), equals('mr-IN'));
      expect(SarvamService.toSarvamLanguageCode('gu'), equals('gu-IN'));
      expect(SarvamService.toSarvamLanguageCode('te'), equals('te-IN'));
      expect(SarvamService.toSarvamLanguageCode('ta'), equals('ta-IN'));
      expect(SarvamService.toSarvamLanguageCode('bn'), equals('bn-IN'));
      expect(SarvamService.toSarvamLanguageCode('kn'), equals('kn-IN'));
      expect(SarvamService.toSarvamLanguageCode('ml'), equals('ml-IN'));
      expect(SarvamService.toSarvamLanguageCode('pa'), equals('pa-IN'));
      expect(SarvamService.toSarvamLanguageCode('od'), equals('od-IN'));
      expect(SarvamService.toSarvamLanguageCode('en'), equals('en-IN'));
    });

    test('SarvamService supported languages list covers 11 Indian languages', () {
      expect(SarvamService.supportedLanguages.length, equals(11));
      final codes = SarvamService.supportedLanguages.map((l) => l.code).toSet();
      expect(codes.containsAll({'en', 'hi', 'mr', 'gu', 'te', 'ta', 'bn', 'kn', 'ml', 'pa', 'od'}), isTrue);
    });

    test('EnvConfig defaults and EC2 backend URL resolution', () {
      expect(EnvConfig.ec2BackendUrl, isNotEmpty);
      expect(EnvConfig.sarvamBaseUrl, equals('https://api.sarvam.ai'));
    });

    test('AppTranslations resolves static translations and fallback gracefully', () {
      expect(AppTranslations.text('en', 'login'), equals('Login'));
      expect(AppTranslations.text('hi', 'login'), equals('लॉग इन'));
      expect(AppTranslations.text('mr', 'login'), equals('लॉगिन करा'));
      // Missing language code gracefully falls back to English
      expect(AppTranslations.text('unknown_code', 'login'), equals('Login'));
    });
  });
}
