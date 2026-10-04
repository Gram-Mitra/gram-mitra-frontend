import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_translations.dart';
import '../../providers/app_state_provider.dart';
import '../main_navigation_shell.dart';

class WelcomeScreen extends StatelessWidget {
  final String? userName;

  const WelcomeScreen({super.key, this.userName});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<AppStateProvider>(context).currentLanguage;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Animated Gram Mitra Logo Circle Badge
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryGreen, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen.withOpacity(0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  'assets/icons/app_logo.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Center(
                    child: Icon(
                      Icons.eco_rounded,
                      color: isDark ? const Color(0xFF81C784) : AppColors.primaryGreen,
                      size: 60,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Main Title
              Text(
                AppTranslations.text(lang, 'welcome_success'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              if (userName != null && userName!.isNotEmpty) ...[
                Text(
                  'Namaste, $userName! 🙏',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFF81C784) : AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 10),
              ],
              Text(
                AppTranslations.text(lang, 'welcome_sub'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                  height: 1.4,
                ),
              ),
              const Spacer(),
              // Get Started Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const MainNavigationShell()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    AppTranslations.text(lang, 'get_started'),
                    style: const TextStyle(
                      fontSize: 17,
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
