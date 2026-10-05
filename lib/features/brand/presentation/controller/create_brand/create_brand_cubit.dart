import 'package:ecommerce_admin_pannal/features/brand/domain/repos/brand_repo.dart';
import 'package:ecommerce_admin_pannal/features/brand/presentation/controller/brand_cubit.dart';
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
part 'create_brand_state.dart';

class CreateBrandCubit extends Cubit<CreateBrandState> {
  final BrandRepo _brandRepo;
  CreateBrandCubit({required this._brandRepo}) : super(CreateBrandState());

  void selectParentCategory(CategoryEntity category) {
    final List<CategoryEntity> updatedCategories = List.from(
      state.selectedCategories,
    );

    if (updatedCategories.contains(category)) {
      updatedCategories.remove(category);
    } else {
      updatedCategories.add(category);
    }
    emit(state.copyWith(selectedCategories: updatedCategories));
  }

  void toggleFeatured(bool? value) {
    emit(state.copyWith(isFeatured: value ?? false));
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

  Future<void> createBrand({
    required TextEditingController nameController,
    required BuildContext context,
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
      id: '',
      createdAt: DateTime.now(),
      isFeatured: state.isFeatured,
      productsCount: 0,
    );

    final result = await _brandRepo.createBrand(newRecord);

    await result.fold(
      (error) async {
        TFullScreenLoader.stopLoading(context);
        TLoaders.errorSnackBar(
          title: 'Oh Snap',
          message: error.message,
          context: context,
        );
      },
      (brandId) async {
        newRecord.id = brandId;

        if (newRecord.id.isEmpty) {
           TFullScreenLoader.stopLoading(context);
          TLoaders.errorSnackBar(
            title: 'Oh Snap',
            message: 'Error storing relational data, try again',
            context: context,
          );
          return;
        }

        if (state.selectedCategories.isNotEmpty) {
          for (final category in state.selectedCategories) {
            final brandCategory = BrandCategoryModel(
              brandId: newRecord.id,
              categoryId: category.id,
            );
            final catResult = await _brandRepo.createBrandCategory(
              brandCategory,
            );

            bool hadError = false;
            catResult.fold((error) {
              hadError = true;
              TFullScreenLoader.stopLoading(context);
              TLoaders.errorSnackBar(
                title: 'Oh Snap',
                message: error.message,
                context: context,
              );
            }, (_) {});

            if (hadError) return;
          }

          newRecord.brandCategories ??= [];
          newRecord.brandCategories!.addAll(state.selectedCategories);
        }

        final brandController = context.read<BrandCubit>();
        brandController.addItemToLists(newRecord.toEntity());
        await brandController.fetchData();

        TFullScreenLoader.stopLoading(context);
        TLoaders.successSnackBar(
          title: 'Congratulations',
          message: 'New Record has been added.',
          context: context,
        );
        context.pop();
      },
    );
  }
}
