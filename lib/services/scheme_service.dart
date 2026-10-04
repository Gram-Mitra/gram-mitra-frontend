import '../core/constants/api_endpoints.dart';
import '../models/scheme.dart';
import 'api_service.dart';

class SchemeService {
  static Future<List<Scheme>> getSchemes() async {
    try {
      final response = await ApiService.get(ApiEndpoints.schemesCatalog);
      if (response.success && response.data != null) {
        final list = response.data is List ? response.data as List : (response.data['schemes'] as List? ?? []);
        return list.map((item) => Scheme.fromJson(Map<String, dynamic>.from(item))).toList();
      }
    } catch (_) {}

    return [
      Scheme(
        id: 'pm-kisan',
        title: 'PM-KISAN Samman Nidhi',
        description: 'Direct income support of ₹6,000 per year in three equal installments to all landholding farmers families.',
        benefits: '₹6,000 / year deposited directly into Aadhaar-linked bank accounts.',
        eligibility: 'All small & marginal farmer families holding cultivable land in their names.',
        category: 'Income Support',
        howToApply: 'Register online via pmkisan.gov.in or visit local Gram Panchayat / CSC Kendra.',
      ),
      Scheme(
        id: 'pmfby',
        title: 'Pradhan Mantri Fasal Bima Yojana (PMFBY)',
        description: 'Comprehensive risk insurance covering yield losses due to non-preventable natural risks like drought, flood, pests.',
        benefits: 'Premium only 2% for Kharif crops, 1.5% for Rabi crops, subsidized claims.',
        eligibility: 'All farmers growing notified crops in notified areas including sharecroppers and tenant farmers.',
        category: 'Crop Insurance',
        howToApply: 'Apply through your bank branch, CSC, or portal at pmfby.gov.in before sowing deadline.',
      ),
      Scheme(
        id: 'pmay-g',
        title: 'Pradhan Mantri Awaas Yojana - Gramin',
        description: 'Financial assistance for construction of pucca houses with basic amenities for homeless rural families.',
        benefits: 'Up to ₹1.20 Lakh assistance in plains, ₹1.30 Lakh in hilly areas plus 90 days MGNREGA wages.',
        eligibility: 'Families with no pucca house as identified by SECC 2011 Gram Sabha list.',
        category: 'Housing',
        howToApply: 'Beneficiary selection conducted through Gram Sabha resolution.',
      ),
      Scheme(
        id: 'kcc',
        title: 'Kisan Credit Card (KCC)',
        description: 'Timely and adequate credit support from the banking system for agricultural inputs and animal husbandry.',
        benefits: 'Loans up to ₹3 Lakh at concessional interest rate of 4% per annum (with prompt repayment).',
        eligibility: 'Individual/joint farmers, tenant farmers, oral lessees, and SHGs.',
        category: 'Credit & Loans',
        howToApply: 'Submit one-page form at any cooperative bank, RRB, or commercial bank.',
      ),
    ];
  }
}
