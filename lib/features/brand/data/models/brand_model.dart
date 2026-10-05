import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../categories/domain/entities/category_entity.dart';
import '../../domain/entities/brand_entity.dart';

class BrandModel {
  String id;
  final String name;
  final String image;
  final bool isFeatured;
  final int? productsCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  List<CategoryEntity>? brandCategories;

  BrandModel({
    required this.id,
    required this.image,
    required this.name,
    this.isFeatured = false,
    this.productsCount,
    this.createdAt,
    this.updatedAt,
    this.brandCategories,
  });

  BrandEntity toEntity() {
    return BrandEntity(
      id: id,
      name: name,
      image: image,
      isFeatured: isFeatured,
      productsCount: productsCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
      brandCategories: brandCategories,
    );
  }

  factory BrandModel.empty() => BrandModel(
    id: '',
    name: '',
    image: '',
    isFeatured: false,
    productsCount: 0,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    brandCategories: const [],
  );

   factory BrandModel.fromEntity(BrandEntity? entity) {
    if (entity == null) return BrandModel.empty();
    return BrandModel(
      id: entity.id,
      name: entity.name,
      image: entity.image,
      isFeatured: entity.isFeatured,
      productsCount: entity.productsCount,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      brandCategories: entity.brandCategories,
    );
  }

  factory BrandModel.fromFirebaseData(
    Map<String, dynamic> data, {
    String? docId,
  }) {
    return BrandModel(
      id: docId ?? data['id']?.toString() ?? '',
      name: data['name'] ?? '',
      image: data['image'] ?? '',
      isFeatured: data['isFeatured'] ?? false,
      productsCount: data['productCounts'] ?? 0,
      createdAt: data.containsKey('createdAt')
          ? (data['createdAt'] as Timestamp?)?.toDate()
          : null,
      updatedAt: data.containsKey('updatedAt')
          ? (data['updatedAt'] as Timestamp?)?.toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'isFeatured': isFeatured,
      'productCounts': productsCount ?? 0,
      'createdAt': createdAt,
      'updatedAt': updatedAt ?? DateTime.now(),
    };
  }

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      isFeatured: json['isFeatured'] ?? false,
      productsCount: json['productCounts'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }
}
