import 'package:flutter/material.dart';
import 'package:get/get.dart';
 import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../widgets/additional_images.dart';
import '../widgets/attributes_widget.dart';
import '../widgets/bottom_navigation_widget.dart';
 import '../widgets/categories_widget.dart';
import '../widgets/product_type_widget.dart';
import '../widgets/stock_pricing_widget.dart';
import '../widgets/thumbnail_widget.dart';
import '../widgets/title_description.dart';
import '../widgets/variations_widget.dart';
import '../widgets/visibility_widget.dart';

class CreateProductTabletScreen extends StatelessWidget {
  const CreateProductTabletScreen({super.key});

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

              // Create Product Layout for Tablet
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Main Content Side
                  Expanded(
                    flex: 2, // يأخذ ثلثي مساحة العرض المتاحة
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Basic Information
                        const ProductTitleAndDescription(),
                        const SizedBox(height: Sizes.spaceBtwSections),

                        // Stock & Pricing
                        RoundedContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Stock & Pricing', style: Theme.of(context).textTheme.headlineSmall),
                              const SizedBox(height: Sizes.spaceBtwItems),

                              const ProductTypeWidget(),
                              const SizedBox(height: Sizes.spaceBtwInputFields),

                              const ProductStockAndPricing(),
                              const SizedBox(height: Sizes.spaceBtwSections),

                              const ProductAttributes(),
                              const SizedBox(height: Sizes.spaceBtwSections),
                            ],
                          ),
                        ), // RoundedContainer
                        const SizedBox(height: Sizes.spaceBtwSections),

                        const ProductVariations(),
                      ],
                    ),
                  ),

                  const SizedBox(width: Sizes.defaultSpace),

                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ProductThumbnailImage(),
                        const SizedBox(height: Sizes.spaceBtwSections),

                        RoundedContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('All Product Images', style: Theme.of(context).textTheme.headlineSmall),
                              const SizedBox(height: Sizes.spaceBtwItems),
                              ProductAdditionalImages(
                                additionalProductImagesURLs: RxList<String>.empty(),
                                onTapToAddImages: () {},
                                onTapToRemoveImage: (index) {},
                              ),
                            ],
                          ),
                        ), // RoundedContainer
                        const SizedBox(height: Sizes.spaceBtwSections),


                        const ProductCategories(),
                        const SizedBox(height: Sizes.spaceBtwSections),

                        const ProductVisibilityWidget(),
                      ],
                    ),
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
