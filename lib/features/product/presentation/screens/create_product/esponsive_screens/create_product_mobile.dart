import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../common/widgets/breadcrumbs/breadcrumb.dart';
import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
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

class CreateProductMobileScreen extends StatelessWidget {
  const CreateProductMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: const ProductBottomNavigationButtons(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              const TBreadcrumbsWithHeading(
                returnToPreviousScreen: true,
                heading: 'Create Product',
                breadcrumbItems: ['/products', 'Create Product'],
              ), // TBreadcrumbsWithHeading
              const SizedBox(height: TSizes.spaceBtwSections),

              // Create Product Form (Vertical Layout)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Basic Information
                  const ProductTitleAndDescription(),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // 2. Stock & Pricing
                  RoundedContainer(
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
                        const ProductAttributes(),
                        const SizedBox(height: TSizes.spaceBtwSections),
                      ],
                    ), // Column
                  ), // TRoundedContainer
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // 3. Variations
                  const ProductVariations(),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // 4. Product Thumbnail (Sidebar element placed vertically)
                  const ProductThumbnailImage(),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // 5. Product Images
                  RoundedContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('All Product Images', style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        ProductAdditionalImages(
                          additionalProductImagesURLs: RxList<String>.empty(),
                          onTapToAddImages: () {},
                          onTapToRemoveImage: (index) {},
                        ), // ProductAdditionalImages
                      ],
                    ), // Column
                  ), // TRoundedContainer
                  const SizedBox(height: TSizes.spaceBtwSections),


                  // 7. Product Categories
                  const ProductCategories(),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // 8. Product Visibility
                  const ProductVisibilityWidget(),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              ), // Column
            ],
          ), // Main Column
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}
