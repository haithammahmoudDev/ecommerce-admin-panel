import 'package:ecommerce_admin_pannal/features/product/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb.dart';
import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/device/device_utility.dart';
import '../../../../data/models/product_model.dart';
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
              // Breadcrumbs
              const TBreadcrumbsWithHeading(
                heading: 'Edit Product',
                returnToPreviousScreen: true,
                breadcrumbItems: ['/products', 'Edit Product'],
              ), // TBreadcrumbsWithHeading
              const SizedBox(height: TSizes.spaceBtwSections),

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
                        TRoundedContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Heading
                              Text('Stock & Pricing', style: Theme.of(context).textTheme.headlineSmall),
                              const SizedBox(height: TSizes.spaceBtwItems),

                              // Product Type
                              const ProductTypeWidget(),
                              const SizedBox(height: TSizes.spaceBtwInputFields),

                              // Stock
                              const ProductStockAndPricing(),
                              const SizedBox(height: TSizes.spaceBtwSections),

                              // Attributes
                              ProductAttributes(), // Add/Edit/Delete Attributes
                              const SizedBox(height: TSizes.spaceBtwSections),
                            ],
                          ), // Column
                        ), // TRoundedContainer
                        const SizedBox(height: TSizes.spaceBtwSections),

                        // Variations Section
                        const ProductVariations(), // Edit/Delete Variations
                      ],
                    ), // Column
                  ), // Expanded

                  const SizedBox(width: TSizes.defaultSpace),

                  // Sidebar Side (Flex 1)
                  Expanded(
                    child: Column(
                      children: [
                        // Product Thumbnail
                        const ProductThumbnailImage(),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        // Product Images
                        TRoundedContainer(
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

                        // Product Brand Selection
                        const ProductBrand(),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        // Product Categories Selection
                        ProductCategories(),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        // Product Visibility Settings
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