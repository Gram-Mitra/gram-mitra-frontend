/// Maps to the `myths` table in Supabase PostgreSQL
class MythFact {
  final String id;
  final String title;
  final String myth;
  final String fact;
  final String? explanation;
  final String? category;
  final String? language;
  final bool isVerified;

  MythFact({
    required this.id,
    required this.title,
    required this.myth,
    required this.fact,
    this.explanation,
    this.category,
    this.language = 'en',
    this.isVerified = true,
  });

  factory MythFact.fromJson(Map<String, dynamic> json) {
    return MythFact(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      myth: json['myth']?.toString() ?? '',
      fact: json['fact']?.toString() ?? '',
      explanation: json['explanation']?.toString(),
      category: json['category']?.toString(),
      language: json['language']?.toString() ?? 'en',
      isVerified: json['is_verified'] == true || json['isVerified'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'myth': myth,
      'fact': fact,
      'explanation': explanation,
      'category': category,
      'language': language,
      'is_verified': isVerified,
    };
  }
}
