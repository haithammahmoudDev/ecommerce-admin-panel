import 'package:bloc/bloc.dart';
import 'package:ecommerce_admin_pannal/features/brand/presentation/controller/brand_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/constants/enums.dart';
import '../../../../../utils/helpers/network_manager.dart';
import '../../../../../utils/popups/full_screen_loader.dart';
import '../../../../../utils/popups/loaders.dart';
import '../../../../brand/data/models/brand_model.dart';
import '../../../../brand/domain/entities/brand_entity.dart';
import '../../../../categories/domain/entities/category_entity.dart';
import '../../../../categories/presentation/controller/category/category_cubit.dart';
import '../../../data/models/product_attribute_model.dart';
import '../../../data/models/product_category_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/product_variation_model.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/repos/product_repo.dart';
import '../product_attributes/product_attributes_cubit.dart';
import '../product_cubit.dart';
import '../product_image/product_image_cubit.dart';
import '../product_variations/prduct_cariations_cubit.dart';

part 'edit_product_state.dart';

class EditProductCubit extends Cubit<EditProductState> {
  final ProductRepo productRepo;
  final ProductVariationsCubit _productVariationsCubit;
  final ProductImagesCubit _productImagesCubit;
  final ProductAttributesCubit _productAttributesCubit;
  final ProductCubit _productCubit;
  final CategoryCubit _categoryCubit;
  final BrandCubit _brandCubit;
  CategoryCubit get productCategoriesCubit => _categoryCubit;
  ProductImagesCubit get productImagesCubit => _productImagesCubit;
  ProductVariationsCubit get productVariationsCubit => _productVariationsCubit;
  ProductAttributesCubit get productAttributesCubit => _productAttributesCubit;
  final GlobalKey<FormState> titleDescriptionFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> stockPriceFormKey = GlobalKey<FormState>();
  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController stock = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController salePrice = TextEditingController();
  final TextEditingController brandTextField = TextEditingController();

  EditProductCubit({
    required this.productRepo,
    required this._productVariationsCubit,
    required this._productImagesCubit,
    required this._productAttributesCubit,
    required this._productCubit,
    required this._categoryCubit,
    required this._brandCubit,
  }) : super(const EditProductState());

  void selectBrand(BrandEntity brand) {
    emit(state.copyWith(selectedBrand: brand));
  }

  void setSelectedCategories(List<CategoryEntity> categories) {
    emit(state.copyWith(selectedCategories: categories));
  }

  void changeProductType(ProductType? type) {
    if (type != null) {
      emit(state.copyWith(productType: type));
    }
  }

  void setProductVisibility(ProductVisibility visibility) {
    emit(state.copyWith(productVisibility: visibility));
  }

  /// Initialize product data safely with synced cubits & brand references
  Future<void> initProductData(ProductEntity product) async {
    // 1. تعبئة الحقول النصية
    title.text = product.title;
    description.text = product.description ?? '';
    stock.text = product.stock.toString();
    price.text = product.price.toString();
    salePrice.text = product.salePrice > 0 ? product.salePrice.toString() : '';
    brandTextField.text = product.brand?.name ?? '';

    // 2. تحديد نوع المنتج والرؤية بشكل آمن
    final hasVariations =
        product.productVariations != null &&
        product.productVariations!.isNotEmpty;

    final isSingle =
        !hasVariations &&
        (product.productType == ProductType.single.name ||
            product.productType == ProductType.single.toString() ||
            product.productType.toLowerCase().contains('single'));

    final visibilityEnum = (product.isFeatured ?? false)
        ? ProductVisibility.published
        : ProductVisibility.hidden;

    // 3. تأكيد تحميل الماركات ومطابقة الكائن بالـ ID مع حماية الـ Null
    BrandEntity? matchedBrand;
    if (product.brand != null) {
      if (_brandCubit.state.allItems.isEmpty) {
        await _brandCubit.fetchData();
      }

      matchedBrand = _brandCubit.state.allItems.firstWhere(
        (b) => b.id == product.brand!.id,
        orElse: () => product.brand!,
      );
    }

    emit(
      state.copyWith(
        productType: isSingle ? ProductType.single : ProductType.variable,
        productVisibility: visibilityEnum,
        selectedBrand: matchedBrand,
      ),
    );

    _productImagesCubit.setSelectedThumbnailImageUrl(product.thumbnail);
    _productImagesCubit.setAdditionalProductImagesUrls(product.images ?? []);
    _productAttributesCubit.resetProductAttributes(
      product.productAttributes ?? [],
    );
    _productVariationsCubit.initializeVariationControllers(
      product.productVariations ?? [],
    );

    await loadSelectedCategories(product.id);
  }

