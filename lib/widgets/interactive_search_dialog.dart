import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../providers/app_state_provider.dart';
import '../screens/services/healthcare_screen.dart';
import '../screens/services/marketplace_screen.dart';
import '../screens/services/schemes_screen.dart';
import '../screens/services/village_problems_screen.dart';

class SearchResultItem {
  final String title;
  final String subtitle;
  final String category;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  SearchResultItem({
    required this.title,
    required this.subtitle,
    required this.category,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class InteractiveSearchDialog extends StatefulWidget {
  const InteractiveSearchDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const InteractiveSearchDialog(),
    );
  }

  @override
  State<InteractiveSearchDialog> createState() => _InteractiveSearchDialogState();
}

class _InteractiveSearchDialogState extends State<InteractiveSearchDialog> {
  final TextEditingController _controller = TextEditingController();
  String _selectedCategory = 'All';
  String _query = '';

  final List<String> _categories = [
    'All',
    'Schemes',
    'Healthcare',
    'Marketplace',
    'Grievance',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<SearchResultItem> _getAllItems(BuildContext context) {
    return [
      SearchResultItem(
        title: 'PM-Kisan Samman Nidhi',
        subtitle: 'Direct financial income benefit ₹6,000/yr for small & marginal farmers',
        category: 'Schemes',
        icon: Icons.account_balance_wallet_rounded,
        color: AppColors.primaryGreen,
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => const SchemesScreen()));
        },
      ),
      SearchResultItem(
        title: 'PM Krishi Sinchayee (Per Drop More Crop)',
        subtitle: 'Subsidy for drip and micro-sprinkler irrigation systems',
        category: 'Schemes',
        icon: Icons.water_drop_rounded,
        color: AppColors.primaryGreen,
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => const SchemesScreen()));
        },
      ),
      SearchResultItem(
        title: 'Palghar Rural Hospital & Trauma Centre',
        subtitle: 'Emergency 24x7, Trauma ward, ICU beds, Palghar City',
        category: 'Healthcare',
        icon: Icons.local_hospital_rounded,
        color: AppColors.statusError,
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => const HealthcareScreen()));
        },
      ),
      SearchResultItem(
        title: 'Manor Primary Health Centre (PHC)',
        subtitle: 'Vaccination, OPD, Maternal Care, Manor Palghar',
        category: 'Healthcare',
        icon: Icons.health_and_safety_rounded,
        color: AppColors.forestHighlight,
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => const HealthcareScreen()));
        },
      ),
      SearchResultItem(
        title: 'Organic Neem Oil Pesticide (1 Liter)',
        subtitle: 'Pure cold-pressed bio-insecticide for stem borers & aphids',
        category: 'Marketplace',
        icon: Icons.eco_rounded,
        color: AppColors.primaryGreen,
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => const MarketplaceScreen()));
        },
      ),
      SearchResultItem(
        title: 'High-Yield Hybrid Paddy Seeds (10kg)',
        subtitle: 'Disease resistant, certified Maharashtra Agri seeds',
        category: 'Marketplace',
        icon: Icons.shopping_bag_rounded,
        color: AppColors.terracottaAccent,
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => const MarketplaceScreen()));
        },
      ),
      SearchResultItem(
        title: 'Report Drinking Water Pipeline Issue',
        subtitle: 'Lodge issue to Gram Panchayat drinking water authority',
        category: 'Grievance',
        icon: Icons.report_problem_rounded,
        color: AppColors.terracottaDark,
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => const VillageProblemsScreen()));
        },
      ),
      SearchResultItem(
        title: 'Electricity Transformer Repair',
        subtitle: 'Agricultural power line fault and feeder repair request',
        category: 'Grievance',
        icon: Icons.bolt_rounded,
        color: AppColors.statusWarning,
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => const VillageProblemsScreen()));
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppStateProvider>(context).isDarkMode;
    final allItems = _getAllItems(context);

    final filtered = allItems.where((item) {
      final matchesCategory = _selectedCategory == 'All' || item.category == _selectedCategory;
      final matchesQuery = _query.isEmpty ||
          item.title.toLowerCase().contains(_query.toLowerCase()) ||
          item.subtitle.toLowerCase().contains(_query.toLowerCase()) ||
          item.category.toLowerCase().contains(_query.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();

    final bgColor = isDark ? AppColors.darkCardBg : Colors.white;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal;
    final mutedColor = isDark ? AppColors.darkTextMuted : AppColors.textMuted;
    final inputBg = isDark ? AppColors.darkInputBg : const Color(0xFFF7F9F6);

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Title Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      'Search Gram Mitra',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.close, color: mutedColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Search Bar Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: inputBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.borderSubtle,
                    ),
                  ),
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    style: TextStyle(color: textColor, fontSize: 15),
                    onChanged: (val) => setState(() => _query = val.trim()),
                    decoration: InputDecoration(
                      hintText: 'Search schemes, hospitals, seeds, grievances...',
                      hintStyle: TextStyle(color: mutedColor, fontSize: 13),
                      prefixIcon: const Icon(Icons.search, color: AppColors.primaryGreen),
                      suffixIcon: _query.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () {
                                _controller.clear();
                                setState(() => _query = '');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Filter Category Chips
              SizedBox(
                height: 38,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _categories.length,
                  itemBuilder: (context, i) {
                    final cat = _categories[i];
                    final isSel = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: isSel,
                        onSelected: (_) => setState(() => _selectedCategory = cat),
                        selectedColor: isDark ? const Color(0xFF2E4633) : AppColors.lightMint,
                        backgroundColor: isDark ? AppColors.darkCardElevated : const Color(0xFFF7F5EE),
                        labelStyle: TextStyle(
                          color: isSel
                              ? (isDark ? Colors.white : AppColors.primaryGreen)
                              : mutedColor,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                          fontSize: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSel ? AppColors.primaryGreen : Colors.transparent,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              // Results List
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off_rounded, size: 48, color: mutedColor),
                            const SizedBox(height: 12),
                            Text(
                              'No matching services or amenities found',
                              style: TextStyle(color: mutedColor, fontSize: 14),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, idx) {
                          final item = filtered[idx];
                          return InkWell(
                            onTap: item.onTap,
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkCardElevated : const Color(0xFFFAFAF7),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isDark ? AppColors.darkBorder : AppColors.borderSubtle,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: item.color.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(item.icon, color: item.color, size: 22),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                item.title,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: textColor,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: item.color.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                item.category,
                                                style: TextStyle(
                                                  color: item.color,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item.subtitle,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: mutedColor, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(Icons.chevron_right, color: mutedColor, size: 18),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
