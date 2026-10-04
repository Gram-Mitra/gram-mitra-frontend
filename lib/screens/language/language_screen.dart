import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_translations.dart';
import '../../providers/app_state_provider.dart';
import '../auth/login_screen.dart';

class LanguageScreen extends StatefulWidget {
  final bool isInitialSelection;

  const LanguageScreen({super.key, this.isInitialSelection = false});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLang = 'en';

  final List<Map<String, String>> _languages = [
    {
      'code': 'en',
      'label': 'English',
      'sub': 'Default Language',
    },
    {
      'code': 'hi',
      'label': 'हिंदी',
      'sub': 'Hindi',
    },
    {
      'code': 'mr',
      'label': 'मराठी',
      'sub': 'Marathi (महाराष्ट्र)',
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedLang = Provider.of<AppStateProvider>(context, listen: false).currentLanguage;
  }

  void _onContinue() async {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    await appState.setLanguage(_selectedLang);

    if (!mounted) return;

    if (widget.isInitialSelection) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: widget.isInitialSelection
          ? null
          : AppBar(
              title: Text(
                AppTranslations.text(_selectedLang, 'choose_language'),
                style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal),
              ),
            ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // Heading
              Text(
                AppTranslations.text(_selectedLang, 'choose_language'),
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                ),
              ),
              const SizedBox(height: 8),
              // Subtitle
              Text(
                AppTranslations.text(_selectedLang, 'choose_language_sub'),
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),
              // Language Cards
              Expanded(
                child: ListView.separated(
                  itemCount: _languages.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final lang = _languages[index];
                    final isSelected = _selectedLang == lang['code'];

                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedLang = lang['code']!;
                        });
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCard : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? AppColors.primaryGreen : (isDark ? AppColors.darkBorder : AppColors.borderSubtle),
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected && !isDark
                              ? [
                                  BoxShadow(
                                    color: AppColors.primaryGreen.withOpacity(0.12),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? AppColors.primaryGreen : (isDark ? AppColors.darkTextSecondary : AppColors.textMuted),
                                  width: 2,
                                ),
                                color: isSelected ? AppColors.primaryGreen : Colors.transparent,
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lang['label']!,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    color: isSelected
                                        ? (isDark ? const Color(0xFF81C784) : AppColors.primaryGreen)
                                        : (isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  lang['sub']!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    AppTranslations.text(_selectedLang, 'continue'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