  Future<List<CategoryEntity>> loadSelectedCategories(String productId) async {
    emit(state.copyWith(isCategoriesLoading: true));

    final result = await productRepo.fetchAllProductCategories(productId);

    return await result.fold(
      (failure) async {
        emit(state.copyWith(isCategoriesLoading: false));
        return <CategoryEntity>[];
      },
      (productCategories) async {
        if (_categoryCubit.state.allItems.isEmpty) {
          await _categoryCubit.fetchData();
        }

        final categoriesIds = productCategories
            .map((e) => e.categoryId)
            .toList();
        final categories = _categoryCubit.state.allItems
            .where((element) => categoriesIds.contains(element.id))
            .toList();

        emit(
          state.copyWith(
            selectedCategories: categories,
            alreadyAddedCategories: categories,
            isCategoriesLoading: false,
          ),
        );

        return categories;
      },
    );
  }

  Future<void> editProduct(ProductModel product, BuildContext context) async {
    try {
      TFullScreenLoader.popUpCircular(context);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading(context);
        TLoaders.errorSnackBar(
          title: 'No Internet Connection',
          message: 'Please check your internet connection and try again.',
          context: context,
        );
        return;
      }

      // 2. التحقق من الاستمارة الرئيسية (العنوان والوصف) بشكل آمن
      final isTitleValid =
          titleDescriptionFormKey.currentState?.validate() ?? false;
      if (!isTitleValid) {
        TFullScreenLoader.stopLoading(context);
        return;
      }

      // 3. التحقق من استمارة السعر والمخزون للمنتج الفردي
      if (state.productType == ProductType.single) {
        final isStockPriceValid =
            stockPriceFormKey.currentState?.validate() ?? false;
        if (!isStockPriceValid) {
          TFullScreenLoader.stopLoading(context);
          return;
        }
      }

      if (state.selectedBrand == null) {
        TFullScreenLoader.stopLoading(context);
        TLoaders.errorSnackBar(
          title: 'Select Brand',
          message: 'Please select a Brand for this product',
          context: context,
        );
        return;
      }

      if (state.selectedCategories.isEmpty) {
        TFullScreenLoader.stopLoading(context);
        TLoaders.errorSnackBar(
          title: 'Select Category',
          message: 'Please select at least one Category for this product',
          context: context,
        );
        return;
      }

      var variations = _productVariationsCubit.getUpdatedVariationsWithInputs();

      if (state.productType == ProductType.variable) {
        if (variations.isEmpty) {
          TFullScreenLoader.stopLoading(context);
          TLoaders.errorSnackBar(
            title: 'No Variations Found',
            message:
                'There are no variations for Variable Product Type. Create variations or change Product Type.',
            context: context,
          );
          return;
        }

        final variationCheckFailed = variations.any(
          (element) =>
              element.price < 0 || element.salePrice < 0 || element.stock < 0,
        );

        if (variationCheckFailed) {
          TFullScreenLoader.stopLoading(context);
          TLoaders.errorSnackBar(
            title: 'Variation Data Error',
            message:
                'Please ensure stock and price values for all variations are valid.',
            context: context,
          );
          return;
        }
      }

      if (state.productType == ProductType.single && variations.isNotEmpty) {
        _productVariationsCubit.resetAllValues();
        variations = [];
      }

      final imagesController = _productImagesCubit;
      final thumbnailUrl = imagesController.state.selectedThumbnailImageUrl;
      if (thumbnailUrl == null || thumbnailUrl.trim().isEmpty) {
        TFullScreenLoader.stopLoading(context);
        TLoaders.errorSnackBar(
          title: 'Select Product Thumbnail',
          message: 'Please select a Product Thumbnail Image',
          context: context,
        );
        return;
      }

      product.isFeatured =
          state.productVisibility == ProductVisibility.published;
      product.title = title.text.trim();
      product.brand = BrandModel.fromEntity(state.selectedBrand!);
      product.categoryId =
          state.selectedCategories.first.id; // -- تم إضافتها هنا لحل مشكلة null
      product.description = description.text.trim();
      product.productType =
          state.productType.name; // حفظ الاسم مباشرة (single / variable)
      product.stock = int.tryParse(stock.text.trim()) ?? 0;
      product.price = double.tryParse(price.text.trim()) ?? 0;
      product.images = imagesController.state.additionalProductImagesUrls;
      product.salePrice = double.tryParse(salePrice.text.trim()) ?? 0;
      product.thumbnail = thumbnailUrl;
      product.productAttributes = _productAttributesCubit
          .state
          .productAttributes
          .map((e) => ProductAttributeModel.fromEntity(e))
          .toList();
      product.productVariations = variations
          .map((e) => ProductVariationModel.fromEntity(e))
          .toList();

      emit(
        state.copyWith(
          thumbnailUploader: true,
          additionalImagesUploader: true,
          productDataUploader: true,
        ),
      );

      final updateResult = await productRepo.editProduct(product);

      await updateResult.fold(
        (failure) async {
          TFullScreenLoader.stopLoading(context);
          TLoaders.errorSnackBar(
            title: 'Oh Snap',
            message: failure.message,
            context: context,
          );
        },
        (_) async {
          final selectedIds = state.selectedCategories.map((c) => c.id).toSet();
          final existingIds = state.alreadyAddedCategories
              .map((c) => c.id)
              .toSet();

          final categoriesToAdd = selectedIds.difference(existingIds);
          final categoriesToRemove = existingIds.difference(selectedIds);

          if (categoriesToAdd.isNotEmpty || categoriesToRemove.isNotEmpty) {
            emit(state.copyWith(categoriesRelationshipUploader: true));

            for (final categoryId in categoriesToAdd) {
              final productCategory = ProductCategoryModel(
                productId: product.id,
                categoryId: categoryId,
              );

              final createResult = await productRepo.createProductCategory(
                productCategory,
              );
              final createFailed = createResult.fold((failure) {
                TFullScreenLoader.stopLoading(context);
                TLoaders.errorSnackBar(
                  title: 'Oh Snap',
                  message: failure.message,
                  context: context,
                );
                return true;
              }, (_) => false);

              if (createFailed) return;
            }

            for (final categoryId in categoriesToRemove) {
              final removeResult = await productRepo.removeProductCategory(
                product.id,
                categoryId,
              );
              final removeFailed = removeResult.fold((failure) {
                TFullScreenLoader.stopLoading(context);
                TLoaders.errorSnackBar(
                  title: 'Oh Snap',
                  message: failure.message,
                  context: context,
                );
                return true;
              }, (_) => false);

              if (removeFailed) return;
            }
          }

          _productCubit.updateItemInLists(product.toEntity());

          TFullScreenLoader.stopLoading(context);
          showSuccessDialog(context);
        },
      );
    } catch (e) {
      TFullScreenLoader.stopLoading(context);
      TLoaders.errorSnackBar(
        title: 'Oh Snap',
        message: e.toString(),
        context: context,
      );
    }
  }

  void showSuccessDialog(BuildContext context) {
    TLoaders.successSnackBar(
      title: 'Updated',
      message: 'Success Update Product',
      context: context,
    );
  }

  @override
  Future<void> close() {
    title.dispose();
    description.dispose();
    stock.dispose();
    price.dispose();
    salePrice.dispose();
    brandTextField.dispose();
    return super.close();
  }
}
