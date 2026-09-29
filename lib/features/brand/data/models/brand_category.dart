import '../../domain/entities/brand_category_entity.dart';

class BrandCategoryModel {
  String id;
  final String brandId;
  final String categoryId;

  BrandCategoryModel({
    this.id = '',
    required this.brandId,
    required this.categoryId,
  });

  BrandCategoryEntity toEntity() {
    return BrandCategoryEntity(
      id: id,
      brandId: brandId,
      categoryId: categoryId,
    );
  }

  factory BrandCategoryModel.fromEntity(BrandCategoryEntity entity) {
    return BrandCategoryModel(
      id: entity.id,
      brandId: entity.brandId,
      categoryId: entity.categoryId,
    );
  }

  factory BrandCategoryModel.fromFirebaseData(
    Map<String, dynamic> data, {
    String? docId,
  }) {
    return BrandCategoryModel(
      id: docId ?? data['Id'] ?? data['id'] ?? '',
      brandId: data['BrandId'] ?? data['brandId'] ?? '',
      categoryId: data['CategoryId'] ?? data['categoryId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'BrandId': brandId, 'CategoryId': categoryId};
  }
}
