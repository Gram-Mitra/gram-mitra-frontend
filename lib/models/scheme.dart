/// Government Scheme representation from scheme.service.js and data.gov.in
class Scheme {
  final String id;
  final String title;
  final String description;
  final String? benefits;
  final String? eligibility;
  final String? category;
  final String? howToApply;
  final String? officialUrl;

  Scheme({
    required this.id,
    required this.title,
    required this.description,
    this.benefits,
    this.eligibility,
    this.category,
    this.howToApply,
    this.officialUrl,
  });

  factory Scheme.fromJson(Map<String, dynamic> json) {
    return Scheme(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      benefits: json['benefits']?.toString(),
      eligibility: json['eligibility']?.toString(),
      category: json['category']?.toString(),
      howToApply: json['howToApply']?.toString() ?? json['how_to_apply']?.toString(),
      officialUrl: json['officialUrl']?.toString() ?? json['url']?.toString(),
    );
  }
}
