import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../controller/product_image/product_image_cubit.dart';
import '../../../controller/product_image/product_image_state.dart';

class ProductThumbnailImage extends StatelessWidget {
  const ProductThumbnailImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Thumbnail Text
          Text('Product Thumbnail', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Container for Product Thumbnail
          TRoundedContainer(
            height: 300,
            backgroundColor: TColors.primaryBackground,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Thumbnail Image
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: BlocBuilder<ProductImagesCubit, ProductImagesState>(
                          builder: (context, state) {
                            final image = state.selectedThumbnailImageUrl;
                            final isNetwork = image != null && image.isNotEmpty;

                            return TRoundedImage(
                              width: 220,
                              height: 220,
                              image: isNetwork ? image : 'assets/images/profile/logo.png',
                              imageType: isNetwork ? ImageType.network : ImageType.asset,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  // Add Thumbnail Button
                  SizedBox(
                    width: 200,
                    child: OutlinedButton(
                      onPressed: () => context.read<ProductImagesCubit>().selectThumbnailImage(context),
                      child: const Text('Add Thumbnail'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}