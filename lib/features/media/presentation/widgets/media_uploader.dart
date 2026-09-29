import 'dart:typed_data';
import 'package:ecommerce_admin_pannal/features/media/presentation/widgets/web_image_resizer.dart';
import 'package:ecommerce_admin_pannal/utils/popups/exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import '../../domain/entities/image_entity.dart';
import '../controller/media_cubit/media_cubit.dart';
import '../controller/media_cubit/media_state.dart';
import 'folder_dropdown.dart';

class MediaUploader extends StatefulWidget {
  const MediaUploader({super.key});

  @override
  State<MediaUploader> createState() => _MediaUploaderState();
}

class _MediaUploaderState extends State<MediaUploader> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MediaCubit, MediaState>(
      buildWhen: (previous, current) {
        return previous.showImagesUploaderSection !=
                current.showImagesUploaderSection ||
            previous.selectedImagesToUpload.length !=
                current.selectedImagesToUpload.length ||
            previous.selectedPath != current.selectedPath;
      },
      builder: (context, state) {
        if (!state.showImagesUploaderSection) {
          return const SizedBox.shrink();
        }

        final mediaCubit = context.read<MediaCubit>();

        return Column(
          children: [
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: TColors.borderPrimary),
                color: TColors.primaryBackground,
              ),
              padding: const EdgeInsets.all(Sizes.defaultSpace),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final dynamicKey = ValueKey(
                    'dropzone_${constraints.maxWidth}_${constraints.maxHeight}',
                  );

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: DropzoneView(
                          key: dynamicKey,
                          mime: const ['image/jpeg', 'image/png', 'image/webp'],
                          cursor: CursorType.Default,
                          operation: DragOperation.copy,

                          onCreated: (controller) {
                            mediaCubit.setDropzoneController(controller);
                          },

                          onDropFile: (DropzoneFileInterface file) async {
                            try {
                              final controller = mediaCubit.dropzoneController;

                              if (controller == null) {
                                return;
                              }

                              final bytes = await controller.getFileData(file);

                              final filename = await controller.getFilename(
                                file,
                              );

                              final rawBytes = Uint8List.fromList(bytes);

                              final compressedBytes =
                                  await WebImageResizer.resizeImage(rawBytes);

                              final image = ImageEntity(
                                id: '',
                                url: '',
                                file: file,
                                folder: mediaCubit.state.selectedPath.name,
                                filename: filename,
                                localImageToDisplay: compressedBytes,
                              );

                              mediaCubit.addSelectedImageModel(image);
                            } catch (e) {
                              TLoaders.errorSnackBar(
                                title: 'Error',
                                context: context,
                                message: '❌ Error reading dropped file',
                              );
                            }
                          },
                        ),
                      ),

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Iconsax.image5,
                            size: 50,
                            color: TColors.darkGrey,
                          ),

                          const SizedBox(height: Sizes.spaceBtwItems),

                          const Text('Drag and Drop Images here'),

                          const SizedBox(height: Sizes.spaceBtwItems),

                          OutlinedButton(
                            onPressed: () =>
                                mediaCubit.selectLocalImages(context),
                            child: const Text('Select Images'),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: Sizes.spaceBtwItems),

            if (state.selectedImagesToUpload.isNotEmpty)
              RoundedContainer(
                width: double.infinity,
                showBorder: true,
                borderColor: TColors.borderPrimary,
                backgroundColor: TColors.white,
                padding: const EdgeInsets.all(Sizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Select Folder',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),

                            const SizedBox(width: Sizes.spaceBtwItems),

                            MediaFolderDropdown(
                              onChanged: (MediaCategory? newValue) {
                                if (newValue != null) {
                                  mediaCubit.updateSelectedPath(newValue);
                                }
                              },
                            ),
                          ],
                        ),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: mediaCubit.clearAllSelectedImages,
                              child: const Text('Remove All'),
                            ),

                            const SizedBox(width: Sizes.spaceBtwItems),

                            if (!TDeviceUtils.isMobileScreen(context))
                              SizedBox(
                                width: Sizes.buttonWidth,
                                child: ElevatedButton(
                                  onPressed: () {
                                    mediaCubit.uploadImagesConfirmation(
                                      context,
                                    );
                                  },
                                  child: const Text('Upload'),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: Sizes.spaceBtwSections),

                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: Sizes.spaceBtwItems / 2,
                      runSpacing: Sizes.spaceBtwItems / 2,
                      children: state.selectedImagesToUpload
                          .where((image) => image.localImageToDisplay != null)
                          .map(
                            (image) => RoundedImage(
                              width: 90,
                              height: 90,
                              padding: Sizes.sm,
                              imageType: ImageType.memory,
                              memoryImage: image.localImageToDisplay,
                              backgroundColor: TColors.primaryBackground,
                            ),
                          )
                          .toList(),
                    ),

                    const SizedBox(height: Sizes.spaceBtwSections),

                    if (TDeviceUtils.isMobileScreen(context))
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            mediaCubit.uploadImagesConfirmation(context);
                          },
                          child: const Text('Upload'),
                        ),
                      ),
                  ],
                ),
              ),

            const SizedBox(height: Sizes.spaceBtwSections),
          ],
        );
      },
    );
  }
}
