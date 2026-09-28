import 'package:ecommerce_admin_pannal/common/widgets/images/t_rounded_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../categories/presentation/screens/create_category/widgets/image_uploader.dart';

class ProductAdditionalImages extends StatelessWidget {
  const ProductAdditionalImages({
    super.key,
    required this.additionalProductImagesURLs,
    this.onTapToAddImages,
    this.onTapToRemoveImage,
  });

  final List<String> additionalProductImagesURLs;
  final void Function()? onTapToAddImages;
  final void Function(int index)? onTapToRemoveImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          // Section to Add Additional Product Images
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: onTapToAddImages,
              child: RoundedContainer(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Iconsax.gallery_import, size: 50,),
                      const Text('Add Additional Product Images'),
                    ],
                  ), // Column
                ), // Center
              ), // TRoundedContainer
            ), // GestureDetector
          ), // Expanded
          const SizedBox(height: TSizes.spaceBtwItems),

          // Section to Display Uploaded Images
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 80,
                    child: _uploadedImagesOrEmptyList(),
                  ), // SizedBox
                ), // Expanded
                const SizedBox(width: TSizes.spaceBtwItems / 2),

                // Add More Images Button
                RoundedContainer(
                  width: 80,
                  height: 80,
                  showBorder: true,
                  borderColor: TColors.grey,
                  backgroundColor: TColors.white,
                  onTap: onTapToAddImages,
                  child: const Center(child: Icon(Iconsax.add)),
                ), // TRoundedContainer
              ],
            ), // Row
          ), // Expanded
        ],
      ), // Column
    ); // SizedBox
  }

  // Widget to Display Either Uploaded Images or Empty List
  Widget _uploadedImagesOrEmptyList() {
    return additionalProductImagesURLs.isNotEmpty ? _uploadedImages() : emptyList();
  }

  // Widget to Display Empty List Placeholder
  Widget emptyList() {
    return ListView.separated(
      itemCount: 6,
      scrollDirection: Axis.horizontal,
      separatorBuilder: (context, index) => const SizedBox(width: TSizes.spaceBtwItems / 2),
      itemBuilder: (context, index) => const RoundedContainer(backgroundColor: TColors.primaryBackground, width: 80, height: 80),
    ); // ListView.separated
  }

  // Widget to Display Uploaded Images
  ListView _uploadedImages() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: additionalProductImagesURLs.length,
      separatorBuilder: (context, index) => const SizedBox(width: TSizes.spaceBtwItems / 2),
      itemBuilder: (context, index) {
        final image = additionalProductImagesURLs[index];
        return TImageUploader(
          top: 0,
          right: 0,
          width: 80,
          height: 80,
          left: null,
          bottom: null,
          image: image,
          icon: Iconsax.trash,
          imageType: ImageType.network,
          onIconButtonPressed: () => onTapToRemoveImage!(index),
        ); // TImageUploader
      },
    ); // ListView.separated
  }
}