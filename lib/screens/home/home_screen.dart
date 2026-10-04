import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_translations.dart';
import '../../models/myth_fact.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/superstition_service.dart';
import '../../widgets/interactive_search_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MythFact> _myths = List.from(SuperstitionService.defaultMyths);
  late final PageController _pageController;
  int _activeMythIndex = 0;
  Timer? _carouselTimer;

  int _feedbackRating = 5;
  String _selectedCategory = 'Water Supply';
  final _feedbackController = TextEditingController();

  final List<String> _feedbackCategories = [
    'Water Supply',
    'Electricity',
    'Road Repair',
    'Healthcare',
    'Panchayat',
    'General',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0);
    _startCarouselAutoPlay();
    _fetchDailyInsights();
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _pageController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _fetchDailyInsights() async {
    final list = await SuperstitionService.getAllMyths();
    if (mounted && list.isNotEmpty) {
      setState(() {
        _myths = list;
      });
    }
  }

  void _startCarouselAutoPlay() {
    _carouselTimer?.cancel();
    if (_myths.length <= 1) return;

    _carouselTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || !_pageController.hasClients) return;
      final nextIndex = (_activeMythIndex + 1) % _myths.length;
      _pageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  void _submitFeedback() {
    if (_feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write your feedback before submitting', style: TextStyle(inherit: true)),
        ),
      );
      return;
    }

    _feedbackController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Thank you! Your feedback has been sent to the Gram Panchayat.', style: TextStyle(inherit: true)),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);
    final lang = appState.currentLanguage;
    final isDark = appState.isDarkMode;
    final user = Provider.of<AuthProvider>(context).user;

    final userName = user?.fullName ?? (user?.phone ?? 'Kisan Mitra');
    final userVillage = user?.village ?? 'Palghar';
    final userDistrict = user?.district ?? 'Palghar';
    final userState = user?.state ?? 'Maharashtra';

    // Dynamic Theme Tokens
    final scaffoldBg = isDark ? AppColors.darkScaffoldBg : AppColors.scaffoldBg;
    final cardBg = isDark ? AppColors.darkCardBg : Colors.white;
    final borderCol = isDark ? AppColors.darkBorder : AppColors.borderSubtle;
    final textCol = isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal;
    final mutedCol = isDark ? AppColors.darkTextMuted : AppColors.textMuted;
    final headerBg = isDark ? const Color(0xFF1B4226) : AppColors.primaryGreen;

    return Container(
      color: scaffoldBg,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ========================================================
                // 1. TOP CURVED HEADER (Figma UI Exact Recreation)
                // ========================================================
                Container(
                  decoration: BoxDecoration(
                    color: headerBg,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.35 : 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Row: Logo, Title, District, Theme Toggle
                          Row(
                            children: [
                              // Sprout Logo in rounded square badge
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF263D2B) : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.eco_rounded,
                                    color: isDark ? AppColors.forestHighlight : AppColors.primaryGreen,
                                    size: 26,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // App Title & Location
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Gram Mitra',
                                      style: TextStyle(
                                        inherit: true,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: -0.3,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          size: 13,
                                          color: Color(0xFFC8E6C9),
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          '$userDistrict, $userState',
                                          style: const TextStyle(
                                            inherit: true,
                                            fontSize: 12,
                                            color: Color(0xFFC8E6C9),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Interactive Light/Dark Mode Switch Toggle
                              Tooltip(
                                message: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                                child: GestureDetector(
                                  onTap: () => appState.toggleDarkMode(),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    width: 58,
                                    height: 32,
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: isDark ? const Color(0xFF0F2615) : const Color(0xFF388E3C),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: Align(
                                      alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
                                      child: Container(
                                        width: 26,
                                        height: 26,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                                          size: 15,
                                          color: isDark ? const Color(0xFF1B4226) : const Color(0xFFF6B828),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Rounded Search Bar with Terracotta Button (Interactive!)
                          InkWell(
                            onTap: () => InteractiveSearchDialog.show(context),
                            borderRadius: BorderRadius.circular(26),
                            child: Container(
                              height: 52,
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkCardBg : Colors.white,
                                borderRadius: BorderRadius.circular(26),
                                border: Border.all(
                                  color: isDark ? AppColors.darkBorder : Colors.transparent,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.08),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 16),
                                  Icon(
                                    Icons.eco_outlined,
                                    color: isDark ? AppColors.forestHighlight : AppColors.primaryGreen,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      AppTranslations.text(lang, 'search_placeholder'),
                                      style: TextStyle(
                                        inherit: true,
                                        color: isDark ? AppColors.darkTextMuted : const Color(0xFF757575),
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  // Terracotta Search Icon Button
                                  Container(
                                    width: 44,
                                    height: 44,
                                    margin: const EdgeInsets.only(right: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.terracottaDark,
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                    child: const Icon(
                                      Icons.search,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ========================================================
                // GREETING BANNER
                // ========================================================
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${AppTranslations.text(lang, 'good_morning')}, $userName 👋',
                        style: TextStyle(
                          inherit: true,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textCol,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        AppTranslations.text(lang, 'how_help'),
                        style: TextStyle(
                          inherit: true,
                          fontSize: 14,
                          color: mutedCol,
                        ),
                      ),
                    ],
                  ),
                ),

                // ========================================================
                // 2. DAILY INSIGHTS (MYTH VS FACT CAROUSEL)
                // ========================================================
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppTranslations.text(lang, 'know_better'),
                                  style: TextStyle(
                                    inherit: true,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                    color: isDark ? AppColors.forestHighlight : AppColors.primaryGreen,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  AppTranslations.text(lang, 'daily_insights'),
                                  style: TextStyle(
                                    inherit: true,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: textCol,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppTranslations.text(lang, 'swipe_explore'),
                                style: TextStyle(
                                  inherit: true,
                                  fontSize: 11,
                                  color: mutedCol,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 6),
                              // Nav Back Button
                              InkWell(
                                onTap: () {
                                  _carouselTimer?.cancel();
                                  if (_activeMythIndex > 0) {
                                    _pageController.previousPage(
                                      duration: const Duration(milliseconds: 350),
                                      curve: Curves.easeInOut,
                                    );
                                  } else if (_myths.isNotEmpty) {
                                    _pageController.animateToPage(
                                      _myths.length - 1,
                                      duration: const Duration(milliseconds: 350),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.darkCardElevated : const Color(0xFFECEFE9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.chevron_left, size: 18, color: textCol),
                                ),
                              ),
                              const SizedBox(width: 4),
                              // Nav Forward Button
                              InkWell(
                                onTap: () {
                                  _carouselTimer?.cancel();
                                  if (_myths.isNotEmpty) {
                                    final next = (_activeMythIndex + 1) % _myths.length;
                                    _pageController.animateToPage(
                                      next,
                                      duration: const Duration(milliseconds: 350),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.darkCardElevated : const Color(0xFFECEFE9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.chevron_right, size: 18, color: textCol),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Swipeable Carousel PageView Container
                      SizedBox(
                        height: 205,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _myths.length,
                          onPageChanged: (idx) {
                            setState(() => _activeMythIndex = idx);
                          },
                          itemBuilder: (context, index) {
                            final myth = _myths[index];
                            final displayIndex = index + 1;
                            final indexText = displayIndex < 10 ? '0$displayIndex' : '$displayIndex';

                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                color: cardBg,
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(color: borderCol),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(isDark ? 0.25 : 0.05),
                                    blurRadius: 14,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Row(
                                children: [
                                  // Left Terracotta Badge Section
                                  Container(
                                    width: 105,
                                    color: AppColors.terracottaDark,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // Circular Sprout Emblem
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: const Color(0xFFF7F5EE),
                                            border: Border.all(
                                              color: const Color(0xFF8D6E63),
                                              width: 3,
                                            ),
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.eco_rounded,
                                              color: AppColors.primaryGreen,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                        // Watermark '01', '02', etc.
                                        Positioned(
                                          bottom: 8,
                                          left: 12,
                                          child: Text(
                                            indexText,
                                            style: TextStyle(
                                              inherit: true,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white.withOpacity(0.35),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Right Myth & Fact Content Section
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            AppTranslations.text(lang, 'myth_of_day').toUpperCase(),
                                            style: const TextStyle(
                                              inherit: true,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.6,
                                              color: AppColors.terracottaAccent,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            myth.myth,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              inherit: true,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: textCol,
                                              height: 1.3,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          // Verified Green Fact Pill
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: isDark ? const Color(0xFF1E3224) : AppColors.lightMint,
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(
                                                color: isDark ? const Color(0xFF2E4E37) : Colors.transparent,
                                              ),
                                            ),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.check_circle_rounded,
                                                  size: 15,
                                                  color: isDark ? AppColors.forestHighlight : AppColors.primaryGreen,
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    myth.fact,
                                                    maxLines: 3,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      inherit: true,
                                                      fontSize: 11,
                                                      color: isDark ? const Color(0xFFC8E6C9) : AppColors.sageText,
                                                      fontWeight: FontWeight.w500,
                                                      height: 1.3,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Animated Pager Indicator Dots
                      if (_myths.isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_myths.length, (index) {
                            final isActive = _activeMythIndex == index;
                            return GestureDetector(
                              onTap: () {
                                _carouselTimer?.cancel();
                                _pageController.animateToPage(
                                  index,
                                  duration: const Duration(milliseconds: 350),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: isActive ? 22 : 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? (isDark ? AppColors.forestHighlight : AppColors.primaryGreen)
                                      : (isDark ? AppColors.darkBorder : Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            );
                          }),
                        ),
                    ],
                  ),
                ),

                // ========================================================
                // 3. WEATHER TODAY CARD (Palghar Farm Forecast)
                // ========================================================
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppTranslations.text(lang, 'farm_forecast'),
                                style: TextStyle(
                                  inherit: true,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                  color: isDark ? AppColors.forestHighlight : AppColors.primaryGreen,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                AppTranslations.text(lang, 'weather_today'),
                                style: TextStyle(
                                  inherit: true,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: textCol,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            AppTranslations.text(lang, 'updated_recently'),
                            style: TextStyle(
                              inherit: true,
                              fontSize: 12,
                              color: mutedCol,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Weather Gradient Container
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isDark
                                ? const [Color(0xFF1E4E2C), Color(0xFF13361E)]
                                : const [AppColors.weatherTop, AppColors.weatherBottom],
                          ),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: isDark ? Colors.black.withOpacity(0.3) : AppColors.weatherBottom.withOpacity(0.3),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Village Tag & Sun Graphic
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_outlined, color: Colors.white, size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${userVillage.toUpperCase()} VILLAGE',
                                      style: const TextStyle(
                                        inherit: true,
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.6,
                                      ),
                                    ),
                                  ],
                                ),
                                // Sun behind cloud graphic
                                Stack(
                                  children: [
                                    Positioned(
                                      right: 2,
                                      top: 0,
                                      child: Container(
                                        width: 22,
                                        height: 22,
                                        decoration: const BoxDecoration(
                                          color: AppColors.sunYellow,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.cloud_outlined,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Big Temperature
                            const Text(
                              '28°C',
                              style: TextStyle(
                                inherit: true,
                                fontSize: 38,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: -1,
                              ),
                            ),
                            const Text(
                              'Partly cloudy',
                              style: TextStyle(
                                inherit: true,
                                fontSize: 14,
                                color: Color(0xFFE8F5E9),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // 3 Frosted Metric Pills
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.18),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Column(
                                      children: [
                                        Text('💧 72%', style: TextStyle(inherit: true, color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                        SizedBox(height: 2),
                                        Text('Humidity', style: TextStyle(inherit: true, color: Color(0xFFC8E6C9), fontSize: 11)),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.18),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Column(
                                      children: [
                                        Text('💨 12 km/h', style: TextStyle(inherit: true, color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                        SizedBox(height: 2),
                                        Text('Wind', style: TextStyle(inherit: true, color: Color(0xFFC8E6C9), fontSize: 11)),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.18),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Column(
                                      children: [
                                        Text('🌧️ 20%', style: TextStyle(inherit: true, color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                        SizedBox(height: 2),
                                        Text('Rain', style: TextStyle(inherit: true, color: Color(0xFFC8E6C9), fontSize: 11)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            // Sowing Advisory Banner
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.eco, size: 16, color: Colors.white),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Good conditions for sowing Kharif crops today.',
                                      style: TextStyle(
                                        inherit: true,
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ========================================================
                // 4. VILLAGE COMMUNITY FEEDBACK FORM
                // ========================================================
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppTranslations.text(lang, 'feedback_title'),
                        style: TextStyle(
                          inherit: true,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                          color: isDark ? AppColors.forestHighlight : AppColors.primaryGreen,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        AppTranslations.text(lang, 'feedback_sub'),
                        style: TextStyle(
                          inherit: true,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textCol,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: borderCol),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(isDark ? 0.25 : 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF223628) : AppColors.lightMint,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.chat_bubble_outline_rounded,
                                    color: isDark ? AppColors.forestHighlight : AppColors.primaryGreen,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Help us improve $userVillage amenities & services',
                                    style: TextStyle(
                                      inherit: true,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: textCol,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'How satisfied are you with village services?',
                              style: TextStyle(inherit: true, fontSize: 13, color: mutedCol),
                            ),
                            const SizedBox(height: 8),
                            // Star Rating
                            Row(
                              children: List.generate(5, (index) {
                                final starNum = index + 1;
                                return GestureDetector(
                                  onTap: () => setState(() => _feedbackRating = starNum),
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Icon(
                                      starNum <= _feedbackRating ? Icons.star_rounded : Icons.star_border_rounded,
                                      color: starNum <= _feedbackRating
                                          ? AppColors.sunYellow
                                          : (isDark ? AppColors.darkBorder : Colors.grey.shade300),
                                      size: 30,
                                    ),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 16),
                            // Category Selection
                            Text(
                              'Select Concern Category:',
                              style: TextStyle(inherit: true, fontSize: 13, color: mutedCol),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _feedbackCategories.map((cat) {
                                final isSel = _selectedCategory == cat;
                                return ChoiceChip(
                                  label: Text(cat),
                                  selected: isSel,
                                  onSelected: (_) => setState(() => _selectedCategory = cat),
                                  selectedColor: isDark ? const Color(0xFF263D2B) : AppColors.lightMint,
                                  labelStyle: TextStyle(
                                    inherit: true,
                                    color: isSel
                                        ? (isDark ? Colors.white : AppColors.primaryGreen)
                                        : (isDark ? AppColors.darkTextMuted : AppColors.textCharcoal),
                                    fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                  backgroundColor: isDark ? AppColors.darkCardElevated : const Color(0xFFF7F5EE),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(
                                      color: isSel
                                          ? (isDark ? AppColors.forestHighlight : AppColors.primaryGreen)
                                          : borderCol,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 16),
                            // Comment Text Box
                            TextField(
                              controller: _feedbackController,
                              maxLines: 3,
                              style: TextStyle(inherit: true, color: textCol, fontSize: 13),
                              decoration: InputDecoration(
                                hintText: 'Share your suggestions or amenities needed in $userVillage...',
                                hintStyle: TextStyle(
                                  inherit: true,
                                  fontSize: 13,
                                  color: isDark ? AppColors.darkTextMuted : const Color(0xFF9E9E9E),
                                ),
                                filled: true,
                                fillColor: isDark ? AppColors.darkInputBg : const Color(0xFFF9FBF8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: borderCol),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: borderCol),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: isDark ? AppColors.forestHighlight : AppColors.primaryGreen,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Submit Button (Zero inherit clash!)
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _submitFeedback,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isDark ? AppColors.forestHighlight : AppColors.primaryGreen,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  AppTranslations.text(lang, 'submit_feedback'),
                                  style: const TextStyle(
                                    inherit: true,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
