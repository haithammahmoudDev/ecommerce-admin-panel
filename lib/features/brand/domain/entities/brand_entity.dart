import '../../../../utils/formatters/formatter.dart';
import '../../../categories/domain/entities/category_entity.dart';

class BrandEntity {
  final String id;
  final String name;
  final String image;
  final bool isFeatured;
  final int? productsCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  List<CategoryEntity>? brandCategories;

  BrandEntity({
    required this.id,
    required this.name,
    required this.image,
    this.isFeatured = false,
    this.productsCount,
    this.createdAt,
    this.updatedAt,
    this.brandCategories,
  });

  BrandEntity copyWith({
    String? id,
    String? name,
    String? image,
    bool? isFeatured,
    int? productsCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<CategoryEntity>? brandCategories,
  }) {
    return BrandEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      isFeatured: isFeatured ?? this.isFeatured,
      productsCount: productsCount ?? this.productsCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      brandCategories: brandCategories ?? this.brandCategories,
    );
  }

  static final BrandEntity empty = BrandEntity(id: '', image: '', name: '');
  String get getFormattedDate => TFormatter.formatDate(createdAt);
  String get getFormattedUpdateDate => TFormatter.formatDate(updatedAt);
}
