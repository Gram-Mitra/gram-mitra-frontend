import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../iot/connect_iot_screen.dart';
import '../services/browse_services_screen.dart';
import '../services/expert_support_screen.dart';
import '../services/healthcare_screen.dart';
import '../services/marketplace_screen.dart';
import '../services/schemes_screen.dart';
import '../services/village_problems_screen.dart';

class SearchItem {
  final String title;
  final String description;
  final String category;
  final IconData icon;
  final Color color;
  final List<String> keywords;
  final Widget? destinationScreen;
  final String? directAction; // e.g. 'tel:108'

  const SearchItem({
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
    required this.color,
    required this.keywords,
    this.destinationScreen,
    this.directAction,
  });
}

class SearchServicesScreen extends StatefulWidget {
  final String? initialQuery;

  const SearchServicesScreen({super.key, this.initialQuery});

  @override
  State<SearchServicesScreen> createState() => _SearchServicesScreenState();
}

class _SearchServicesScreenState extends State<SearchServicesScreen> {
  late final TextEditingController _controller;
  String _query = '';

  static final List<SearchItem> _allItems = [
    // Govt Schemes
    const SearchItem(
      title: 'PM-KISAN Samman Nidhi',
      description: '₹6,000 yearly income support paid directly to farmer bank accounts in 3 installments.',
      category: 'Government Scheme',
      icon: Icons.account_balance_wallet_rounded,
      color: Color(0xFF2E7D32),
      keywords: ['pm kisan', 'subsidy', 'scheme', '6000', 'installment', 'money', 'bank', 'yojana'],
      destinationScreen: SchemesScreen(),
    ),
    const SearchItem(
      title: 'Pradhan Mantri Fasal Bima Yojana',
      description: 'Comprehensive crop insurance against droughts, floods, hailstorms, and localized calamities.',
      category: 'Government Scheme',
      icon: Icons.shield_rounded,
      color: Color(0xFF2E7D32),
      keywords: ['crop insurance', 'bima', 'fasal', 'damage', 'flood', 'drought', 'claim'],
      destinationScreen: SchemesScreen(),
    ),
    const SearchItem(
      title: 'PM Kusum Solar Pump Subsidy',
      description: 'Up to 90% subsidy for installing standalone solar irrigation pumps on agricultural land.',
      category: 'Government Scheme',
      icon: Icons.solar_power_rounded,
      color: Color(0xFF2E7D32),
      keywords: ['solar', 'pump', 'kusum', 'irrigation', 'electricity subsidy', 'motor'],
      destinationScreen: SchemesScreen(),
    ),
    const SearchItem(
      title: 'Soil Health Card Scheme',
      description: 'Free lab testing of 12 soil nutrient parameters with tailored NPK fertilizer guidance.',
      category: 'Government Scheme',
      icon: Icons.grass_rounded,
      color: Color(0xFF2E7D32),
      keywords: ['soil', 'testing', 'card', 'npk', 'fertilizer guidance', 'nutrient'],
      destinationScreen: SchemesScreen(),
    ),
    const SearchItem(
      title: 'Kisan Credit Card (KCC)',
      description: 'Concessional interest rate crop credit loans up to ₹3 Lakhs for agricultural expenses.',
      category: 'Government Scheme',
      icon: Icons.credit_card_rounded,
      color: Color(0xFF2E7D32),
      keywords: ['kcc', 'loan', 'credit', 'interest', 'bank loan', 'kisan credit card'],
      destinationScreen: SchemesScreen(),
    ),

    // Healthcare
    const SearchItem(
      title: 'Palghar Rural Primary Health Center (PHC)',
      description: '24/7 emergency medical care, free generic medicines, fever treatment, and maternity ward.',
      category: 'Healthcare & Clinic',
      icon: Icons.local_hospital_rounded,
      color: Color(0xFFD32F2F),
      keywords: ['health', 'phc', 'doctor', 'clinic', 'hospital', 'medicine', 'fever', 'maternity', 'treatment'],
      destinationScreen: HealthcareScreen(),
    ),
    const SearchItem(
      title: '108 Free Emergency Ambulance',
      description: 'State emergency medical response service dispatched directly to rural and farm locations.',
      category: 'Emergency Care',
      icon: Icons.emergency_rounded,
      color: Color(0xFFD32F2F),
      keywords: ['ambulance', '108', 'emergency', 'accident', 'urgent hospital', 'medical van'],
      destinationScreen: HealthcareScreen(),
    ),
    const SearchItem(
      title: '104 Health Information Helpline',
      description: '24/7 toll-free medical advice, psychological counseling, and disease prevention support.',
      category: 'Healthcare & Clinic',
      icon: Icons.phone_in_talk_rounded,
      color: Color(0xFFD32F2F),
      keywords: ['104', 'telemedicine', 'medical call', 'doctor advice', 'helpline'],
      destinationScreen: HealthcareScreen(),
    ),

    // Marketplace
    const SearchItem(
      title: 'Certified Hybrid Wheat & Paddy Seeds',
      description: 'Government certified high-germination hybrid seeds with drought resistance.',
      category: 'Krishi Marketplace',
      icon: Icons.grain_rounded,
      color: Color(0xFFE65100),
      keywords: ['seeds', 'wheat', 'paddy', 'rice', 'bij', 'sowing', 'certified seeds', 'market'],
      destinationScreen: MarketplaceScreen(),
    ),
    const SearchItem(
      title: 'Organic Vermicompost (50kg Bag)',
      description: '100% pure earthworm organic compost enriched with nitrogen and beneficial soil microbes.',
      category: 'Krishi Marketplace',
      icon: Icons.compost_rounded,
      color: Color(0xFFE65100),
      keywords: ['fertilizer', 'khad', 'vermicompost', 'organic', 'compost', 'soil food'],
      destinationScreen: MarketplaceScreen(),
    ),
    const SearchItem(
      title: 'Tractor & Harvester Rental',
      description: 'Book hourly tractor plowing, rotavator, or combine harvester equipment nearby.',
      category: 'Krishi Marketplace',
      icon: Icons.agriculture_rounded,
      color: Color(0xFFE65100),
      keywords: ['tractor', 'hire', 'rent', 'harvester', 'rotavator', 'plow', 'farm machinery'],
      destinationScreen: MarketplaceScreen(),
    ),
    const SearchItem(
      title: 'Drip Irrigation & Micro Sprinklers',
      description: 'Save up to 60% irrigation water with subsidized inline drip kits and mist sprays.',
      category: 'Krishi Marketplace',
      icon: Icons.water_drop_rounded,
      color: Color(0xFFE65100),
      keywords: ['drip', 'sprinkler', 'pipe', 'irrigation system', 'water saver'],
      destinationScreen: MarketplaceScreen(),
    ),

    // Village Grievances
    const SearchItem(
      title: 'Drinking Water Supply Grievance',
      description: 'Report broken borewell pumps, pipeline leakages, contaminated water, or low water pressure.',
      category: 'Village Grievance',
      icon: Icons.water_damage_rounded,
      color: Color(0xFF0288D1),
      keywords: ['water', 'pipe', 'leak', 'borewell', 'tap', 'panchayat water', 'complaint'],
      destinationScreen: VillageProblemsScreen(),
    ),
    const SearchItem(
      title: 'Electricity & Transformer Breakdown',
      description: 'Report low voltage, burnt transformers, hanging power cables, and farm feeder outages.',
      category: 'Village Grievance',
      icon: Icons.electric_bolt_rounded,
      color: Color(0xFF0288D1),
      keywords: ['electricity', 'power', 'light', 'current', 'wire', 'transformer', 'bijli', 'load shedding'],
      destinationScreen: VillageProblemsScreen(),
    ),
    const SearchItem(
      title: 'Farm Road & Pothole Repair',
      description: 'Report muddy approach paths, road potholes, and damaged culverts for Panchayat repair.',
      category: 'Village Grievance',
      icon: Icons.alt_route_rounded,
      color: Color(0xFF0288D1),
      keywords: ['road', 'pothole', 'pathway', 'street', 'rasta', 'repair'],
      destinationScreen: VillageProblemsScreen(),
    ),
    const SearchItem(
      title: 'Drainage & Sanitation Complaint',
      description: 'Report open drainage clogging, stagnant monsoon water, and mosquito breeding zones.',
      category: 'Village Grievance',
      icon: Icons.cleaning_services_rounded,
      color: Color(0xFF0288D1),
      keywords: ['drainage', 'gutter', 'cleaning', 'sanitation', 'garbage', 'safai'],
      destinationScreen: VillageProblemsScreen(),
    ),

    // Expert Support
    const SearchItem(
      title: 'Ask Kisan Agronomist (Dr. Ramesh Patil)',
      description: 'Diagnose crop leaf yellowing, fungal blight, caterpillar pests, and soil NPK deficiencies.',
      category: 'Expert Consultation',
      icon: Icons.support_agent_rounded,
      color: Color(0xFF7B1FA2),
      keywords: ['expert', 'agronomist', 'crop disease', 'leaf', 'pest', 'fungus', 'scientist', 'doctor'],
      destinationScreen: ExpertSupportScreen(),
    ),
    const SearchItem(
      title: 'Veterinary Officer (Dr. Sunita Deshmukh)',
      description: 'Consult on cattle health, mastitis, FMD vaccination schedules, and cow/buffalo milk yield.',
      category: 'Expert Consultation',
      icon: Icons.pets_rounded,
      color: Color(0xFF7B1FA2),
      keywords: ['veterinary', 'cow', 'buffalo', 'cattle', 'milk', 'fmd', 'vaccine', 'pashu'],
      destinationScreen: ExpertSupportScreen(),
    ),
    const SearchItem(
      title: 'Kisan Call Center (1800-180-1551)',
      description: 'Toll-free agricultural helpline for instant telephonic expert guidance in regional languages.',
      category: 'Expert Consultation',
      icon: Icons.headset_mic_rounded,
      color: Color(0xFF7B1FA2),
      keywords: ['call center', 'toll free', 'helpline', 'phone scientist', '18001801551'],
      destinationScreen: ExpertSupportScreen(),
    ),

    // IoT & Smart Farm
    const SearchItem(
      title: 'Smart Soil Moisture Sensor & Automated Pump',
      description: 'View real-time volumetric soil water content (48%), temperature, and remotely trigger pump.',
      category: 'Smart Farm IoT',
      icon: Icons.sensors_rounded,
      color: Color(0xFF388E3C),
      keywords: ['iot', 'sensor', 'soil moisture', 'pump toggle', 'smart irrigation', 'telemetry'],
      destinationScreen: ConnectIotScreen(),
    ),

    // 24/7 Helplines
    const SearchItem(
      title: '1962 Pashu Sanjeevani Animal Ambulance',
      description: 'Mobile veterinary clinic for urgent doorstep treatment of farm livestock and cattle.',
      category: 'Emergency Helpline',
      icon: Icons.medical_services_rounded,
      color: Color(0xFFC2185B),
      keywords: ['1962', 'animal helpline', 'veterinary ambulance', 'pashu doctor'],
      destinationScreen: BrowseServicesScreen(),
    ),
    const SearchItem(
      title: '112 Unified Emergency Response',
      description: 'National emergency helpline for police, fire, ambulance, and disaster rescue.',
      category: 'Emergency Helpline',
      icon: Icons.call_rounded,
      color: Color(0xFFC2185B),
      keywords: ['112', 'police', 'fire', 'emergency', 'disaster'],
      destinationScreen: BrowseServicesScreen(),
    ),
  ];

