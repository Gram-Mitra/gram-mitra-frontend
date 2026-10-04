import '../core/constants/api_endpoints.dart';
import '../models/village_problem.dart';
import 'api_service.dart';

class ProblemService {
  static Future<List<VillageProblem>> getProblems() async {
    try {
      final response = await ApiService.get(ApiEndpoints.villageProblems);
      if (response.success && response.data != null) {
        final list = response.data is List ? response.data as List : (response.data['problems'] as List? ?? []);
        return list.map((item) => VillageProblem.fromJson(Map<String, dynamic>.from(item))).toList();
      }
    } catch (_) {}

    return [
      VillageProblem(
        id: 'vp-1',
        title: 'Borewell handpump broken near Primary School',
        description: 'Villagers have to walk 2 km for clean drinking water. Handle piston needs replacement.',
        category: 'water',
        priority: 'urgent',
        status: 'in_progress',
        village: 'Palghar Village',
        district: 'Palghar',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      VillageProblem(
        id: 'vp-2',
        title: 'Agricultural feeder transformer tripped after lightning',
        description: '3 tube wells non-functional, Kharif crop irrigation stalled.',
        category: 'electricity',
        priority: 'high',
        status: 'under_review',
        village: 'Saphale',
        district: 'Palghar',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
      VillageProblem(
        id: 'vp-3',
        title: 'Approach bridge road damaged during heavy rain',
        description: 'Potholes prevent milk tempo access to dairy chilling center.',
        category: 'road',
        priority: 'medium',
        status: 'resolved',
        village: 'Manor',
        district: 'Palghar',
        createdAt: DateTime.now().subtract(const Duration(days: 9)),
      ),
    ];
  }

  static Future<bool> reportProblem({
    required String title,
    required String description,
    required String category,
    required String priority,
    String? village = 'Palghar',
    String? district = 'Palghar',
  }) async {
    final payload = {
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'village': village,
      'district': district,
    };

    final response = await ApiService.post(ApiEndpoints.villageProblems, payload);
    return response.success;
  }
}
