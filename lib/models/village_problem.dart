/// Maps to the `village_problems` table in Supabase PostgreSQL
class VillageProblem {
  final String id;
  final String title;
  final String? description;
  final String category;
  final String priority;
  final String status;
  final String? village;
  final String? district;
  final String? imageUrl;
  final DateTime? createdAt;

  VillageProblem({
    required this.id,
    required this.title,
    this.description,
    required this.category,
    this.priority = 'medium',
    this.status = 'reported',
    this.village,
    this.district,
    this.imageUrl,
    this.createdAt,
  });

  factory VillageProblem.fromJson(Map<String, dynamic> json) {
    return VillageProblem(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      category: json['category']?.toString() ?? 'other',
      priority: json['priority']?.toString() ?? 'medium',
      status: json['status']?.toString() ?? 'reported',
      village: json['village']?.toString(),
      district: json['district']?.toString(),
      imageUrl: json['image_url']?.toString() ?? json['imageUrl']?.toString(),
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    );
  }
}
