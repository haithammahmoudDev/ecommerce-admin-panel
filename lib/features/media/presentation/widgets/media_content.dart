import 'package:ecommerce_admin_pannal/features/media/presentation/controller/media_cubit/media_state.dart';
import 'package:ecommerce_admin_pannal/features/media/presentation/widgets/view_image_detail.dart';
import 'package:ecommerce_admin_pannal/utils/popups/exports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../common/widgets/loaders/animation_loader.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/loader.dart';
import '../../data/models/image_model.dart';
import '../controller/media_cubit/media_cubit.dart';
import '../controller/media_cubit/media_state.dart';
import 'folder_dropdown.dart';

class MediaContent extends StatelessWidget {
    MediaContent({super.key, required this.allowSelection,
    required this.allowMultipleSelection, this.alreadySelectedUrls, this.onImagesSelected});
  final bool allowSelection;
  final bool allowMultipleSelection;
  final List<String>? alreadySelectedUrls;
  final List<ImageModel>? selectedImages = [];
  final Function(List<ImageModel>? selectedImages)? onImagesSelected;
  @override
  Widget build(BuildContext context) {
    bool loadedPreviousSelection = false;
    return BlocListener<MediaCubit, MediaState>(
  listener: (context, state) {
    if (state.uploadStatus == MediaUploadStatus.error) {
      TLoaders.errorSnackBar(title: 'error', context: context , message: state.errorMessage ?? '');
      print(state.errorMessage ?? '');
    }
  },
  child: TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// عنوان أرشيف الصور السحابية
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Select Folder',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  MediaFolderDropdown(
                    onChanged: (MediaCategory? newValue) {
                      if (newValue != null) {
                        context.read<MediaCubit>().updateSelectedPath(newValue);
                        context.read<MediaCubit>().getMediaImages();
                      }
                    },
                  ),
                ],
              ),
              if (allowSelection) buildAddSelectedImagesButton(context),

            ],
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          /// Show Media
         BlocBuilder<MediaCubit, MediaState>(
         builder: (context, state) {
           List<ImageModel> images = _getSelectedFolderImages(state);

           if (!loadedPreviousSelection) {
             if (alreadySelectedUrls != null && alreadySelectedUrls!.isNotEmpty) {
               // Convert alreadySelectedUrls to a Set for faster lookup
               final selectedUrlsSet = Set<String>.from(alreadySelectedUrls!);

               for (var image in images) {
                 image.isSelected = selectedUrlsSet.contains(image.url);
                 if (image.isSelected) {
                   selectedImages?.add(image);
                 }
               }
             } else {
                for (var image in images) {
                 image.isSelected = false;
               }
             }
             loadedPreviousSelection = true;
           }
           if (state.uploadStatus == MediaUploadStatus.loading && images.isEmpty) {
            return Center(child: CircularProgressIndicator(color: Colors.blue,));
          }

            if (images.isEmpty) {
             return _buildEmptyAnimationWidget(context);
           }         return Column(
             mainAxisSize: MainAxisSize.min,
             crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Wrap(
                alignment: WrapAlignment.start,
                spacing: TSizes.spaceBtwItems / 2,
                runSpacing: TSizes.spaceBtwItems / 2,
                children: images
                    .map((image) => GestureDetector(
                  onTap: ()=> showDialog(
                    context: context,
                    builder: (_) => ImagePopup(image: image, cubit: context.read<MediaCubit>(),),
                  ),
                  child: SizedBox(
                    width: 140,
                    height: 180,
                    child: Column(
                      children: [
                        allowSelection ? _buildListWithCheckbox(image) : _buildSimpleList(image),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
                            child: Text(
                              image.filename,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ), // Padding
                        ), // Expanded
                      ],
                    ), // Column
                  ), // SizedBox
                )) // GestureDetector
                    .toList(),

              ),
             if(!state.isLoadingMore)
             Padding(
               padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   SizedBox(
                     width: TSizes.buttonWidth,
                     child: ElevatedButton.icon(
                       onPressed: ()=> context.read<MediaCubit>().loadMoreMediaImages(),
                       label: const Text('Load More'),
                       icon: const Icon(Iconsax.arrow_down),
                     ), // ElevatedButton.icon
                   ), // SizedBox
                 ],
               ), // Row
             ), // Padding
           ],
         );
  },
), // Wrap
        ],
      ),
    ),
);
  }

  List<ImageModel> _getSelectedFolderImages(MediaState state) {
    List<ImageModel> images = [];

    if (state.selectedPath == MediaCategory.banners) {
      images = state.allBannerImages.where((image) => image.url.isNotEmpty).toList();
    } else if (state.selectedPath == MediaCategory.brands) {
      images = state.allBrandImages.where((image) => image.url.isNotEmpty).toList();
    } else if (state.selectedPath == MediaCategory.categories) {
      images = state.allCategoryImages.where((image) => image.url.isNotEmpty).toList();
    } else if (state.selectedPath == MediaCategory.products) {
      images = state.allProductImages.where((image) => image.url.isNotEmpty).toList();
    } else if (state.selectedPath == MediaCategory.users) {
      images = state.allUserImages.where((image) => image.url.isNotEmpty).toList();
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
            Icon(
              Icons.folder_open_rounded,
              size: 120.0,
              color: Colors.blue,
            ),
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

    Widget _buildSimpleList(ImageModel image) {
    return TRoundedImage(
      width: 140,
      height: 140,
      padding: TSizes.sm,
       image: image.getOptimizedUrl(width: 300),
      imageType: ImageType.network,
      margin: TSizes.spaceBtwItems / 2,
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
          const SizedBox(width: TSizes.spaceBtwItems),
          SizedBox(
            width: 120,
            child: ElevatedButton.icon(
              label: const Text('Add'),
              icon: const Icon(Iconsax.image),
              onPressed: () {
                // جلب الصور المختارة مباشرة من MediaCubit
                final selectedImagesFromCubit =
                    context.read<MediaCubit>().state.selectedImagesToUpload;

                // إرجاع القائمة عند إغلاق الـ Bottom Sheet
                context.pop(selectedImagesFromCubit);
              },
            ),
          ),
        ],
      );
    }
    Widget _buildListWithCheckbox(ImageModel image) {
      return Stack(
        children: [
          TRoundedImage(
            width: 140,
            height: 140,
            padding: TSizes.sm,
            image: image.url,
            imageType: ImageType.network,
            margin: TSizes.spaceBtwItems / 2,
            backgroundColor: TColors.primaryBackground,
          ),
          Positioned(
            top: TSizes.md,
            right: TSizes.md,
            child: BlocBuilder<MediaCubit, MediaState>(
              builder: (context, state) {
                final isSelected = state.selectedImagesToUpload.any(
                      (img) => (img.id.isNotEmpty && img.id == image.id) ||
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
