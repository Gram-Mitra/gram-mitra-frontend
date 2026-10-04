/// Maps to the `products` table in Supabase PostgreSQL
class Product {
  final String id;
  final String name;
  final String? description;
  final String? category;
  final double price;
  final String unit;
  final double quantity;
  final String? imageUrl;
  final String? location;
  final String? district;
  final bool isAvailable;

  Product({
    required this.id,
    required this.name,
    this.description,
    this.category,
    required this.price,
    this.unit = 'kg',
    required this.quantity,
    this.imageUrl,
    this.location,
    this.district,
    this.isAvailable = true,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      category: json['category']?.toString(),
      price: json['price'] is num ? (json['price'] as num).toDouble() : double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      unit: json['unit']?.toString() ?? 'kg',
      quantity: json['quantity'] is num ? (json['quantity'] as num).toDouble() : double.tryParse(json['quantity']?.toString() ?? '1') ?? 1.0,
      imageUrl: json['image_url']?.toString() ?? json['imageUrl']?.toString(),
      location: json['location']?.toString(),
      district: json['district']?.toString(),
      isAvailable: json['is_available'] == true || json['isAvailable'] == true,
    );
  }
}
