import '../core/constants/api_endpoints.dart';
import '../models/product.dart';
import 'api_service.dart';

class MarketplaceService {
  static Future<List<Product>> getProducts() async {
    try {
      final response = await ApiService.get(ApiEndpoints.marketplaceProducts);
      if (response.success && response.data != null) {
        final list = response.data is List ? response.data as List : (response.data['products'] as List? ?? []);
        return list.map((item) => Product.fromJson(Map<String, dynamic>.from(item))).toList();
      }
    } catch (_) {}

    return [
      Product(
        id: 'p1',
        name: 'Organic Kolam Rice (Paddy)',
        description: 'Freshly harvested unpolished chemical-free Kolam grain from Palghar farms.',
        category: 'Crops & Grains',
        price: 45.0,
        unit: 'kg',
        quantity: 500.0,
        location: 'Saphale East, Palghar',
        district: 'Palghar',
      ),
      Product(
        id: 'p2',
        name: 'Certified Hybrid Bajra Seeds',
        description: 'Drought-resistant high yield variety suitable for local loam soils.',
        category: 'Seeds & Fertilizers',
        price: 180.0,
        unit: 'kg',
        quantity: 40.0,
        location: 'Manor Road, Palghar',
        district: 'Palghar',
      ),
      Product(
        id: 'p3',
        name: 'Vermicompost Organic Fertilizer',
        description: 'Earthworm enriched organic manure for vegetables and flowering crops.',
        category: 'Seeds & Fertilizers',
        price: 12.0,
        unit: 'kg',
        quantity: 1200.0,
        location: 'Boisar Rural, Palghar',
        district: 'Palghar',
      ),
      Product(
        id: 'p4',
        name: 'Fresh Dairy Cattle Green Fodder',
        description: 'High protein Napier grass bundles harvested daily.',
        category: 'Cattle Feed',
        price: 6.0,
        unit: 'kg',
        quantity: 800.0,
        location: 'Dahanu Road, Palghar',
        district: 'Palghar',
      ),
    ];
  }
}
