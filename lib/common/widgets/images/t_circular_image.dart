import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/helpers/helper_functions.dart';

class TCircularImage extends StatelessWidget {
  const TCircularImage({
    super.key,
    this.width = 70,
    this.height = 70,
    this.overlayColor,
    this.backgroundColor,
    this.image,
    this.memoryImage,
    required this.imageType,
    this.fit = BoxFit.fill,
    this.padding = Sizes.sm,
  });

  final BoxFit? fit;
  final String? image;
  final Uint8List? memoryImage;
  final ImageType imageType;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double width, height, padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color:
            backgroundColor ??
            (THelperFunctions.isDarkMode(context)
                ? TColors.black
                : TColors.white),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: _buildImage(),
        ),
      ),
    );
  }

  Widget _buildImage() {
    switch (imageType) {
      case ImageType.network:
        return image != null && image!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: image!,
                width: width,
                height: height,
                fit: fit,
                color: overlayColor,
                placeholder: (context, url) => const SizedBox(
                  width: 24,
                  height: 24,
                  child: Padding(
                    padding: EdgeInsets.all(6.0),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.person),
              )
            : const Icon(Icons.person);

      case ImageType.memory:
        return memoryImage != null
            ? Image.memory(memoryImage!, fit: fit, color: overlayColor)
            : const Icon(Icons.person);

      case ImageType.asset:
        return image != null && image!.isNotEmpty
            ? Image.asset(image!, fit: fit, color: overlayColor)
            : const Icon(Icons.person);

      default:
        return const Icon(Icons.person);
    }
  }
}
