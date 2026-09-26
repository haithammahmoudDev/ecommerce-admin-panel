 import 'package:equatable/equatable.dart';

class ProductImagesState extends Equatable {
  final String? selectedThumbnailImageUrl;
  final List<String> additionalProductImagesUrls;
  final bool isLoading;

  const ProductImagesState({
    this.selectedThumbnailImageUrl,
    this.additionalProductImagesUrls = const [],
    this.isLoading = false,
  });

  ProductImagesState copyWith({
    String? selectedThumbnailImageUrl,
    List<String>? additionalProductImagesUrls,
    bool? isLoading,
  }) {
    return ProductImagesState(
      selectedThumbnailImageUrl:
      selectedThumbnailImageUrl ?? this.selectedThumbnailImageUrl,
      additionalProductImagesUrls:
      additionalProductImagesUrls ?? this.additionalProductImagesUrls,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
    selectedThumbnailImageUrl,
    additionalProductImagesUrls,
    isLoading,
  ];
}