import 'package:bloc/bloc.dart';
import 'package:ecommerce_admin_pannal/features/categories/domain/entities/category_entity.dart';
import 'package:ecommerce_admin_pannal/features/categories/domain/repos/category_repo.dart';
import 'package:ecommerce_admin_pannal/features/categories/presentation/controller/category/category_cubit.dart';
import 'package:ecommerce_admin_pannal/features/media/domain/entities/image_entity.dart';
import 'package:ecommerce_admin_pannal/features/media/presentation/controller/media_cubit/media_cubit.dart';
import 'package:ecommerce_admin_pannal/utils/popups/exports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../utils/helpers/network_manager.dart';
import '../../../data/models/category_model.dart';
import 'create_category_state.dart';

class CreateCategoryCubit extends Cubit<CreateCategoryState> {
  final CategoryRepo _categoryRepo;
  CreateCategoryCubit({required this._categoryRepo})
    : super(CreateCategoryState());

  void selectParentCategory(CategoryEntity category) {
    emit(state.copyWith(selectedParent: category));
  }

  void clearParentCategory() {
    emit(state.copyWith(selectedParent: null));
  }

  void toggleFeatured(bool? value) {
    emit(state.copyWith(isFeatured: value ?? false));
  }

  Future<void> createCategory({
    required TextEditingController nameController,
    required BuildContext context,
  }) async {
    if (nameController.text.trim().isEmpty) {
      TLoaders.errorSnackBar(
        title: 'Oh Snap',
        message: 'Please enter a category name',
        context: context,
      );
      return;
    }

    TFullScreenLoader.popUpCircular(context);

    final bool isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) {
      TFullScreenLoader.stopLoading(context);
      return;
    }

    final CategoryModel newRecord = CategoryModel(
      name: nameController.text.trim(),
      image: state.imageUrl,
      id: '',
      createdAt: DateTime.now(),
      isFeatured: state.isFeatured,
      parentId: state.selectedParent.id,
    );

    final result = await _categoryRepo.createCategory(category: newRecord);
    result.fold(
      (error) {
        TFullScreenLoader.stopLoading(context);
        TLoaders.errorSnackBar(
          title: 'Oh Snap',
          message: error.message,
          context: context,
        );
      },
      (categoryId) {
        newRecord.id = categoryId;
        final categoryController = context.read<CategoryCubit>();
        categoryController.addItemToLists(newRecord.toEntity());
        TFullScreenLoader.stopLoading(context);
        TLoaders.successSnackBar(
          title: 'Congratulations',
          message: 'New Record has been added.',
          context: context,
        );
        categoryController.fetchData();
        context.pop();
      },
    );
  }

  Future<void> pickImage(BuildContext context) async {
    final controller = context.read<MediaCubit>();
    final selectedImages = await controller.selectImagesFromMedia(
      context: context,
    );

    if (selectedImages != null && selectedImages.isNotEmpty) {
      final ImageEntity selectedImage = selectedImages.first;
      emit(state.copyWith(imageUrl: selectedImage.url));
    }
  }
}
