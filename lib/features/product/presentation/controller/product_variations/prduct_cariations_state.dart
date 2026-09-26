part of 'prduct_cariations_cubit.dart';


class ProductVariationsState extends Equatable {
  final bool isLoading;
  List<ProductVariationEntity> productVariations;

    ProductVariationsState({
    this.isLoading = false,
    this.productVariations = const [],
  });

  ProductVariationsState copyWith({
    bool? isLoading,
    List<ProductVariationEntity>? productVariations,
  }) {
    return ProductVariationsState(
      isLoading: isLoading ?? this.isLoading,
      productVariations: productVariations ?? this.productVariations,
    );
  }

  @override
  List<Object?> get props => [isLoading, productVariations];
}
