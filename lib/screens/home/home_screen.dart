import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_translations.dart';
import '../../models/myth_fact.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/superstition_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MythFact? _currentMyth;
  bool _isLoadingMyth = true;
  int _mythIndex = 1;
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
    _fetchDailyInsight();
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _fetchDailyInsight() async {
    setState(() => _isLoadingMyth = true);
    final myth = await SuperstitionService.getRandomMyth();
    if (mounted) {
      setState(() {
        _currentMyth = myth;
        _isLoadingMyth = false;
      });
    }
  }

  void _submitFeedback() {
    if (_feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write your feedback before submitting')),
      );
      return;
    }

    _feedbackController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Thank you! Your feedback has been sent to the Gram Panchayat.'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);
    final lang = appState.currentLanguage;
    final user = Provider.of<AuthProvider>(context).user;

    final userName = user?.fullName ?? (user?.phone ?? 'Kisan Mitra');
    final userVillage = user?.village ?? 'Palghar';
    final userDistrict = user?.district ?? 'Palghar';
    final userState = user?.state ?? 'Maharashtra';

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ========================================================
            // 1. TOP CURVED HEADER (Figma UI Exact Recreation)
            // ========================================================
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkGreen : AppColors.primaryGreen,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        children: [
                          // Sprout Logo in rounded square badge
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkCard : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.eco_rounded,
                                color: AppColors.primaryGreen,
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
                          // Theme Switch Toggle (Sun / Moon)
                          GestureDetector(
                            onTap: () => appState.toggleDarkMode(),
                            child: Container(
                              width: 52,
                              height: 30,
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkCard : const Color(0xFF388E3C),
                                borderRadius: BorderRadius.circular(20),
                                border: isDark ? Border.all(color: AppColors.darkBorder) : null,
                              ),
                              child: Align(
                                alignment: appState.isDarkMode ? Alignment.centerRight : Alignment.centerLeft,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.primaryGreen : Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    appState.isDarkMode ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                                    size: 14,
                                    color: isDark ? Colors.white : AppColors.primaryGreen,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Rounded Search Bar with Terracotta Button
                      Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCard : Colors.white,
                          borderRadius: BorderRadius.circular(26),
                          border: isDark ? Border.all(color: AppColors.darkBorder) : null,
                          boxShadow: isDark
                              ? null
                              : [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            const Icon(
                              Icons.eco_outlined,
                              color: AppColors.primaryGreen,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                AppTranslations.text(lang, 'search_placeholder'),
                                style: TextStyle(
                                  color: isDark ? AppColors.darkTextSecondary : const Color(0xFF757575),
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    AppTranslations.text(lang, 'how_help'),
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppTranslations.text(lang, 'know_better'),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            AppTranslations.text(lang, 'daily_insights'),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        AppTranslations.text(lang, 'swipe_explore'),
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Insights Card
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: isDark ? Border.all(color: AppColors.darkBorder) : null,
                      boxShadow: isDark
                          ? null
                          : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
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
                          width: 110,
                          color: isDark ? const Color(0xFF5A372E) : AppColors.terracottaDark,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Circular Sprout Emblem
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isDark ? const Color(0xFF1E2822) : const Color(0xFFF7F5EE),
                                  border: Border.all(
                                    color: const Color(0xFF8D6E63),
                                    width: 3,
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.eco_rounded,
                                    color: AppColors.primaryGreen,
                                    size: 32,
                                  ),
                                ),
                              ),
                              // Watermark '01'
                              Positioned(
                                bottom: 10,
                                left: 14,
                                child: Text(
                                  _mythIndex < 10 ? '0$_mythIndex' : '$_mythIndex',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white.withOpacity(0.35),
                                  ),
                                ),
                              ),
                              // Nav Arrow Left
                              Positioned(
                                left: 4,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _mythIndex = _mythIndex > 1 ? _mythIndex - 1 : 1;
                                    });
                                    _fetchDailyInsight();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.chevron_left, size: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Right Myth & Fact Content Section
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: _isLoadingMyth
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primaryGreen,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        AppTranslations.text(lang, 'myth_of_day'),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.6,
                                          color: AppColors.terracottaAccent,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        _currentMyth?.myth ?? 'Does planting by the full moon guarantee a better harvest?',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                                          height: 1.3,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      // Verified Green Fact Pill
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: isDark ? AppColors.primaryGreen.withOpacity(0.2) : AppColors.lightMint,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.check_circle_rounded,
                                              size: 16,
                                              color: AppColors.primaryGreen,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                _currentMyth?.fact ?? 'Crop success depends on soil health, irrigation and sunlight—not lunar phases.',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: isDark ? const Color(0xFFA5D6A7) : AppColors.sageText,
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
                  ),
                  const SizedBox(height: 10),
                  // Pager Indicator Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 22,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
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
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            AppTranslations.text(lang, 'weather_today'),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        AppTranslations.text(lang, 'updated_recently'),
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Weather Gradient Container
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.weatherTop,
                          AppColors.weatherBottom,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.weatherBottom.withOpacity(0.3),
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
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -1,
                          ),
                        ),
                        const Text(
                          'Partly cloudy',
                          style: TextStyle(
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
                                    Text('💧 72%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                    SizedBox(height: 2),
                                    Text('Humidity', style: TextStyle(color: Color(0xFFC8E6C9), fontSize: 11)),
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
                                    Text('💨 12 km/h', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                    SizedBox(height: 2),
                                    Text('Wind', style: TextStyle(color: Color(0xFFC8E6C9), fontSize: 11)),
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
                                    Text('🌧️ 20%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                    SizedBox(height: 2),
                                    Text('Rain', style: TextStyle(color: Color(0xFFC8E6C9), fontSize: 11)),
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
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    AppTranslations.text(lang, 'feedback_sub'),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.borderSubtle),
                      boxShadow: isDark
                          ? null
                          : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
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
                                color: isDark ? AppColors.primaryGreen.withOpacity(0.2) : AppColors.lightMint,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.primaryGreen, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Help us improve Palghar amenities & services',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'How satisfied are you with village services?',
                          style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted),
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
                                  color: starNum <= _feedbackRating ? AppColors.sunYellow : (isDark ? AppColors.darkBorder : Colors.grey.shade300),
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
                          style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted),
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
                              selectedColor: isDark ? AppColors.primaryGreen.withOpacity(0.3) : AppColors.lightMint,
                              labelStyle: TextStyle(
                                color: isSel
                                    ? (isDark ? const Color(0xFF81C784) : AppColors.primaryGreen)
                                    : (isDark ? AppColors.darkTextSecondary : AppColors.textCharcoal),
                                fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                fontSize: 12,
                              ),
                              backgroundColor: isDark ? AppColors.darkSurface : const Color(0xFFF7F5EE),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: isSel ? AppColors.primaryGreen : (isDark ? AppColors.darkBorder : AppColors.borderSubtle),
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
                          style: TextStyle(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Share your suggestions or amenities needed in $userVillage...',
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: isDark ? AppColors.darkTextSecondary : const Color(0xFF9E9E9E),
                            ),
                            filled: true,
                            fillColor: isDark ? AppColors.darkSurface : const Color(0xFFF9FBF8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.borderSubtle),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.borderSubtle),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _submitFeedback,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              AppTranslations.text(lang, 'submit_feedback'),
                              style: const TextStyle(
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
    );
  }
}
