 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin_pannal/features/categories/domain/repos/category_repo.dart';
import 'package:ecommerce_admin_pannal/features/media/domain/entities/image_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../utils/helpers/network_manager.dart';
import '../../../../../utils/popups/full_screen_loader.dart';
import '../../../../../utils/popups/loaders.dart';
import '../../../../media/presentation/controller/media_cubit/media_cubit.dart';
import '../../../data/models/category_model.dart';
import '../../../domain/entities/category_entity.dart';
import '../category/category_cubit.dart';

part 'edit_category_state.dart';

class EditCategoryCubit extends Cubit<EditCategoryState> {
  final CategoryRepo _categoryRepo;
  EditCategoryCubit({required this._categoryRepo}) : super(EditCategoryState());

  Future<void> init(CategoryEntity category) async {
    emit(state.copyWith(
      imageUrl: category.image,
      isFeatured: category.isFeatured,
    ));

    if (category.parentId.isEmpty) {
       return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('categories')
          .doc(category.parentId)
          .get();

      final data = doc.data();
      if (data == null) return;

      final parentEntity = CategoryEntity(
        id: doc.id,
        name: data['name'] ?? '',
        image: data['image'] ?? '',
        parentId: data['parentId'],
        isFeatured: data['isFeatured'] ?? false,
      );

      emit(state.copyWith(selectedParent: parentEntity));
    } catch (_) {

    }
  }

  void selectParentCategory(CategoryEntity category) {
    emit(state.copyWith(selectedParent: category));
  }

  void toggleFeatured(bool? value) {
    emit(state.copyWith(isFeatured: value ?? false));
  }

  Future<void> editCategory({
    required TextEditingController nameController,
    required BuildContext context,
    required String id,
  }) async {
    TFullScreenLoader.popUpCircular(context);

    final bool isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) {
      TFullScreenLoader.stopLoading(context);
      return;
    }

    final CategoryModel newRecord = CategoryModel(
      name: nameController.text.trim(),
      image: state.imageUrl,
      id: id,
      createdAt: DateTime.now(),
      isFeatured: state.isFeatured ?? false,
      parentId: state.selectedParent.id,
    );

    final result = await _categoryRepo.editCategory(category: newRecord);

    result.fold(
          (error) {
        TFullScreenLoader.stopLoading(context);
        TLoaders.errorSnackBar(title: 'Oh Snap', message: error.message, context: context);
      },
          (_) {
        final categoryController = context.read<CategoryCubit>();

         categoryController.updateItemInLists(newRecord.toEntity());

         TFullScreenLoader.stopLoading(context);
        TLoaders.successSnackBar(title: 'Congratulations', message: 'Record updated successfully.', context: context);
        context.pop();
      },
    );
  }

  Future<void> pickImage(BuildContext context) async {
    final controller = context.read<MediaCubit>();
    final selectedImages = await controller.selectImagesFromMedia(context: context);

    if (selectedImages != null && selectedImages.isNotEmpty) {
      final ImageEntity selectedImage = selectedImages.first;
      emit(state.copyWith(imageUrl: selectedImage.url));
    }
  }
}