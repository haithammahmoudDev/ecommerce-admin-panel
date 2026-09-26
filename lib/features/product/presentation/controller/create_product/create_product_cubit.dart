import 'package:bloc/bloc.dart';
import 'package:ecommerce_admin_pannal/features/product/domain/entities/product_attribute_entity.dart';
import 'package:ecommerce_admin_pannal/features/product/domain/entities/product_variation_entity.dart';
import 'package:ecommerce_admin_pannal/features/product/presentation/controller/product_attributes/product_attributes_cubit.dart';
import 'package:ecommerce_admin_pannal/features/product/presentation/controller/product_cubit.dart';
import 'package:ecommerce_admin_pannal/features/product/presentation/controller/product_image/product_image_cubit.dart';
import 'package:ecommerce_admin_pannal/features/product/presentation/controller/product_variations/prduct_cariations_cubit.dart';
import 'package:ecommerce_admin_pannal/utils/constants/enums.dart';
import 'package:ecommerce_admin_pannal/utils/popups/exports.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meta/meta.dart';

import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/network_manager.dart';
import '../../../../../utils/popups/loaders.dart';
import '../../../../brand/data/models/brand_model.dart';
import '../../../../brand/domain/entities/brand_entity.dart';
import '../../../../categories/domain/entities/category_entity.dart';
import '../../../data/models/product_attribute_model.dart';
import '../../../data/models/product_category_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/product_variation_model.dart';
import '../../../domain/repos/product_repo.dart';

part 'create_product_state.dart';

class CreateProductCubit extends Cubit<CreateProductState> {
  final ProductRepo productRepo;
  final ProductVariationsCubit _productVariationsCubit;
  final ProductImagesCubit _productImagesCubit;
  final ProductAttributesCubit _productAttributesCubit;
  final ProductCubit _productCubit;

  // Form Keys
  final GlobalKey<FormState> titleDescriptionFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> stockPriceFormKey = GlobalKey<FormState>();

  // Text Controllers
  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController stock = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController salePrice = TextEditingController();
  TextEditingController brandTextField = TextEditingController();

  CreateProductCubit({
    required this.productRepo,
    required this._productVariationsCubit,
    required this._productImagesCubit,
    required this._productAttributesCubit,
    required this._productCubit,
  }) : super(const CreateProductState());

  // State Mutators
  void selectBrand(BrandEntity brand) {
    emit(state.copyWith(selectedBrand: brand));
  }

  void setSelectedCategories(List<CategoryEntity> categories) {
    emit(state.copyWith(selectedCategories: categories));
  }

  void setProductType(ProductType type) {
    emit(state.copyWith(productType: type));
  }

  void changeProductType(ProductType? type) {
    if (type != null) {
      emit(state.copyWith(productType: type));
    }
  }

  void setProductVisibility(ProductVisibility visibility) {
    emit(state.copyWith(productVisibility: visibility));
  }

