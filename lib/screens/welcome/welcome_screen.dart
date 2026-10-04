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

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Animated Sprout Circle Badge
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: AppColors.lightMint,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryGreen, width: 2.5),
                ),
                child: const Center(
                  child: Icon(
                    Icons.eco_rounded,
                    color: AppColors.primaryGreen,
                    size: 60,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Main Title
              Text(
                AppTranslations.text(lang, 'welcome_success'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textCharcoal,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              if (userName != null && userName!.isNotEmpty) ...[
                Text(
                  'Namaste, $userName! 🙏',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 10),
              ],
              Text(
                AppTranslations.text(lang, 'welcome_sub'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textMuted,
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
