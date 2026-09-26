import 'package:equatable/equatable.dart';

class ProductCategoryEntity extends Equatable {
  final String productId;
  final String categoryId;

  const ProductCategoryEntity({
    required this.productId,
    required this.categoryId,
  });

  @override
  List<Object?> get props => [productId, categoryId];
}