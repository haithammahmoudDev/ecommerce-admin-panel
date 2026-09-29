import 'package:bloc/bloc.dart';
import 'package:ecommerce_admin_pannal/features/brand/domain/entities/brand_entity.dart';
import 'package:ecommerce_admin_pannal/features/brand/domain/repos/brand_repo.dart';
import 'package:ecommerce_admin_pannal/features/media/domain/entities/image_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../utils/helpers/network_manager.dart';
import '../../../../../utils/popups/full_screen_loader.dart';
import '../../../../../utils/popups/loaders.dart';
import '../../../../categories/domain/entities/category_entity.dart';
import '../../../../media/presentation/controller/media_cubit/media_cubit.dart';
import '../../../data/models/brand_category.dart';
import '../../../data/models/brand_model.dart';
import '../brand_cubit.dart';

part 'edit_brand_state.dart';

class EditBrandCubit extends Cubit<EditBrandState> {
  final BrandRepo _brandRepo;
  EditBrandCubit({required this._brandRepo}) : super(const EditBrandState());

  void init(BrandEntity brand) {
    emit(
      state.copyWith(
        imageUrl: brand.image,
        isFeatured: brand.isFeatured,
        selectedCategories: brand.brandCategories != null
            ? List<CategoryEntity>.from(brand.brandCategories!)
            : <CategoryEntity>[],
      ),
    );
  }

  void selectParentCategory(CategoryEntity category) {
    final List<CategoryEntity> updatedCategories = List.from(
      state.selectedCategories,
    );

    final index = updatedCategories.indexWhere(
      (item) => item.id == category.id,
    );

    if (index >= 0) {
      updatedCategories.removeAt(index);
    } else {
      updatedCategories.add(category);
    }
    emit(state.copyWith(selectedCategories: updatedCategories));
  }

  void toggleFeatured(bool? value) {
    emit(state.copyWith(isFeatured: value ?? false));
  }

  Future<void> editBrand({
    required TextEditingController nameController,
    required BuildContext context,
    required String id,
    required BrandEntity brand,
  }) async {
    TFullScreenLoader.popUpCircular(context);

    final bool isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) {
      TFullScreenLoader.stopLoading(context);
      return;
    }

    final BrandModel newRecord = BrandModel(
      name: nameController.text.trim(),
      image: state.imageUrl,
      id: id,
      isFeatured: state.isFeatured ?? false,
      updatedAt: DateTime.now(),
    );

    final result = await _brandRepo.editBrand(newRecord);
    await result.fold(
      (error) async {
        TFullScreenLoader.stopLoading(context);
        TLoaders.errorSnackBar(
          title: 'Oh Snap',
          message: error.message,
          context: context,
        );
      },
      (_) async {
        final BrandEntity updatedBrand = brand.copyWith(
          name: newRecord.name,
          image: newRecord.image,
          isFeatured: newRecord.isFeatured,
        );

        final bool categoryUpdateOk = await updateBrandCategory(
          updatedBrand,
          context,
        );
        if (!categoryUpdateOk) return;

        await updatedBrandInProducts(updatedBrand);

        final brandController = context.read<BrandCubit>();
        brandController.updateItemInLists(updatedBrand);

        TFullScreenLoader.stopLoading(context);
        TLoaders.successSnackBar(
          title: 'Congratulations',
          message: 'Record updated successfully.',
          context: context,
        );
        context.pop();
      },
    );
  }

  Future<bool> updateBrandCategory(
    BrandEntity brand,
    BuildContext context,
  ) async {
    final result = await _brandRepo.getCategoriesOfSpecificBrand(brand.id);

    bool success = true;

    await result.fold(
      (error) async {
        success = false;
        TFullScreenLoader.stopLoading(context);
        TLoaders.errorSnackBar(
          title: 'Oh Snap',
          message: error.message,
          context: context,
        );
      },
      (brandCategories) async {
        final selectedCategoryIds = state.selectedCategories
            .map((e) => e.id)
            .toSet();

        for (var cat in brandCategories.where(
          (ec) => !selectedCategoryIds.contains(ec.categoryId),
        )) {
          await _brandRepo.deleteCategoryBrand(cat.id ?? '');
        }

        for (var cat in state.selectedCategories.where(
          (nc) => !brandCategories.any((ec) => ec.categoryId == nc.id),
        )) {
          var brandCategory = BrandCategoryModel(
            brandId: brand.id,
            categoryId: cat.id,
          );
          final catResult = await _brandRepo.createBrandCategory(brandCategory);

          catResult.fold((error) {
            success = false;
            TFullScreenLoader.stopLoading(context);
            TLoaders.errorSnackBar(
              title: 'Oh Snap',
              message: error.message,
              context: context,
            );
          }, (brandCategoryId) => brandCategory.id = brandCategoryId);

          if (!success) break;
        }

        brand.brandCategories = List.from(state.selectedCategories);
      },
    );

    return success;
  }

  Future<void> updatedBrandInProducts(BrandEntity brand) async {}

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
