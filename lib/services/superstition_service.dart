import '../core/constants/api_endpoints.dart';
import '../models/myth_fact.dart';
import 'api_service.dart';

class SuperstitionService {
  static final List<MythFact> defaultMyths = [
    MythFact(
      id: '1',
      title: 'Full Moon Farming',
      myth: 'Does planting by the full moon guarantee a better harvest?',
      fact: 'Crop success depends on soil health, irrigation and sunlight—not lunar phases.',
      explanation: 'Soil nutrients, certified seeds, and moisture dictate seed germination.',
      category: 'agriculture',
    ),
    MythFact(
      id: '2',
      title: 'Chemical Fertilizer Immunity',
      myth: 'Applying double urea will double crop yield.',
      fact: 'Excess nitrogen burns root tips, degrades soil pH, and invites pest infestations.',
      explanation: 'Excess urea causes vegetative overgrowth without seed development.',
      category: 'soil',
    ),
    MythFact(
      id: '3',
      title: 'Livestock Vaccination',
      myth: 'Vaccinating cattle reduces milk yield permanently.',
      fact: 'Temporary milk drop lasts only 24 hours while protecting cattle from fatal FMD and HS diseases.',
      explanation: 'FMD vaccination saves livestock from crippling viral infection.',
      category: 'animal',
    ),
    MythFact(
      id: '4',
      title: 'Mid-day Pesticide Spraying',
      myth: 'Spraying pesticides under direct afternoon sun kills pests faster.',
      fact: 'Afternoon heat evaporates chemicals rapidly and causes leaf burn; early morning or dusk is best.',
      explanation: 'Systemic pesticides absorb better when plant stomata are open in cooler morning hours.',
      category: 'protection',
    ),
    MythFact(
      id: '5',
      title: 'Deep Borewell Myth',
      myth: 'Digging deeper borewells right next to dried ones always restores water.',
      fact: 'Overexploiting depleted aquifers drops the water table; watershed recharge and check-dams restore water.',
      explanation: 'Aquifer recharge through percolation pits and contour trenches restores sustainable groundwater.',
      category: 'water',
    ),
  ];

  static Future<MythFact> getRandomMyth() async {
    try {
      final response = await ApiService.get(ApiEndpoints.superstitionsRandom);
      if (response.success && response.data != null) {
        final data = response.data;
        final map = data is Map<String, dynamic> ? data : (data is Map ? Map<String, dynamic>.from(data) : null);
        if (map != null) {
          return MythFact.fromJson(map);
        }
      }
    } catch (_) {}

    return defaultMyths.first;
  }

  static Future<List<MythFact>> getAllMyths() async {
    try {
      final response = await ApiService.get(ApiEndpoints.superstitions);
      if (response.success && response.data != null) {
        final list = response.data is List
            ? response.data as List
            : (response.data['records'] as List? ?? response.data['data'] as List? ?? []);
        final parsed = list.map((item) => MythFact.fromJson(Map<String, dynamic>.from(item))).toList();
        if (parsed.isNotEmpty) {
          return parsed;
        }
      }
    } catch (_) {}

    return List.from(defaultMyths);
  }
}
