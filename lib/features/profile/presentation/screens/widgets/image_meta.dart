import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/preferences/save_user_by_hive.dart';
import '../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../utils/constants/enums.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../categories/presentation/screens/create_category/widgets/image_uploader.dart';

class ImageAndMeta extends StatelessWidget {
  const ImageAndMeta({super.key});

  @override
  Widget build(BuildContext context) {
    final user = UserRepository().getUser();

    return TRoundedContainer(
      padding: const EdgeInsets.symmetric(
        vertical: TSizes.lg,
        horizontal: TSizes.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              // User Image
              const TImageUploader(
                right: 10,
                bottom: 20,
                left: null,
                width: 200,
                height: 200,
                circular: true,
                icon: Iconsax.camera,
                image: TImages.user,
                imageType: ImageType.asset,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(
                user?.fullName ?? '',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(user?.email ?? ''),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        ],
      ),
    );
  }
}