import 'package:ecommerce_admin_pannal/features/product/presentation/controller/product_image/product_image_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/device/device_utility.dart';
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

class CreateProductDesktopScreen extends StatelessWidget {
  const CreateProductDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const ProductBottomNavigationButtons(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Product',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: Sizes.spaceBtwSections / 2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: TDeviceUtils.isTabletScreen(context) ? 2 : 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ProductTitleAndDescription(),
                        const SizedBox(height: Sizes.spaceBtwSections),
                        RoundedContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Stock & Pricing',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: Sizes.spaceBtwItems),
                              const ProductTypeWidget(),
                              const SizedBox(
                                height: Sizes.spaceBtwInputFields,
                              ),
                              const ProductStockAndPricing(),
                              const SizedBox(height: Sizes.spaceBtwSections),
                              const ProductAttributes(),
                              const SizedBox(height: Sizes.spaceBtwSections),
                            ],
                          ), // Column
                        ), // RoundedContainer
                        const SizedBox(height: Sizes.spaceBtwSections),
                        const ProductVariations(),
                      ],
                    ), // Column
                  ), // Expanded

                  const SizedBox(width: Sizes.defaultSpace),

                  Expanded(
                    child: Column(
                      children: [
                        const ProductThumbnailImage(),
                        const SizedBox(height: Sizes.spaceBtwSections),
                        RoundedContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'All Product Images',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: Sizes.spaceBtwItems),
                              BlocBuilder<
                                ProductImagesCubit,
                                ProductImagesState
                              >(
                                builder: (context, state) {
                                  return ProductAdditionalImages(
                                    additionalProductImagesURLs:
                                        state.additionalProductImagesUrls,
                                    onTapToAddImages: () => context
                                        .read<ProductImagesCubit>()
                                        .selectMultipleProductImages(context),
                                    onTapToRemoveImage: (index) => context
                                        .read<ProductImagesCubit>()
                                        .removeImage(index),
                                  ); // ProductAdditionalImages
                                },
                              ), // ProductAdditionalImages
                            ],
                          ), // Column
                        ), // RoundedContainer
                        const SizedBox(height: Sizes.spaceBtwSections),

                        const ProductBrand(),
                        const SizedBox(height: Sizes.spaceBtwSections),

                        const ProductCategories(),
                        const SizedBox(height: Sizes.spaceBtwSections),

                        const ProductVisibilityWidget(),
                        const SizedBox(height: Sizes.spaceBtwSections),
                      ],
                    ), // Column
                  ), // Expanded
                ],
              ), // Row
            ],
          ),
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}
