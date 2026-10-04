import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/localization/app_translations.dart';
import '../providers/app_state_provider.dart';
import 'home/home_screen.dart';
import 'iot/connect_iot_screen.dart';
import 'profile/profile_screen.dart';
import 'services/browse_services_screen.dart';

class MainNavigationShell extends StatefulWidget {
  final int initialIndex;

  const MainNavigationShell({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  late int _currentIndex;

  final List<Widget> _screens = const [
    HomeScreen(),
    ConnectIotScreen(),
    ProfileScreen(),
    BrowseServicesScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);
    final lang = appState.currentLanguage;
    final isDark = appState.isDarkMode;

    final navBg = isDark ? AppColors.darkCardBg : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : const Color(0xFFECEFE9);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkScaffoldBg : AppColors.scaffoldBg,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: navBg,
          border: Border(
            top: BorderSide(color: borderColor, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.35 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 540),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      index: 0,
                      label: AppTranslations.text(lang, 'nav_home'),
                      icon: Icons.home_rounded,
                      isDark: isDark,
                    ),
                    _buildNavItem(
                      index: 1,
                      label: AppTranslations.text(lang, 'nav_iot'),
                      icon: Icons.sensors_rounded,
                      isDark: isDark,
                    ),
                    _buildNavItem(
                      index: 2,
                      label: AppTranslations.text(lang, 'nav_profile'),
                      icon: Icons.person_rounded,
                      isDark: isDark,
                    ),
                    _buildNavItem(
                      index: 3,
                      label: AppTranslations.text(lang, 'nav_services'),
                      icon: Icons.menu_rounded,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData icon,
    required bool isDark,
  }) {
    final isSelected = _currentIndex == index;
    final activeBg = isDark ? const Color(0xFF233628) : AppColors.lightMint;
    final activeFg = isDark ? AppColors.forestHighlight : AppColors.primaryGreen;
    final inactiveFg = isDark ? AppColors.darkTextMuted : AppColors.textMuted;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? activeBg : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? activeFg : inactiveFg,
              size: 22,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                inherit: true,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? activeFg : inactiveFg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
