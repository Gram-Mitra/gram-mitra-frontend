import '../core/constants/api_endpoints.dart';
import '../models/myth_fact.dart';
import 'api_service.dart';

class SuperstitionService {
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

    // Verified scientific fallback matching Figma design
    return MythFact(
      id: 'default-lunar-myth',
      title: 'Full Moon Farming',
      myth: 'Does planting by the full moon guarantee a better harvest?',
      fact: 'Crop success depends on soil health, irrigation and sunlight—not lunar phases.',
      explanation: 'Extensive agricultural trials confirm that soil nutrients, balanced NPK, certified seeds, and timely irrigation drive crop yields.',
      category: 'agriculture',
    );
  }

  static final List<MythFact> defaultMyths = [
    MythFact(
      id: '1',
      title: 'Pesticide Scheduling',
      myth: 'Spraying pesticides on a set calendar schedule prevents all crop diseases...',
      fact: 'Calendar spraying breeds pesticide resistance in pests and wastes money. Adopt Integrated Pest Management (IPM).',
      explanation: 'Indiscriminate pesticide applications kill beneficial natural predators and elevate chemical resistance.',
      category: 'agriculture',
    ),
    MythFact(
      id: '2',
      title: 'Full Moon Farming',
      myth: 'Does planting by the full moon guarantee a better harvest?',
      fact: 'Crop success depends on soil health, irrigation and sunlight—not lunar phases.',
      explanation: 'Soil nutrients, certified seeds, and balanced moisture dictate seed germination.',
      category: 'agriculture',
    ),
    MythFact(
      id: '3',
      title: 'Chemical Fertilizer Immunity',
      myth: 'Applying double urea will double crop yield.',
      fact: 'Excess nitrogen burns root tips, degrades soil pH, and invites pest infestations.',
      explanation: 'Excess urea causes vegetative overgrowth without seed development.',
      category: 'soil',
    ),
    MythFact(
      id: '4',
      title: 'Livestock Vaccination',
      myth: 'Vaccinating cattle reduces milk yield permanently.',
      fact: 'Temporary milk drop lasts only 24 hours while protecting cattle from fatal FMD and HS diseases.',
      explanation: 'FMD vaccination saves livestock from crippling viral infection.',
      category: 'animal',
    ),
  ];

  static Future<List<MythFact>> getAllMyths() async {
    try {
      final response = await ApiService.get(ApiEndpoints.superstitions);
      if (response.success && response.data != null) {
        final list = response.data is List ? response.data as List : (response.data['records'] as List? ?? []);
        if (list.isNotEmpty) {
          return list.map((item) => MythFact.fromJson(Map<String, dynamic>.from(item))).toList();
        }
      }
    } catch (_) {}

    return defaultMyths;
  }
}
