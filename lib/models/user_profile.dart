/// Strictly maps to the `profiles` table in Supabase PostgreSQL
class UserProfile {
  final String id;
  final String? fullName;
  final String? phone;
  final String? email;
  final int? age;
  final String? state;
  final String? district;
  final String? village;
  final String? profileImageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfile({
    required this.id,
    this.fullName,
    this.phone,
    this.email,
    this.age,
    this.state,
    this.district,
    this.village,
    this.profileImageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? json['fullName']?.toString(),
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
      age: json['age'] is num ? (json['age'] as num).toInt() : int.tryParse(json['age']?.toString() ?? ''),
      state: json['state']?.toString(),
      district: json['district']?.toString(),
      village: json['village']?.toString(),
      profileImageUrl: json['profile_image_url']?.toString() ?? json['profileImageUrl']?.toString(),
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'phone': phone,
      'email': email,
      'age': age,
      'state': state,
      'district': district,
      'village': village,
      'profile_image_url': profileImageUrl,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  UserProfile copyWith({
    String? id,
    String? fullName,
    String? phone,
    String? email,
    int? age,
    String? state,
    String? district,
    String? village,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      age: age ?? this.age,
      state: state ?? this.state,
      district: district ?? this.district,
      village: village ?? this.village,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
