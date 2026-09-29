import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../utils/constants/enums.dart';
import '../shimmers/shimmer.dart';

class RoundedImage extends StatelessWidget {
  const RoundedImage({
    super.key,
    this.image,
    this.file,
    this.border,
    this.width = 56,
    this.height = 56,
    this.memoryImage,
    this.overlayColor,
    required this.imageType,
    this.backgroundColor,
    this.padding = 0,
    this.margin,
    this.fit = BoxFit.cover,
    this.applyImageRadius = true,
    this.borderRadius = Sizes.md,
    this.isCircle = false,
  });

  final String? image;
  final File? file;
  final Uint8List? memoryImage;

  final ImageType imageType;

  final BoxBorder? border;

  final double? width;
  final double? height;
  final double? padding;
  final double? margin;

  final Color? overlayColor;
  final Color? backgroundColor;

  final BoxFit? fit;

  final bool applyImageRadius;
  final bool isCircle;

  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = isCircle
        ? BorderRadius.circular(9999)
        : BorderRadius.circular(borderRadius);

    return Container(
      width: width,
      height: height,
      margin: margin != null ? EdgeInsets.all(margin!) : null,
      padding: EdgeInsets.all(padding ?? 0),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: border,
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: applyImageRadius ? radius : BorderRadius.zero,
        child: _buildImageWidget(),
      ),
    );
  }

  Widget _buildImageWidget() {
    switch (imageType) {
      case ImageType.network:
        return _buildNetworkImage();
      case ImageType.asset:
        return _buildAssetImage();
      case ImageType.file:
        return _buildFileImage();
      case ImageType.memory:
        return _buildMemoryImage();
    }
  }

  Widget _buildNetworkImage() {
    if (image == null || image!.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return CachedNetworkImage(
      imageUrl: image!,
      width: double.infinity,
      height: double.infinity,
      fit: fit ?? BoxFit.cover,
      color: overlayColor,
      placeholder: (context, url) => TShimmerEffect(
        width: width ?? double.infinity,
        height: height ?? double.infinity,
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: const Icon(Icons.error_outline, color: Colors.red),
      ),
    );
  }

  Widget _buildAssetImage() {
    if (image == null || image!.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Image.asset(
      image!,
      width: double.infinity,
      height: double.infinity,
      fit: fit ?? BoxFit.cover,
      color: overlayColor,
      errorBuilder: (context, error, stackTrace) => Container(
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
      ),
    );
  }

  Widget _buildFileImage() {
    if (file == null) {
      return const SizedBox.shrink();
    }

    return Image.file(
      file!,
      width: double.infinity,
      height: double.infinity,
      fit: fit ?? BoxFit.cover,
      color: overlayColor,
    );
  }

  Widget _buildMemoryImage() {
    if (memoryImage == null) {
      return const SizedBox.shrink();
    }

    return Image.memory(
      memoryImage!,
      width: double.infinity,
      height: double.infinity,
      fit: fit ?? BoxFit.cover,
      color: overlayColor,
    );
  }
}
