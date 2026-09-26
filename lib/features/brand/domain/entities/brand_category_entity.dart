import 'package:equatable/equatable.dart';

class BrandCategoryEntity extends Equatable {
  final String id;
  final String brandId;
  final String categoryId;

  const BrandCategoryEntity({
      this.id = '',
    required this.brandId,
    required this.categoryId,
  });

  /// Empty Helper Function
  static BrandCategoryEntity empty() => const BrandCategoryEntity(
    id: '',
    brandId: '',
    categoryId: '',
  );

  @override
  List<Object?> get props => [id, brandId, categoryId];
}