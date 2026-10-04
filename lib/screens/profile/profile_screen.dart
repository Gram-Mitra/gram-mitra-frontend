import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_translations.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';
import '../language/language_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);
    final lang = appState.currentLanguage;
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    final name = user?.fullName ?? 'Kisan Mitra';
    final phone = user?.phone ?? 'Not provided';
    final email = user?.email ?? 'Not provided';
    final age = user?.age != null ? '${user!.age} years' : 'Not set';
    final village = user?.village ?? 'Palghar';
    final district = user?.district ?? 'Palghar';
    final state = user?.state ?? 'Maharashtra';

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppTranslations.text(lang, 'nav_profile'),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            // User Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.borderSubtle),
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.primaryGreen.withOpacity(0.2) : AppColors.lightMint,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person_rounded,
                        color: AppColors.primaryGreen,
                        size: 36,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          phone,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: AppColors.primaryGreen),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '$village, $district',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? const Color(0xFF81C784) : AppColors.primaryGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Profile Database Details (Profiles table fields)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.borderSubtle),
              ),
              child: Column(
                children: [
                  _buildProfileRow('Full Name', name, Icons.badge_outlined, isDark),
                  Divider(height: 20, color: isDark ? AppColors.darkBorder : AppColors.borderSubtle),
                  _buildProfileRow('Phone', phone, Icons.phone_outlined, isDark),
                  Divider(height: 20, color: isDark ? AppColors.darkBorder : AppColors.borderSubtle),
                  _buildProfileRow('Email', email, Icons.email_outlined, isDark),
                  Divider(height: 20, color: isDark ? AppColors.darkBorder : AppColors.borderSubtle),
                  _buildProfileRow('Age', age, Icons.calendar_today_outlined, isDark),
                  Divider(height: 20, color: isDark ? AppColors.darkBorder : AppColors.borderSubtle),
                  _buildProfileRow('State', state, Icons.map_outlined, isDark),
                  Divider(height: 20, color: isDark ? AppColors.darkBorder : AppColors.borderSubtle),
                  _buildProfileRow('District', district, Icons.location_city_outlined, isDark),
                  Divider(height: 20, color: isDark ? AppColors.darkBorder : AppColors.borderSubtle),
                  _buildProfileRow('Village', village, Icons.home_work_outlined, isDark),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Settings & Preferences
            Material(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(20),
              clipBehavior: Clip.antiAlias,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.borderSubtle),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.language_rounded, color: AppColors.primaryGreen),
                      title: Text(
                        'Change Language / भाषा बदलें',
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                        ),
                      ),
                      subtitle: Text(
                        lang == 'hi' ? 'हिंदी' : (lang == 'mr' ? 'मराठी' : 'English'),
                        style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted),
                      ),
                      trailing: Icon(Icons.chevron_right, color: isDark ? AppColors.darkTextSecondary : null),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const LanguageScreen(isInitialSelection: false)),
                        );
                      },
                    ),
                    Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.borderSubtle),
                    ListTile(
                      leading: const Icon(Icons.dark_mode_outlined, color: AppColors.primaryGreen),
                      title: Text(
                        'Dark Mode',
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                        ),
                      ),
                      trailing: Switch(
                        value: appState.isDarkMode,
                        activeColor: AppColors.primaryGreen,
                        onChanged: (_) => appState.toggleDarkMode(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.logout_rounded, color: AppColors.statusError),
                label: Text(
                  AppTranslations.text(lang, 'logout'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.statusError,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.statusError),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () async {
                  await authProvider.logout();
                  if (!context.mounted) return;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(String label, String value, IconData icon, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 20, color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted),
        const SizedBox(width: 14),
        Text(
          label,
          style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
