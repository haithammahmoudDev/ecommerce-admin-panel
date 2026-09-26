part of 'edit_brand_cubit.dart';

 enum EditBrandStatus { initial, loading, error, success }

class EditBrandState extends Equatable {
  final bool? isFeatured;
  final EditBrandStatus status;
  final String? errorMessage;
  final String imageUrl;
  final List<CategoryEntity> selectedCategories;

  const EditBrandState({
    this.errorMessage,
    this.status = EditBrandStatus.initial,
    this.imageUrl = '',
    this.selectedCategories = const [],
    this.isFeatured,
  });

  EditBrandState copyWith({
    EditBrandStatus? status,
    String? errorMessage,
    List<CategoryEntity>? selectedCategories,
    String? imageUrl,
    bool? isFeatured,
  }) {
    return EditBrandState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      imageUrl: imageUrl ?? this.imageUrl,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }

  @override
  List<Object?> get props => [
    status,
    isFeatured,
    errorMessage,
    selectedCategories,
    imageUrl,
  ];
}

