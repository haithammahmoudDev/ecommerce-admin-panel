part of 'product_attributes_cubit.dart';



class ProductAttributesState extends Equatable {
  final bool isLoading;
  final List<ProductAttributeEntity> productAttributes;

  const ProductAttributesState({
    this.isLoading = false,
    this.productAttributes = const [],
  });

  ProductAttributesState copyWith({
    bool? isLoading,
    List<ProductAttributeEntity>? productAttributes,
  }) {
    return ProductAttributesState(
      isLoading: isLoading ?? this.isLoading,
      productAttributes: productAttributes ?? this.productAttributes,
    );
  }

  @override
  List<Object?> get props => [isLoading, productAttributes];
}
