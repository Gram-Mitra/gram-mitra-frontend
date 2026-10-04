import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/scheme.dart';
import '../../services/scheme_service.dart';

class SchemesScreen extends StatefulWidget {
  const SchemesScreen({super.key});

  @override
  State<SchemesScreen> createState() => _SchemesScreenState();
}

class _SchemesScreenState extends State<SchemesScreen> {
  List<Scheme> _schemes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSchemes();
  }

  Future<void> _loadSchemes() async {
    setState(() => _isLoading = true);
    final data = await SchemeService.getSchemes();
    if (mounted) {
      setState(() {
        _schemes = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('Government Schemes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen))
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: _schemes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final scheme = _schemes[index];
                return Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.lightMint,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              scheme.category ?? 'Welfare',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Icon(Icons.verified_outlined, size: 18, color: AppColors.primaryGreen),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        scheme.title,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textCharcoal),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        scheme.description,
                        style: const TextStyle(fontSize: 13, color: AppColors.textMuted, height: 1.4),
                      ),
                      if (scheme.benefits != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FBF8),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.borderSubtle),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.monetization_on_outlined, size: 16, color: AppColors.primaryGreen),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Benefits: ${scheme.benefits}',
                                  style: const TextStyle(fontSize: 12, color: AppColors.textCharcoal, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (scheme.eligibility != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Eligibility: ${scheme.eligibility}',
                          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
    );
  }
}
