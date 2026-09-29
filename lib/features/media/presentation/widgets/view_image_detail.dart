import 'package:ecommerce_admin_pannal/features/media/presentation/controller/media_cubit/media_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import '../../../../utils/popups/loaders.dart';
import '../../domain/entities/image_entity.dart';

class ImagePopup extends StatelessWidget {
  final ImageEntity image;
  final MediaCubit cubit;

  const ImagePopup({super.key, required this.image, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
        ),
        child: RoundedContainer(
          width: TDeviceUtils.isDesktopScreen(context)
              ? MediaQuery.of(context).size.width * 0.4
              : MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(TSizes.spaceBtwItems),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  // داخل ملف image_popup.dart عند بناء المعاينة:
                  RoundedContainer(
                    backgroundColor: TColors.primaryBackground,
                    child: TRoundedImage(
                      // 🟢 دقة متوسطة ومناسبة للعرض في النافذة المنبثقة بدون تحميل الحجم الأصلي الكامل
                      image: image.getOptimizedUrl(width: 800),
                      applyImageRadius: true,
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: TDeviceUtils.isDesktopScreen(context)
                          ? MediaQuery.of(context).size.width * 0.4
                          : MediaQuery.of(context).size.width,
                      imageType: ImageType.network,
                    ),
                  ),

                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        if (context.mounted) {
                          context.pop();
                        }
                      },
                      icon: const Icon(Iconsax.close_circle),
                    ),
                  ),
                ],
              ),

              const Divider(),

              const SizedBox(height: TSizes.spaceBtwItems),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Image Name:',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      image.filename,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: TSizes.spaceBtwItems),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Image URL:',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),

                  Expanded(
                    flex: 2,
                    child: Text(
                      image.url,
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: image.url)).then((
                          _,
                        ) {
                          if (!context.mounted) return;

                          TLoaders.customToast(
                            message: 'URL copied!',
                            context: context,
                          );
                        });
                      },
                      child: const Text('Copy URL'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: TSizes.spaceBtwSections),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    child: TextButton(
                      onPressed: () {
                        cubit.removeCloudImageConfirmation(context, image);
                      },
                      child: const Text(
                        'Delete Image',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