  /// UI Helper: Build Checkbox item
  Widget buildCheckBox(String label, bool value) {
    return Row(
      children: [
        AnimatedSwitcher(
          duration: const Duration(seconds: 2),
          child: value
              ? const Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.blue)
              : const Icon(CupertinoIcons.checkmark_alt_circle),
        ),
        const SizedBox(width: TSizes.spaceBtwItems),
        Text(label),
      ],
    );
  }

  /// UI Helper: Show Completion Dialog
  void showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Congratulations'),
          actions: [
            TextButton(
              onPressed: () {
                _productCubit.fetchData();
                dialogContext.pop();
                context.pop();
              },
              child: const Text('Go to Products'),
            ),
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/products/packaging-produt.webp', height: 200, width: 200),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(
                'Congratulations',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              const Text('Your Product has been Created'),
            ],
          ),
        );
      },
    );
  }

  void showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Text('Creating Product'),
          content: BlocBuilder<CreateProductCubit, CreateProductState>(
            bloc: this,
            builder: (context, state) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('TImages.creatingProductIllustration', height: 200, width: 200),
                const SizedBox(height: TSizes.spaceBtwItems),
                buildCheckBox('Thumbnail Image', state.thumbnailUploader),
                buildCheckBox('Additional Images', state.additionalImagesUploader),
                buildCheckBox('Product Data, Attributes & Variations', state.productDataUploader),
                buildCheckBox('Product Categories', state.categoriesRelationshipUploader),
                const SizedBox(height: TSizes.spaceBtwItems),
                const Text('Sit Tight, Your product is uploading...'),
              ],
            ), // Column
          ), // BlocBuilder
        ), // AlertDialog
      ), // PopScope
    );
  }

  /// Create Product workflow using pure dartz .fold()
  Future<void> createProduct({required BuildContext context}) async {
    showProgressDialog(context);

    // 1. القراءة المباشرة للـ Cubits الحية من الـ BuildContext (تجنباً لمشكلة النسخ المستقلة من GetIt)
    final variationsCubit = context.read<ProductVariationsCubit>();
    final imagesCubit = context.read<ProductImagesCubit>();
    final attributesCubit = context.read<ProductAttributesCubit>();
    final productCubit = context.read<ProductCubit>();

    // 2. التحقق من اتصال الإنترنت
    final isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) {
      if (context.mounted) {
        TFullScreenLoader.stopLoading(context);
        TLoaders.errorSnackBar(
          title: 'Oh Snap',
          message: 'No Internet Connection. Please check your connection and try again',
          context: context,
        );
      }
      return;
    }

    // 3. التحقق من صحة حقول النموذج الرئيسية
    if (!titleDescriptionFormKey.currentState!.validate()) {
      if (context.mounted) TFullScreenLoader.stopLoading(context);
      return;
    }

    if (state.productType == ProductType.single &&
        !stockPriceFormKey.currentState!.validate()) {
      if (context.mounted) TFullScreenLoader.stopLoading(context);
      return;
    }

    // 4. التحقق من اختيار البراند
    final selectedBrand = state.selectedBrand;
    if (selectedBrand == null) {
      if (context.mounted) {
        TFullScreenLoader.stopLoading(context);
        TLoaders.errorSnackBar(
          title: 'Oh Snap',
          message: 'Please select a Brand for this product',
          context: context,
        );
      }
      return;
    }

    // 4.5. التحقق من اختيار قسم (Category) واحد على الأقل
    // -- ده ضروري عشان نضمن إن categoryId مش هيتسجل null في الـ Product نفسه
    if (state.selectedCategories.isEmpty) {
      if (context.mounted) {
        TFullScreenLoader.stopLoading(context);
        TLoaders.errorSnackBar(
          title: 'Oh Snap',
          message: 'Please select at least one Category for this product',
          context: context,
        );
      }
      return;
    }

    // 5. جلب التنويعات ومزامنة المدخلات المكتوبة داخل الـ TextFields
    var variations = variationsCubit.getUpdatedVariationsWithInputs();

    if (state.productType == ProductType.variable && variations.isEmpty) {
      if (context.mounted) {
        TFullScreenLoader.stopLoading(context);
        TLoaders.errorSnackBar(
          title: 'Oh Snap',
          message: 'There are no variations for the Product Type Variable. Create some variations or change Product type.',
          context: context,
        );
      }
      return;
    }

    // 6. التحقق من صحة بيانات كل تنويع (السعر، المخزون، والصورة)
    if (state.productType == ProductType.variable) {
      final variationCheckFailed = variations.any((element) =>
      element.price < 0 ||
          element.salePrice < 0 ||
          element.stock < 0 ||
          element.image.isEmpty);

      if (variationCheckFailed) {
        if (context.mounted) {
          TFullScreenLoader.stopLoading(context);
          TLoaders.errorSnackBar(
            title: 'Oh Snap',
            message: 'Variation data is not accurate. Make sure every variation has an image and valid stock/price values',
            context: context,
          );
        }
        return;
      }
    }

    // 7. التحقق من رفع الصورة الرئيسية (Thumbnail)
    emit(state.copyWith(thumbnailUploader: true));
    final thumbnailUrl = imagesCubit.state.selectedThumbnailImageUrl;
    if (thumbnailUrl == null || thumbnailUrl.isEmpty) {
      if (context.mounted) {
        TFullScreenLoader.stopLoading(context);
        TLoaders.errorSnackBar(
          title: 'Oh Snap',
          message: 'Please upload a Product Thumbnail Image',
          context: context,
        );
      }
      return;
    }

    emit(state.copyWith(additionalImagesUploader: true));

    // تفريغ التنويعات إذا كان نوع المنتج Single
    if (state.productType == ProductType.single && variations.isNotEmpty) {
      variationsCubit.resetAllValues();
      variations = [];
    }

    // -- الـ categoryId الأساسي اللي هيتسجل جوه الـ Product نفسه (أول category متختارة)
    // ده منفصل عن collection الربط ProductCategory اللي بتدعم Many-to-Many في الخطوة 10
    final primaryCategoryId = state.selectedCategories.first.id;

    // 8. تجهيز موديل المنتج الجديد
    // FIX 1: isFeatured كانت ثابتة true دائماً بغض النظر عن اختيار المستخدم
    // الفعلي في فورم الـ Visibility. الآن تُقرأ من state.productVisibility
    // بنفس الطريقة المستخدمة في EditProductCubit.
    // FIX 2: productType كانت تُخزَّن بصيغة .toString() (تنتج نص زي
    // "ProductType.single") بينما EditProductCubit يخزنها بصيغة .name
    // (تنتج "single" فقط). هذا التضارب كان يتسبب في فشل المقارنات في
    // ProductCubit (getProductStockTotal / getProductSoldQuantity) وقد
    // يؤدي لـ Null check crash عند القراءة لاحقاً. الآن موحّدة على .name.
    final newRecord = ProductModel(
      id: '',
      sku: '',
      isFeatured: state.productVisibility == ProductVisibility.published,
      title: title.text.trim(),
      brand: BrandModel.fromEntity(selectedBrand),
      categoryId: primaryCategoryId, // -- تم إضافتها هنا لحل مشكلة null
      productVariations: variations.map((e) => ProductVariationModel.fromEntity(e)).toList(),
      description: description.text.trim(),
      productType: state.productType.name,
      stock: int.tryParse(stock.text.trim()) ?? 0,
      price: double.tryParse(price.text.trim()) ?? 0,
      images: imagesCubit.state.additionalProductImagesUrls,
      salePrice: double.tryParse(salePrice.text.trim()) ?? 0,
      thumbnail: thumbnailUrl,
      productAttributes: attributesCubit.state.productAttributes
          .map((e) => ProductAttributeModel.fromEntity(e))
          .toList(),
      date: DateTime.now(),
    );

    // 9. حفظ المنتج في القواعد البيانات
    emit(state.copyWith(productDataUploader: true));
    final createProductResult = await productRepo.createProduct(newRecord);

    await createProductResult.fold(
          (failure) async {
        if (context.mounted) {
          TFullScreenLoader.stopLoading(context);
          TLoaders.errorSnackBar(
            title: 'Oh Snap',
            message: failure.message,
            context: context,
          );
        }
        emit(state.copyWith(status: CreateProductStatus.error, errorMessage: failure.message));
      },
          (productId) async {
        newRecord.id = productId;

        // 10. ربط المنتج بالأقسام (Categories) -- علاقة Many-to-Many عبر ProductCategory
        if (state.selectedCategories.isNotEmpty) {
          emit(state.copyWith(categoriesRelationshipUploader: true));

          for (final category in state.selectedCategories) {
            final productCategory = ProductCategoryModel(productId: newRecord.id, categoryId: category.id);
            final createCategoryResult = await productRepo.createProductCategory(productCategory);

            final categoryFailed = createCategoryResult.fold(
                  (failure) {
                if (context.mounted) {
                  TFullScreenLoader.stopLoading(context);
                  TLoaders.errorSnackBar(
                    title: 'Oh Snap',
                    message: 'Product was saved, but linking category "${category.name}" failed: ${failure.message}',
                    context: context,
                  );
                }
                return true;
              },
                  (_) => false,
            );

            if (categoryFailed) return;
          }
        }

        // 11. إضافة المنتج للقائمة الرئيسية وتحديث الواجهة عند النجاح
        productCubit.addItemToLists(newRecord.toEntity());

        if (context.mounted) {
          TFullScreenLoader.stopLoading(context);
          emit(state.copyWith(status: CreateProductStatus.success));
          showCompletionDialog(context);
        }
      },
    );
  }

  void resetValues() {
    stockPriceFormKey.currentState?.reset();
    titleDescriptionFormKey.currentState?.reset();
    title.clear();
    description.clear();
    stock.clear();
    price.clear();
    salePrice.clear();
    brandTextField.clear();
    _productVariationsCubit.resetAllValues();
    _productAttributesCubit.resetProductAttributes([]);

    // Reset Upload Flags + selections + status, all back to initial in one emit
    emit(const CreateProductState());
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