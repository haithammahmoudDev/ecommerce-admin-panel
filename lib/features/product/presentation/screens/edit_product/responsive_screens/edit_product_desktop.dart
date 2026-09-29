import 'package:ecommerce_admin_pannal/features/product/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/device/device_utility.dart';
import '../../../controller/product_image/product_image_cubit.dart';
import '../../../controller/product_image/product_image_state.dart';
import '../widgets/additional_images.dart';
import '../widgets/attributes_widget.dart';
import '../widgets/bottom_navigation_widget.dart';
import '../widgets/brand_widget.dart';
import '../widgets/categories_widget.dart';
import '../widgets/product_type_widget.dart';
import '../widgets/stock_pricing_widget.dart';
import '../widgets/thumbnail_widget.dart';
import '../widgets/title_description.dart';
import '../widgets/variations_widget.dart';
import '../widgets/visibility_widget.dart';


class EditProductDesktopScreen extends StatelessWidget {
  const EditProductDesktopScreen({
    super.key,
    required this.product,
  });

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ProductImagesCubit>();

    return Scaffold(
      bottomNavigationBar: ProductBottomNavigationButtons(product: product,),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Product',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: TSizes.spaceBtwSections / 2),

              // Edit Product Form Layout
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Content Side (Flex 2 or 3 based on screen size)
                  Expanded(
                    flex: TDeviceUtils.isTabletScreen(context) ? 2 : 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Basic Information
                        const ProductTitleAndDescription(),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        // Stock & Pricing Container
                        RoundedContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Stock & Pricing', style: Theme.of(context).textTheme.headlineSmall),
                              const SizedBox(height: TSizes.spaceBtwItems),

                              const ProductTypeWidget(),
                              const SizedBox(height: TSizes.spaceBtwInputFields),

                              const ProductStockAndPricing(),
                              const SizedBox(height: TSizes.spaceBtwSections),

                              ProductAttributes(),
                              const SizedBox(height: TSizes.spaceBtwSections),
                            ],
                          ), // Column
                        ), // RoundedContainer
                        const SizedBox(height: TSizes.spaceBtwSections),

                        const ProductVariations(),
                      ],
                    ), // Column
                  ), // Expanded

                  const SizedBox(width: TSizes.defaultSpace),

                  Expanded(
                    child: Column(
                      children: [
                        const ProductThumbnailImage(),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        RoundedContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('All Product Images', style: Theme.of(context).textTheme.headlineSmall),
                              const SizedBox(height: TSizes.spaceBtwItems),
                              BlocBuilder<ProductImagesCubit, ProductImagesState>(
                                builder: (context, state) {
                                  return
                                        ProductAdditionalImages(
                                          additionalProductImagesURLs: state.additionalProductImagesUrls,
                                          onTapToAddImages: () =>
                                              context.read<ProductImagesCubit>().selectMultipleProductImages(context),
                                          onTapToRemoveImage: (index) =>
                                              context.read<ProductImagesCubit>().removeImage(index),);
                                },
                              ), // ProductAdditionalImages
                            ],
                          ), // Column
                        ), // TRoundedContainer
                        const SizedBox(height: TSizes.spaceBtwSections),

                        const ProductBrand(),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        ProductCategories(),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        const ProductVisibilityWidget(),
                      ],
                    ), // Column
                  ), // Expanded (Sidebar)
                ],
              ), // Row
            ],
          ), // Main Column
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}