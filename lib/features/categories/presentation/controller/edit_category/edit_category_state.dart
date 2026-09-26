part of 'edit_category_cubit.dart';

enum EditCategoryStatus { initial, loading, error, success }

class EditCategoryState extends Equatable {
  final bool? isFeatured;
  final EditCategoryStatus status;
  final String? errorMessage;
  final String imageUrl;
  final CategoryEntity selectedParent;

  const EditCategoryState({
    this.errorMessage,
    this.status = EditCategoryStatus.initial,
    this.imageUrl = '',
    this.selectedParent = CategoryEntity.empty,
    this.isFeatured,
  });

  EditCategoryState copyWith({
    EditCategoryStatus? status,
    String? errorMessage,
    CategoryEntity? selectedParent,
    String? imageUrl,
    bool? isFeatured,
  }) {
    return EditCategoryState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedParent: selectedParent ?? this.selectedParent,
      imageUrl: imageUrl ?? this.imageUrl,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }

  @override
  List<Object?> get props => [
    status,
    isFeatured,
    errorMessage,
    selectedParent,
    imageUrl,
  ];
}

