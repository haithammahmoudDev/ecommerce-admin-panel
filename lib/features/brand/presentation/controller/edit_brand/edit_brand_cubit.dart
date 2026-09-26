import 'package:bloc/bloc.dart';
import 'package:ecommerce_admin_pannal/features/brand/domain/entities/brand_entity.dart';
import 'package:ecommerce_admin_pannal/features/brand/domain/repos/brand_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../utils/helpers/network_manager.dart';
import '../../../../../utils/popups/full_screen_loader.dart';
import '../../../../../utils/popups/loaders.dart';
import '../../../../categories/domain/entities/category_entity.dart';
import '../../../../media/data/models/image_model.dart';
import '../../../../media/presentation/controller/media_cubit/media_cubit.dart';
import '../../../data/models/brand_category.dart';
import '../../../data/models/brand_model.dart';
import '../brand_cubit.dart';

part 'edit_brand_state.dart';

class EditBrandCubit extends Cubit<EditBrandState> {
  final BrandRepo _brandRepo;
  EditBrandCubit({required this._brandRepo}) : super(const EditBrandState());

  /// Initialize form state when opening the edit screen.
  void init(BrandEntity brand) {
    emit(state.copyWith(
      imageUrl: brand.image,
      isFeatured: brand.isFeatured,
      selectedCategories: brand.brandCategories != null
          ? List<CategoryEntity>.from(brand.brandCategories!)
          : <CategoryEntity>[],
    ));
  }

  /// Select / unselect a category (compared by id to avoid == pitfalls).
  void selectParentCategory(CategoryEntity category) {
    final List<CategoryEntity> updatedCategories = List.from(state.selectedCategories);

    final index = updatedCategories.indexWhere((item) => item.id == category.id);

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

    // productsCount is intentionally left untouched here — editing a brand's
    // name/image/featured flag/categories should never reset its product
    // count. That field is only ever changed by product create/delete flows
    // (see BrandRepo.incrementProductsCount in brand_repo_additions.dart).
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

        // Stop here (and don't show success) if the category sync failed.
        final bool categoryUpdateOk = await updateBrandCategory(updatedBrand, context);
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

  /// Returns true if category sync succeeded, false if an error occurred
  /// (in which case editBrand stops instead of showing a false success message).
  Future<bool> updateBrandCategory(BrandEntity brand, BuildContext context) async {
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
        final selectedCategoryIds = state.selectedCategories.map((e) => e.id).toSet();

        // 1. Remove relations that were unselected.
        for (var cat in brandCategories.where((ec) => !selectedCategoryIds.contains(ec.categoryId))) {
          await _brandRepo.deleteCategoryBrand(cat.id ?? '');
        }

        // 2. Add new relations that don't already exist.
        for (var cat in state.selectedCategories.where(
              (nc) => !brandCategories.any((ec) => ec.categoryId == nc.id),
        )) {
          var brandCategory = BrandCategoryModel(brandId: brand.id, categoryId: cat.id);
          final catResult = await _brandRepo.createBrandCategory(brandCategory);

          catResult.fold(
                (error) {
              success = false;
              TFullScreenLoader.stopLoading(context);
              TLoaders.errorSnackBar(
                title: 'Oh Snap',
                message: error.message,
                context: context,
              );
            },
                (brandCategoryId) => brandCategory.id = brandCategoryId,
          );

          if (!success) break; // stop the loop as soon as an error occurs
        }

        brand.brandCategories = List.from(state.selectedCategories);
      },
    );

    return success;
  }

  Future<void> updatedBrandInProducts(BrandEntity brand) async {}

  Future<void> pickImage(BuildContext context) async {
    final controller = context.read<MediaCubit>();
    final selectedImages = await controller.selectImagesFromMedia(context: context);

    if (selectedImages != null && selectedImages.isNotEmpty) {
      final ImageModel selectedImage = selectedImages.first;
      emit(state.copyWith(imageUrl: selectedImage.url));
    }
  }
}