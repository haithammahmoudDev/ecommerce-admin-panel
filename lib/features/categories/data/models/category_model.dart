import '../../domain/entities/category_entity.dart';

class CategoryModel {
  String id;
  final String name;
  final String image;
  final String parentId;
  final bool isFeatured;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    this.parentId = '',
    this.isFeatured = false,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(
      id: entity.id,
      name: entity.name,
      image: entity.image,
      parentId: entity.parentId,
      isFeatured: entity.isFeatured,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'parentId': parentId,
      'isFeatured': isFeatured,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      parentId: json['parentId'] ?? '',
      isFeatured: json['isFeatured'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }

  factory CategoryModel.fromFirebaseJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      parentId: json['parentId'] ?? '',
      isFeatured: json['isFeatured'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? image,
    String? parentId,
    bool? isFeatured,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      parentId: parentId ?? this.parentId,
      isFeatured: isFeatured ?? this.isFeatured,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      image: image,
      parentId: parentId,
      isFeatured: isFeatured,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}