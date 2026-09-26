part of 'edit_product_cubit.dart';

class EditProductState extends Equatable {
  final ProductType productType;
  final ProductVisibility productVisibility;
  final BrandEntity? selectedBrand;
  final List<CategoryEntity> selectedCategories;
  final List<CategoryEntity> alreadyAddedCategories;

  // Media & Data Loading States
  final bool isThumbnailLoading;
  final bool isAdditionalImagesLoading;
  final bool isCategoriesLoading;

  // Progress Indicators
  final bool thumbnailUploader;
  final bool additionalImagesUploader;
  final bool productDataUploader;
  final bool categoriesRelationshipUploader;

  const EditProductState({
    this.productType = ProductType.single,
    this.productVisibility = ProductVisibility.hidden,
    this.selectedBrand,
    this.selectedCategories = const [],
    this.alreadyAddedCategories = const [],
    this.isThumbnailLoading = false,
    this.isAdditionalImagesLoading = false,
    this.isCategoriesLoading = false,
    this.thumbnailUploader = false,
    this.additionalImagesUploader = false,
    this.productDataUploader = false,
    this.categoriesRelationshipUploader = false,
  });

  EditProductState copyWith({
    ProductType? productType,
    ProductVisibility? productVisibility,
    BrandEntity? selectedBrand,
    List<CategoryEntity>? selectedCategories,
    List<CategoryEntity>? alreadyAddedCategories,
    bool? isThumbnailLoading,
    bool? isAdditionalImagesLoading,
    bool? isCategoriesLoading,
    bool? thumbnailUploader,
    bool? additionalImagesUploader,
    bool? productDataUploader,
    bool? categoriesRelationshipUploader,
  }) {
    return EditProductState(
      productType: productType ?? this.productType,
      productVisibility: productVisibility ?? this.productVisibility,
      selectedBrand: selectedBrand ?? this.selectedBrand,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      alreadyAddedCategories: alreadyAddedCategories ?? this.alreadyAddedCategories,
      isThumbnailLoading: isThumbnailLoading ?? this.isThumbnailLoading,
      isAdditionalImagesLoading: isAdditionalImagesLoading ?? this.isAdditionalImagesLoading,
      isCategoriesLoading: isCategoriesLoading ?? this.isCategoriesLoading,
      thumbnailUploader: thumbnailUploader ?? this.thumbnailUploader,
      additionalImagesUploader: additionalImagesUploader ?? this.additionalImagesUploader,
      productDataUploader: productDataUploader ?? this.productDataUploader,
      categoriesRelationshipUploader: categoriesRelationshipUploader ?? this.categoriesRelationshipUploader,
    );
  }

  @override
  List<Object?> get props => [
    productType,
    productVisibility,
    selectedBrand,
    selectedCategories,
    alreadyAddedCategories,
    isThumbnailLoading,
    isAdditionalImagesLoading,
    isCategoriesLoading,
    thumbnailUploader,
    additionalImagesUploader,
    productDataUploader,
    categoriesRelationshipUploader,
  ];
}