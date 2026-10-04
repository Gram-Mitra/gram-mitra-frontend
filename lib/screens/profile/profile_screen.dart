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
    final isDark = appState.isDarkMode;
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    final name = user?.fullName ?? 'Kisan Mitra';
    final phone = user?.phone ?? 'Not provided';
    final email = user?.email ?? 'Not provided';
    final age = user?.age != null ? '${user!.age} years' : 'Not set';
    final village = user?.village ?? 'Palghar';
    final district = user?.district ?? 'Palghar';
    final state = user?.state ?? 'Maharashtra';

    final scaffoldBg = isDark ? AppColors.darkScaffoldBg : AppColors.scaffoldBg;
    final cardBg = isDark ? AppColors.darkCardBg : Colors.white;
    final borderCol = isDark ? AppColors.darkBorder : AppColors.borderSubtle;
    final textCol = isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal;
    final mutedCol = isDark ? AppColors.darkTextMuted : AppColors.textMuted;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        title: Text(
          AppTranslations.text(lang, 'nav_profile'),
          style: TextStyle(inherit: true, fontWeight: FontWeight.bold, fontSize: 18, color: textCol),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: Column(
              children: [
                // User Header Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: borderCol),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF263D2B) : AppColors.lightMint,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.person_rounded,
                            color: isDark ? AppColors.forestHighlight : AppColors.primaryGreen,
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
                                inherit: true,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textCol,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              phone,
                              style: TextStyle(
                                inherit: true,
                                fontSize: 13,
                                color: mutedCol,
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
                                      inherit: true,
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
                    color: cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: borderCol),
                  ),
                  child: Column(
                    children: [
                      _buildProfileRow('Full Name', name, Icons.badge_outlined, textCol, mutedCol),
                      Divider(height: 20, color: borderCol),
                      _buildProfileRow('Phone', phone, Icons.phone_outlined, textCol, mutedCol),
                      Divider(height: 20, color: borderCol),
                      _buildProfileRow('Email', email, Icons.email_outlined, textCol, mutedCol),
                      Divider(height: 20, color: borderCol),
                      _buildProfileRow('Age', age, Icons.calendar_today_outlined, textCol, mutedCol),
                      Divider(height: 20, color: borderCol),
                      _buildProfileRow('State', state, Icons.map_outlined, textCol, mutedCol),
                      Divider(height: 20, color: borderCol),
                      _buildProfileRow('District', district, Icons.location_city_outlined, textCol, mutedCol),
                      Divider(height: 20, color: borderCol),
                      _buildProfileRow('Village', village, Icons.home_work_outlined, textCol, mutedCol),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Settings & Preferences (Wrapped in Material to prevent ListTile assertion error)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: borderCol),
                  ),
                  child: Material(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(20),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.language_rounded, color: AppColors.primaryGreen),
                        title: Text(
                          'Change Language / भाषा बदलें',
                          style: TextStyle(inherit: true, color: textCol, fontSize: 14),
                        ),
                        subtitle: Text(
                          lang == 'hi' ? 'हिंदी' : (lang == 'mr' ? 'मराठी' : 'English'),
                          style: TextStyle(inherit: true, fontSize: 12, color: mutedCol),
                        ),
                        trailing: Icon(Icons.chevron_right, color: mutedCol),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const LanguageScreen(isInitialSelection: false)),
                          );
                        },
                      ),
                      Divider(height: 1, color: borderCol),
                      ListTile(
                        leading: const Icon(Icons.dark_mode_outlined, color: AppColors.primaryGreen),
                        title: Text(
                          'Dark Mode',
                          style: TextStyle(inherit: true, color: textCol, fontSize: 14),
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
                        inherit: true,
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
        ),
      ),
    );
  }

  Widget _buildProfileRow(String label, String value, IconData icon, Color textCol, Color mutedCol) {
    return Row(
      children: [
        Icon(icon, size: 20, color: mutedCol),
        const SizedBox(width: 14),
        Text(
          label,
          style: TextStyle(inherit: true, fontSize: 13, color: mutedCol),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(inherit: true, fontSize: 14, fontWeight: FontWeight.w600, color: textCol),
        ),
      ],
    );
  }
}