  static const List<String> _popularTags = [
    '🌾 PM-KISAN',
    '🚜 Tractor Hire',
    '💧 Water Supply',
    '🚑 Ambulance 108',
    '🌱 Soil Moisture',
    '👨‍🌾 Agri Scientist',
    '⚡ Electricity Outage',
    '🛡️ Fasal Bima',
    '🐮 Animal Care 1962',
  ];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery ?? '');
    _query = (widget.initialQuery ?? '').trim().toLowerCase();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<SearchItem> get _filteredResults {
    if (_query.isEmpty) return _allItems;

    return _allItems.where((item) {
      final titleMatch = item.title.toLowerCase().contains(_query);
      final descMatch = item.description.toLowerCase().contains(_query);
      final catMatch = item.category.toLowerCase().contains(_query);
      final keywordMatch = item.keywords.any((k) => k.toLowerCase().contains(_query));
      return titleMatch || descMatch || catMatch || keywordMatch;
    }).toList();
  }

  void _onTagSelected(String tag) {
    // Strip emoji
    final cleanTag = tag.replaceAll(RegExp(r'[^\w\s-]'), '').trim();
    _controller.text = cleanTag;
    setState(() {
      _query = cleanTag.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final results = _filteredResults;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkScaffoldBg : AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkGreen : AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Container(
          height: 44,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: isDark ? Border.all(color: AppColors.darkBorder) : null,
          ),
          child: TextField(
            controller: _controller,
            autofocus: widget.initialQuery == null || widget.initialQuery!.isEmpty,
            style: TextStyle(
              color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: 'Search schemes, services, care...',
              hintStyle: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : const Color(0xFF757575),
                fontSize: 13,
              ),
              prefixIcon: const Icon(Icons.search, color: AppColors.primaryGreen, size: 20),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      color: isDark ? AppColors.darkTextSecondary : Colors.grey,
                      onPressed: () {
                        _controller.clear();
                        setState(() => _query = '');
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onChanged: (val) {
              setState(() {
                _query = val.trim().toLowerCase();
              });
            },
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Popular Suggestions Horizontal Tags
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: isDark ? AppColors.darkSurface : Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'POPULAR QUICK SEARCHES',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.6,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                        ),
                      ),
                      if (_query.isNotEmpty)
                        Text(
                          '${results.length} found',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _popularTags.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, idx) {
                      final tag = _popularTags[idx];
                      return ActionChip(
                        label: Text(
                          tag,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                          ),
                        ),
                        backgroundColor: isDark ? AppColors.darkCard : const Color(0xFFF1F5F0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide(
                            color: isDark ? AppColors.darkBorder : const Color(0xFFD6E3D8),
                          ),
                        ),
                        onPressed: () => _onTagSelected(tag),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Search Results List
          Expanded(
            child: results.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 64,
                            color: isDark ? AppColors.darkBorder : Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No matching services found',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Try searching for "water", "doctor", "tractor", "subsidy", or "soil"',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 20),
                          OutlinedButton.icon(
                            onPressed: () {
                              _controller.clear();
                              setState(() => _query = '');
                            },
                            icon: const Icon(Icons.refresh_rounded, size: 18),
                            label: const Text('Show All Services'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primaryGreen,
                              side: const BorderSide(color: AppColors.primaryGreen),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: results.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = results[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCard : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.borderSubtle,
                          ),
                          boxShadow: isDark
                              ? null
                              : [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              if (item.destinationScreen != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => item.destinationScreen!),
                                );
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Category Avatar Icon
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: item.color.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      item.icon,
                                      color: item.color,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  // Content
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Category Pill
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: item.color.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            item.category.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                              color: item.color,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        // Title
                                        Text(
                                          item.title,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        // Description
                                        Text(
                                          item.description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12,
                                            height: 1.35,
                                            color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // Chevron
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 14,
                                      color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
