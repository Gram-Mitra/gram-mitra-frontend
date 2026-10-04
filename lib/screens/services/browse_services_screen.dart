import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import 'expert_support_screen.dart';
import 'healthcare_screen.dart';
import 'marketplace_screen.dart';
import 'schemes_screen.dart';
import 'village_problems_screen.dart';

class BrowseServicesScreen extends StatelessWidget {
  const BrowseServicesScreen({super.key});

  void _callHelpline(String number) async {
    final uri = Uri.parse('tel:$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quick Services • Gram Mitra',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ========================================================
            // 24/7 EMERGENCY HELPLINES BAR
            // ========================================================
            const Text(
              '24/7 EMERGENCY HELPLINES',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
                color: AppColors.statusError,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildEmergencyDialButton(
                    title: '108 Ambulance',
                    subtitle: 'Medical',
                    number: '108',
                    color: const Color(0xFFD32F2F),
                    icon: Icons.local_hospital_rounded,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildEmergencyDialButton(
                    title: '1962 Veterinary',
                    subtitle: 'Animal Help',
                    number: '1962',
                    color: const Color(0xFF2E7D32),
                    icon: Icons.pets_rounded,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildEmergencyDialButton(
                    title: '112 Emergency',
                    subtitle: 'Police & Fire',
                    number: '112',
                    color: const Color(0xFF0288D1),
                    icon: Icons.shield_rounded,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ========================================================
            // RURAL CARE & SERVICES DIRECTORY
            // ========================================================
            const Text(
              'VILLAGE SERVICES & CARE',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Explore Rural Support',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
              ),
            ),
            const SizedBox(height: 16),

            // 1. Healthcare & Hospitals
            _buildServiceCard(
              context,
              title: 'Healthcare & Civil Hospitals',
              subtitle: 'Palghar Civil Hospital, PHC Manor, 24x7 Emergency OPD, free generic pharmacy',
              icon: Icons.local_hospital_outlined,
              iconColor: const Color(0xFFD32F2F),
              isDark: isDark,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const HealthcareScreen(initialType: 'human')),
                );
              },
            ),
            const SizedBox(height: 14),

            // 2. Veterinary Care
            _buildServiceCard(
              context,
              title: 'Veterinary & Livestock Care',
              subtitle: 'Palghar Veterinary Polyclinic, cattle vaccination, deworming, mobile clinics',
              icon: Icons.pets_outlined,
              iconColor: const Color(0xFF2E7D32),
              isDark: isDark,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const HealthcareScreen(initialType: 'animal')),
                );
              },
            ),
            const SizedBox(height: 14),

            // 3. Government Schemes
            _buildServiceCard(
              context,
              title: 'Sarkari Schemes & Subsidies',
              subtitle: 'PM-KISAN ₹6,000, PM Fasal Bima (PMFBY), PMAY-G rural housing, Kisan Credit Card',
              icon: Icons.account_balance_outlined,
              iconColor: AppColors.primaryGreen,
              isDark: isDark,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SchemesScreen()),
                );
              },
            ),
            const SizedBox(height: 14),

            // 4. Krishi Marketplace
            _buildServiceCard(
              context,
              title: 'Krishi Marketplace (Bazar)',
              subtitle: 'Buy and sell Kolam rice, bajra seeds, organic vermicompost, dairy fodder bundles',
              icon: Icons.storefront_outlined,
              iconColor: AppColors.terracottaDark,
              isDark: isDark,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const MarketplaceScreen()),
                );
              },
            ),
            const SizedBox(height: 14),

            // 5. Village Grievances
            _buildServiceCard(
              context,
              title: 'Report Village Problem',
              subtitle: 'Report handpump failure, road potholes, electricity faults to Gram Panchayat with photo',
              icon: Icons.campaign_outlined,
              iconColor: AppColors.terracottaAccent,
              isDark: isDark,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const VillageProblemsScreen()),
                );
              },
            ),
            const SizedBox(height: 14),

            // 6. Expert Voice Support
            _buildServiceCard(
              context,
              title: 'Expert Voice Support',
              subtitle: 'Call Krishi Salahkar (Crops), Madhumakshi Mitra (Beekeeping), Matsya Palan (Fish Farming)',
              icon: Icons.support_agent_rounded,
              iconColor: const Color(0xFF0288D1),
              badge: '3 Experts',
              isDark: isDark,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ExpertSupportScreen()),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyDialButton({
    required String title,
    required String subtitle,
    required String number,
    required Color color,
    required IconData icon,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: () => _callHelpline(number),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: color.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
    required bool isDark,
    String? badge,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.borderSubtle),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                          ),
                        ),
                      ),
                      if (badge != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.primaryGreen.withOpacity(0.2) : AppColors.lightMint,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            badge,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isDark ? const Color(0xFF81C784) : AppColors.primaryGreen,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
