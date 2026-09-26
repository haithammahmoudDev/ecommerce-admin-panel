import 'package:ecommerce_admin_pannal/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../images/t_circular_image.dart';
import '../texts/t_brand_title_text.dart';

class TVerticalImageAndText extends StatelessWidget {
  const TVerticalImageAndText({
    super.key,
    this.onTap,
    required this.image,
    required this.title,
    this.backgroundColor,
    this.textColor = TColors.white,
  });

  final Color textColor;
  final String image, title;
  final Color? backgroundColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: TSizes.spaceBtwItems),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TCircularImage(image: image, width: 60, height: 60,imageType: ImageType.network,),
            const SizedBox(height: 4),
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
