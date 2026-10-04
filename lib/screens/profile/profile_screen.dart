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

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: Text(
          AppTranslations.text(lang, 'nav_profile'),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: AppColors.lightMint,
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
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textCharcoal,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          phone,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textMuted,
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
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primaryGreen,
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Column(
                children: [
                  _buildProfileRow('Full Name', name, Icons.badge_outlined),
                  const Divider(height: 20, color: AppColors.borderSubtle),
                  _buildProfileRow('Phone', phone, Icons.phone_outlined),
                  const Divider(height: 20, color: AppColors.borderSubtle),
                  _buildProfileRow('Email', email, Icons.email_outlined),
                  const Divider(height: 20, color: AppColors.borderSubtle),
                  _buildProfileRow('Age', age, Icons.calendar_today_outlined),
                  const Divider(height: 20, color: AppColors.borderSubtle),
                  _buildProfileRow('State', state, Icons.map_outlined),
                  const Divider(height: 20, color: AppColors.borderSubtle),
                  _buildProfileRow('District', district, Icons.location_city_outlined),
                  const Divider(height: 20, color: AppColors.borderSubtle),
                  _buildProfileRow('Village', village, Icons.home_work_outlined),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Settings & Preferences
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.language_rounded, color: AppColors.primaryGreen),
                    title: const Text('Change Language / भाषा बदलें'),
                    subtitle: Text(
                      lang == 'hi' ? 'हिंदी' : (lang == 'mr' ? 'मराठी' : 'English'),
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const LanguageScreen(isInitialSelection: false)),
                      );
                    },
                  ),
                  const Divider(height: 1, color: AppColors.borderSubtle),
                  ListTile(
                    leading: const Icon(Icons.dark_mode_outlined, color: AppColors.primaryGreen),
                    title: const Text('Dark Mode'),
                    trailing: Switch(
                      value: appState.isDarkMode,
                      activeColor: AppColors.primaryGreen,
                      onChanged: (_) => appState.toggleDarkMode(),
                    ),
                  ),
                ],
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

  Widget _buildProfileRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textMuted),
        const SizedBox(width: 14),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textCharcoal),
        ),
      ],
    );
  }
}
