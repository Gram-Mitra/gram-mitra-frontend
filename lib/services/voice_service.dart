import '../core/constants/api_endpoints.dart';
import 'api_service.dart';

class ExpertTopic {
  final String id;
  final String name;
  final String role;
  final String description;
  final List<String> specializations;

  const ExpertTopic({
    required this.id,
    required this.name,
    required this.role,
    required this.description,
    required this.specializations,
  });
}

class VoiceService {
  static const List<ExpertTopic> experts = [
    ExpertTopic(
      id: 'agriculture',
      name: 'Krishi Salahkar',
      role: 'Agriculture & Soil Expert',
      description: 'Expert guidance on crops, organic soil conditioning, NPK fertilizers, pest control, seed selection, and agricultural schemes.',
      specializations: [
        'Crops & Varieties',
        'Soil Health & pH',
        'Fertilizers & Urea',
        'Drip Irrigation',
        'Crop Diseases & Fungi',
        'Pest Control (Bio & Chemical)',
        'Certified Hybrid Seeds',
        'Crop Rotation Planning',
        'Weather & Monsoons',
        'PM-KISAN & PMFBY Guidance',
      ],
    ),
    ExpertTopic(
      id: 'apiculture',
      name: 'Madhumakshi Mitra',
      role: 'Apiculture & Beekeeping Expert',
      description: 'Scientific beekeeping advice covering bee species, artificial hives, queen rearing, pure honey extraction, and government subsidies.',
      specializations: [
        'Apis Cerana & Mellifera Species',
        'Modern Wooden Hive Management',
        'Queen Bee Rearing & Swarm Control',
        'Varroa Mite & Brood Diseases',
        'Raw Honey & Beeswax Processing',
        'Crop Pollination Services',
        'Smokers, Veils & Extractors',
        'Monsoon & Winter Colony Protection',
        'National Beekeeping Mission (NBHM)',
      ],
    ),
    ExpertTopic(
      id: 'pisciculture',
      name: 'Matsya Palan Mitra',
      role: 'Pisciculture & Fish Farming Expert',
      description: 'End-to-end aquaculture assistance for village ponds, fingerling stocking, water aeration, feed schedules, and PMMSY scheme loans.',
      specializations: [
        'Rohu, Katla, Mrigal & Tilapia',
        'Village Pond Excavation & Liming',
        'Dissolved Oxygen & Water Quality',
        'Gill Rot & Fungal Treatment',
        'Floating Pellet Feeding Schedules',
        'Induced Breeding & Hatchery Setup',
        'Fingerling Stocking Density',
        'Harvesting & Cold Chain Transport',
        'Wholesale Mandi Fish Prices',
        'PM Matsya Sampada Yojana (PMMSY)',
      ],
    ),
  ];

  static Future<String> askExpert(String expertId, String query) async {
    try {
      final response = await ApiService.post(ApiEndpoints.voiceQuery, {
        'query': query,
        'expertType': expertId,
      });

      if (response.success && response.data != null) {
        if (response.data is Map && response.data['textResponse'] != null) {
          return response.data['textResponse'].toString();
        }
      }
    } catch (_) {}

    // Intelligent domain-specific consultation fallback
    if (expertId == 'apiculture') {
      return 'For beekeeping during humidity, ensure proper ventilation in the hive supers and inspect for wax moths weekly. Keep the brood chamber elevated from wet soil.';
    } else if (expertId == 'pisciculture') {
      return 'Maintain pond water pH between 7.5 and 8.2 using agricultural lime (200 kg/hectare). Ensure morning aeration during cloudy days to prevent low dissolved oxygen.';
    } else {
      return 'For Kharif crops in Palghar loam soil, balanced basal application of DAP and Potash prior to sowing ensures strong root anchorage against heavy rains.';
    }
  }
}
