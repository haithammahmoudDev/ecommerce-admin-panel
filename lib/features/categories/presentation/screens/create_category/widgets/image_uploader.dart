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
class TImageUploader extends StatelessWidget {
  const TImageUploader({
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

  /// Whether to display the loading instead of icon
  final bool loading;

  /// Whether to display the image in a circular shape
  final bool circular;

  /// URL or path of the image to display
  final String? image;

  /// Memory image data bytes (e.g., Uint8List)
  final dynamic memoryImage;

  /// Width of the image uploader widget
  final double width;

  /// Height of the image uploader widget
  final double height;

  /// Type of image (Network, Asset, File, etc.)
  final ImageType imageType;

  /// Icon data for the edit button
  final IconData icon;

  /// Offset from the top edge of the widget
  final double? top;

  /// Offset from the bottom edge of the widget
  final double? bottom;

  /// Offset from the right edge of the widget
  final double? right;

  /// Offset from the left edge of the widget
  final double? left;

  /// Callback function for when the icon button is pressed
  final void Function()? onIconButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Display the image in either circular or rounded shape
        !circular
            ? TRoundedImage(
          image: image,
          width: width,
          height: height,
          imageType: imageType,
          memoryImage: memoryImage,
          backgroundColor: TColors.primaryBackground,
        ) // // TRoundedImage
            : TCircularImage(
          image: image,
          width: width,
          height: height,
          imageType: imageType ,
          backgroundColor: TColors.primaryBackground,
        ), // // TCircularImage

        // Display the edit icon button on top of the image
        Positioned(
          top: top,
          left: left,
          right: right,
          bottom: bottom,
          child: loading
              ? const TCircularContainer(
            width: TSizes.xl,
            height: TSizes.xl,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              backgroundColor: TColors.primary,
              color: Colors.blue,
            ),
          ) // // TCircularContainer
              : TCircularIcon(
            icon: icon,
            size: TSizes.md,
            color: Colors.white,
            onPressed: onIconButtonPressed,
            backgroundColor: TColors.primary.withOpacity(0.9),
          ), // // TCircularIcon
        ), // // Positioned
      ],
    );
  }
}
