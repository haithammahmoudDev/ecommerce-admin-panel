import 'package:bloc/bloc.dart';
import 'package:ecommerce_admin_pannal/features/categories/domain/entities/category_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum CreateCategoryStatus { initial, loading, error, success }

class CreateCategoryState extends Equatable {
  final bool isFeatured;
  final CreateCategoryStatus status;
  final String? errorMessage;
  final String imageUrl;
  final CategoryEntity selectedParent;

  const CreateCategoryState({
    this.errorMessage,
    this.status = CreateCategoryStatus.initial,
    this.imageUrl = '',
    this.selectedParent =   CategoryEntity.empty,
    this.isFeatured = false,
  });

  CreateCategoryState copyWith({
    CreateCategoryStatus? status,
    String? errorMessage,
    CategoryEntity? selectedParent,
    String? imageUrl,
    bool? isFeatured,
  }) {
    return CreateCategoryState(
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
