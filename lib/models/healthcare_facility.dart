/// Maps to the `hospitals` and `hospital_services` tables in Supabase PostgreSQL
class HealthcareFacility {
  final String id;
  final String name;
  final String type; // 'human' or 'animal'
  final String? address;
  final String? state;
  final String? district;
  final String? village;
  final String? phone;
  final String? email;
  final bool isEmergency;
  final List<String> services;

  HealthcareFacility({
    required this.id,
    required this.name,
    required this.type,
    this.address,
    this.state,
    this.district,
    this.village,
    this.phone,
    this.email,
    this.isEmergency = false,
    this.services = const [],
  });

  factory HealthcareFacility.fromJson(Map<String, dynamic> json) {
    List<String> parsedServices = [];
    if (json['services'] is List) {
      for (var s in json['services']) {
        if (s is String) {
          parsedServices.add(s);
        } else if (s is Map && s['service_name'] != null) {
          parsedServices.add(s['service_name'].toString());
        }
      }
    } else if (json['hospital_services'] is List) {
      for (var s in json['hospital_services']) {
        if (s is Map && s['service_name'] != null) {
          parsedServices.add(s['service_name'].toString());
        }
      }
    }

    return HealthcareFacility(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? 'human',
      address: json['address']?.toString(),
      state: json['state']?.toString(),
      district: json['district']?.toString(),
      village: json['village']?.toString(),
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
      isEmergency: json['is_emergency'] == true || json['isEmergency'] == true,
      services: parsedServices,
    );
  }
}
