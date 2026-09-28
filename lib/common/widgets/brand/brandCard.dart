
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../custom_shapes/containers/rounded_container.dart';
import '../images/t_circular_image.dart';
import '../texts/t_brand_title_text_with_verified_icon.dart';

class Brandcard extends StatelessWidget {
  const Brandcard({super.key, this.onTap, required this.showBorder});
  final VoidCallback? onTap;
  final bool showBorder;
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onTap,
      child: RoundedContainer(
        padding:const EdgeInsets.all(TSizes.sm),
        showBorder: showBorder,
        backgroundColor: Colors.transparent,
        child: Row(
          children: [
            TCircularImage(
              image: TImages.clothIcon,
               backgroundColor: Colors.transparent,
              overlayColor: THelperFunctions.isDarkMode(context) ? Colors.black : Colors.white,
              imageType: ImageType.asset,
            ),
            const  SizedBox(width: TSizes.spaceBtwItems / 2,),
            Expanded(child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TBrandTitleWithVerifiedIcon(title: 'Nike', brandTextSize: TextSizes.large,),
                Text('256 Products',
                  style: Theme.of(context).textTheme.labelMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ))
          ],
        ),
      ),
    );;
  }
}
