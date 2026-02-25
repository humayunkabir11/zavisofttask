import '../../domain/entities/product_entity.dart';

/// Data model that maps the JSON from https://fakestoreapi.com/products
class ProductModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double ratingRate;
  final int ratingCount;

  const ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.ratingRate,
    required this.ratingCount,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final rating = json['rating'] as Map<String, dynamic>? ?? {};
    return ProductModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      image: json['image'] as String? ?? '',
      ratingRate: (rating['rate'] as num?)?.toDouble() ?? 0.0,
      ratingCount: rating['count'] as int? ?? 0,
    );
  }

  /// Convert to domain entity — keeps data/domain layers decoupled
  Product toEntity() => Product(
        id: id,
        title: title,
        price: price,
        description: description,
        category: category,
        image: image,
        ratingRate: ratingRate,
        ratingCount: ratingCount,
      );
}
