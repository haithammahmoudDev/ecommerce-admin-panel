import 'package:ecommerce_admin_pannal/features/media/presentation/controller/media_cubit/media_state.dart';
import 'package:ecommerce_admin_pannal/features/media/presentation/widgets/view_image_detail.dart';
import 'package:ecommerce_admin_pannal/utils/popups/exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import '../../domain/entities/image_entity.dart';
import '../controller/media_cubit/media_cubit.dart';
import 'folder_dropdown.dart';

class MediaContent extends StatelessWidget {
  MediaContent({
    super.key,
    required this.allowSelection,
    required this.allowMultipleSelection,
    this.alreadySelectedUrls,
  });

  final bool allowSelection;
  final bool allowMultipleSelection;
  final List<String>? alreadySelectedUrls;
  final List<ImageEntity> selectedImages = [];

  @override
  Widget build(BuildContext context) {
    bool loadedPreviousSelection = false;

    return BlocListener<MediaCubit, MediaState>(
      listener: (context, state) {
        if (state.uploadStatus == MediaUploadStatus.error) {
          TLoaders.errorSnackBar(
            title: 'error',
            context: context,
            message: state.errorMessage ?? 'exist unexpected error, try again please',
          );
        }
      },
      child: RoundedContainer(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Responsive Header Section
            !TDeviceUtils.isMobileScreen(context)
                ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Select Folder',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(width: Sizes.spaceBtwItems),
                    MediaFolderDropdown(
                      onChanged: (MediaCategory? newValue) {
                        if (newValue != null) {
                          context.read<MediaCubit>().updateSelectedPath(
                            newValue,
                          );
                          context.read<MediaCubit>().getMediaImages();
                        }
                      },
                    ),
                  ],
                ),
                if (allowSelection) buildAddSelectedImagesButton(context),
              ],
            )
                : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Select Folder',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(width: Sizes.spaceBtwItems),
                    MediaFolderDropdown(
                      onChanged: (MediaCategory? newValue) {
                        if (newValue != null) {
                          context.read<MediaCubit>().updateSelectedPath(
                            newValue,
                          );
                          context.read<MediaCubit>().getMediaImages();
                        }
                      },
                    ),
                  ],
                ),
                if (allowSelection) ...[
                  const SizedBox(height: Sizes.spaceBtwItems),
                  buildAddSelectedImagesButtonWithMobile(context),
                ],
              ],
            ),
            const SizedBox(height: Sizes.spaceBtwSections),

            BlocBuilder<MediaCubit, MediaState>(
              builder: (context, state) {
                List<ImageEntity> images = _getSelectedFolderImages(state);

                if (!loadedPreviousSelection) {
                  if (alreadySelectedUrls != null &&
                      alreadySelectedUrls!.isNotEmpty) {
                    final selectedUrlsSet = Set<String>.from(
                      alreadySelectedUrls!,
                    );

                    for (var image in images) {
                      final bool isSelected = selectedUrlsSet.contains(
                        image.url,
                      );
                      if (isSelected) {
                        selectedImages.add(image);
                      }
                    }
                  }
                  loadedPreviousSelection = true;
                }

                if (state.uploadStatus == MediaUploadStatus.loading &&
                    images.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.blue),
                  );
                }

                if (images.isEmpty) {
                  return _buildEmptyAnimationWidget(context);
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: Sizes.spaceBtwItems / 2,
                      runSpacing: Sizes.spaceBtwItems / 2,
                      children: images
                          .map(
                            (image) => GestureDetector(
                          onTap: () => showDialog(
                            context: context,
                            builder: (_) => ImagePopup(
                              image: image,
                              cubit: context.read<MediaCubit>(),
                            ),
                          ),
                          child: SizedBox(
                            width: 140,
                            height: 180,
                            child: Column(
                              children: [
                                allowSelection
                                    ? _buildListWithCheckbox(image)
                                    : _buildSimpleList(image),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: Sizes.sm,
                                    ),
                                    child: Text(
                                      image.filename,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                          .toList(),
                    ),
                    if (!state.isLoadingMore)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Sizes.spaceBtwSections,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: Sizes.buttonWidth,
                              child: ElevatedButton.icon(
                                onPressed: () => context
                                    .read<MediaCubit>()
                                    .loadMoreMediaImages(),
                                label: const Text('Load More'),
                                icon: const Icon(Iconsax.arrow_down),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<ImageEntity> _getSelectedFolderImages(MediaState state) {
    List<ImageEntity> images = [];

    if (state.selectedPath == MediaCategory.banners) {
      images = state.allBannerImages
          .where((image) => image.url.isNotEmpty)
          .toList();
    } else if (state.selectedPath == MediaCategory.brands) {
      images = state.allBrandImages
          .where((image) => image.url.isNotEmpty)
          .toList();
    } else if (state.selectedPath == MediaCategory.categories) {
      images = state.allCategoryImages
          .where((image) => image.url.isNotEmpty)
          .toList();
    } else if (state.selectedPath == MediaCategory.products) {
      images = state.allProductImages
          .where((image) => image.url.isNotEmpty)
          .toList();
    } else if (state.selectedPath == MediaCategory.users) {
      images = state.allUserImages
          .where((image) => image.url.isNotEmpty)
          .toList();
    }

    return images;
  }

  Widget _buildEmptyAnimationWidget(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open_rounded, size: 120.0, color: Colors.blue),
            SizedBox(height: 16.0),
            Text(
              'Select your Desired Folder',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleList(ImageEntity image) {
    return RoundedImage(
      width: 140,
      height: 140,
      padding: Sizes.sm,
      image: image.getOptimizedUrl(width: 300),
      imageType: ImageType.network,
      margin: Sizes.spaceBtwItems / 2,
      backgroundColor: TColors.primaryBackground,
    );
  }

  Widget buildAddSelectedImagesButton(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 120,
          child: OutlinedButton.icon(
            label: const Text('Close'),
            icon: const Icon(Iconsax.close_circle),
            onPressed: () => context.pop(),
          ),
        ),
        const SizedBox(width: Sizes.spaceBtwItems),
        SizedBox(
          width: 120,
          child: ElevatedButton.icon(
            label: const Text('Add'),
            icon: const Icon(Iconsax.image),
            onPressed: () {
              final selectedImagesFromCubit = context
                  .read<MediaCubit>()
                  .state
                  .selectedImagesToUpload;

              context.pop(selectedImagesFromCubit);
            },
          ),
        ),
      ],
    );
  }

  Widget buildAddSelectedImagesButtonWithMobile(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: OutlinedButton.icon(
            label: const Text('Close'),
            icon: const Icon(Iconsax.close_circle),
            onPressed: () => context.pop(),
          ),
        ),
        const SizedBox(width: Sizes.spaceBtwItems * 2),
        Expanded(
          child: ElevatedButton.icon(
            label: const Text('Add'),
            icon: const Icon(Iconsax.image),
            onPressed: () {
              final selectedImagesFromCubit = context
                  .read<MediaCubit>()
                  .state
                  .selectedImagesToUpload;

              context.pop(selectedImagesFromCubit);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildListWithCheckbox(ImageEntity image) {
    return Stack(
      children: [
        RoundedImage(
          width: 140,
          height: 140,
          padding: Sizes.sm,
          image: image.url,
          imageType: ImageType.network,
          margin: Sizes.spaceBtwItems / 2,
          backgroundColor: TColors.primaryBackground,
        ),
        Positioned(
          top: Sizes.md,
          right: Sizes.md,
          child: BlocBuilder<MediaCubit, MediaState>(
            builder: (context, state) {
              final isSelected = state.selectedImagesToUpload.any(
                    (img) =>
                (img.id.isNotEmpty && img.id == image.id) ||
                    (img.url.isNotEmpty && img.url == image.url),
              );

              return Checkbox(
                value: isSelected,
                onChanged: (selected) {
                  context.read<MediaCubit>().toggleImageSelection(
                    image,
                    allowMultipleSelection: allowMultipleSelection,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}