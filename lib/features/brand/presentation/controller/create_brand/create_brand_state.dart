part of 'create_brand_cubit.dart';

enum CreateBrandStatus { initial, loading, error, success }

class CreateBrandState extends Equatable {
  final bool isFeatured;
  final CreateBrandStatus status;
  final String? errorMessage;
  final String imageUrl;
  final List<CategoryEntity> selectedCategories;

  CreateBrandState({
    this.errorMessage,
    this.status = CreateBrandStatus.initial,
    this.imageUrl = '',
    this.isFeatured = false,
    this.selectedCategories= const[],
  });

  @override
  List<Object?> get props => [isFeatured, status, errorMessage, imageUrl, selectedCategories];

  CreateBrandState copyWith({
    CreateBrandStatus? status,
    String? errorMessage,
    List<CategoryEntity>? selectedCategories,
    String? imageUrl,
    bool? isFeatured,
  }) {
    return CreateBrandState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      imageUrl: imageUrl ?? this.imageUrl,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }
}
