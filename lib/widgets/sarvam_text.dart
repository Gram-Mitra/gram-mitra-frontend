import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/localization/app_translations.dart';
import '../providers/app_state_provider.dart';
import '../services/sarvam_service.dart';

/// A reactive Text widget that automatically translates content to the current language
/// using pre-bundled translations or Sarvam.ai Indic neural translation.
class SarvamText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool isKey;

  const SarvamText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.isKey = false,
  });

  @override
  Widget build(BuildContext context) {
    final currentLang = context.select<AppStateProvider, String>((p) => p.currentLanguage);

    if (currentLang == 'en' || text.trim().isEmpty) {
      final displayText = isKey ? AppTranslations.text('en', text) : text;
      return Text(
        displayText,
        style: style,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
      );
    }

    // Check if translation is already cached or bundled synchronously
    final syncText = AppTranslations.text(currentLang, text);
    if (syncText != text && syncText.isNotEmpty) {
      return Text(
        syncText,
        style: style,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
      );
    }

    // Translate asynchronously via Sarvam AI
    return FutureBuilder<String>(
      future: SarvamService.translate(
        text: text,
        targetLanguage: currentLang,
        sourceLanguage: 'en',
      ),
      builder: (context, snapshot) {
        final display = snapshot.data ?? text;
        return Text(
          display,
          style: style,
          textAlign: textAlign,
          overflow: overflow,
          maxLines: maxLines,
        );
      },
    );
  }
}
