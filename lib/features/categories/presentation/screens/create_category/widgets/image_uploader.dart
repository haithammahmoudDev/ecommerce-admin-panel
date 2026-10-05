import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../common/widgets/custom_shapes/containers/circular_container.dart';
import '../../../../../../common/widgets/icons/t_circular_icon.dart';
import '../../../../../../common/widgets/images/t_circular_image.dart';
import 'package:ecommerce_admin_pannal/utils/constants/enums.dart';
import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';

/// Widget for uploading images with optional editing functionality
class ImageUploader extends StatelessWidget {
  const ImageUploader({
    super.key,
    this.image,
    this.onIconButtonPressed,
    this.memoryImage,
    this.width = 100,
    this.height = 100,
    required this.imageType,
    this.circular = false,
    this.icon = Iconsax.edit_2,
    this.top,
    this.bottom = 0,
    this.right,
    this.left = 0,
    this.loading = false,
  });

  final bool loading;

  final bool circular;

  final String? image;

  final dynamic memoryImage;

  /// Width of the image uploader widget
  final double width;

  final double height;

  final ImageType imageType;

  final IconData icon;

  final double? top;

  final double? bottom;

  final double? right;

  final double? left;

  final void Function()? onIconButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        !circular
            ? RoundedImage(
          image: image,
          width: width,
          height: height,
          imageType: imageType,
          memoryImage: memoryImage,
          backgroundColor: TColors.primaryBackground,
        )
            : TCircularImage(
          image: image,
          width: width,
          height: height,
          imageType: imageType ,
          backgroundColor: TColors.primaryBackground,
        ),

        Positioned(
          top: top,
          left: left,
          right: right,
          bottom: bottom,
          child: loading
              ? const TCircularContainer(
            width: Sizes.xl,
            height: Sizes.xl,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              backgroundColor: TColors.primary,
              color: Colors.blue,
            ),
          )
              : TCircularIcon(
            icon: icon,
            size: Sizes.md,
            color: Colors.white,
            onPressed: onIconButtonPressed,
            backgroundColor: TColors.primary.withOpacity(0.9),
          ),
        ),
      ],
    );
  }
}
