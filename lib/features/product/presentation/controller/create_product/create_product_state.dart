part of 'create_product_cubit.dart';


enum CreateProductStatus { initial, loading, success, error }

class CreateProductState extends Equatable {
  final CreateProductStatus status;
  final String? errorMessage;
  final ProductType productType;
  final ProductVisibility productVisibility;
  final BrandEntity? selectedBrand;
  final List<CategoryEntity> selectedCategories;
  final bool isThumbnailLoading;
  final bool isAdditionalImagesLoading;
  final bool thumbnailUploader;
  final bool additionalImagesUploader;
  final bool productDataUploader;
  final bool categoriesRelationshipUploader;

  const CreateProductState({
    this.status = CreateProductStatus.initial,
    this.errorMessage,
    this.productType = ProductType.single,
    this.productVisibility = ProductVisibility.hidden,
    this.selectedBrand,
    this.selectedCategories = const [],
    this.isThumbnailLoading = false,
    this.isAdditionalImagesLoading = false,
    this.thumbnailUploader = false,
    this.additionalImagesUploader = false,
    this.productDataUploader = false,
    this.categoriesRelationshipUploader = false,
  });

  CreateProductState copyWith({
    CreateProductStatus? status,
    String? errorMessage,
    ProductType? productType,
    ProductVisibility? productVisibility,
    BrandEntity? selectedBrand,
    List<CategoryEntity>? selectedCategories,
    bool? isThumbnailLoading,
    bool? isAdditionalImagesLoading,
    bool? thumbnailUploader,
    bool? additionalImagesUploader,
    bool? productDataUploader,
    bool? categoriesRelationshipUploader,
  }) {
    return CreateProductState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      productType: productType ?? this.productType,
      productVisibility: productVisibility ?? this.productVisibility,
      selectedBrand: selectedBrand ?? this.selectedBrand,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      isThumbnailLoading: isThumbnailLoading ?? this.isThumbnailLoading,
      isAdditionalImagesLoading: isAdditionalImagesLoading ?? this.isAdditionalImagesLoading,
      thumbnailUploader: thumbnailUploader ?? this.thumbnailUploader,
      additionalImagesUploader: additionalImagesUploader ?? this.additionalImagesUploader,
      productDataUploader: productDataUploader ?? this.productDataUploader,
      categoriesRelationshipUploader: categoriesRelationshipUploader ?? this.categoriesRelationshipUploader,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    productType,
    productVisibility,
    selectedBrand,
    selectedCategories,
    isThumbnailLoading,
    isAdditionalImagesLoading,
    thumbnailUploader,
    additionalImagesUploader,
    productDataUploader,
    categoriesRelationshipUploader,
  ];
}