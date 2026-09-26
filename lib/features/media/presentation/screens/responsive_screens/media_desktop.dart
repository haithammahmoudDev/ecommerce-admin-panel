import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/breadcrumbs/breadcrumb.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../controller/media_cubit/media_cubit.dart';
 import '../../widgets/media_content.dart';
 import '../../widgets/media_uploader.dart';

class MediaDesktopScreen extends StatelessWidget {
  const MediaDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Builder(
              builder: (context) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const TBreadcrumbsWithHeading(
                          heading: 'Media',
                          breadcrumbItems: ['Media Screen'],
                        ),

                        SizedBox(
                          width: TSizes.buttonWidth * 1.5,
                          child: ElevatedButton.icon(
                            onPressed: () => context.read<MediaCubit>().toggleImagesUploaderSection(),
                            icon: const Icon(Iconsax.cloud_add),
                            label: const Text('Upload Images'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),

                     MediaUploader(),
                    const SizedBox(height: TSizes.spaceBtwSections),

                     MediaContent(allowSelection: false, allowMultipleSelection: false,),
                  ],
                );
              }
          ),
        ),
      ),
    );
  }
}
