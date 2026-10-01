import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../domain/entities/banner_entity.dart';
import '../../../controller/edit_banner/edit_banner_cubit.dart';
import '../../create_banner/widgets/destination_picker_dialog.dart';

class EditBannerForm extends StatelessWidget {
  final BannerEntity banner;
  const EditBannerForm({super.key, required this.banner});

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      width: 520,
      padding: const EdgeInsets.all(Sizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Iconsax.edit, color: TColors.primary, size: 28),
              const SizedBox(width: Sizes.spaceBtwItems / 2),
              Text(
                'Update Banner',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          const SizedBox(height: Sizes.spaceBtwSections),

          // Image Uploader Card
          Center(
            child: Column(
              children: [
                BlocBuilder<EditBannerCubit, EditBannerState>(
                  builder: (context, state) {
                    final hasImage = state.imageUrl.isNotEmpty;
                    return GestureDetector(
                      onTap: () => context.read<EditBannerCubit>().pickImage(context),
                      child: Container(
                        width: 440,
                        height: 200,
                        padding: const EdgeInsets.all(Sizes.sm),
                        decoration: BoxDecoration(
                          color: TColors.primaryBackground,
                          borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Sizes.borderRadiusMd),
                          child: RoundedImage(
                            width: 440,
                            height: 200,
                            backgroundColor: Colors.transparent,
                            image: hasImage ? state.imageUrl : 'assets/logos/gallery.jpg',
                            imageType: hasImage ? ImageType.network : ImageType.asset,
                            fit: BoxFit.fill, // تظهر الصورة الافتراضية كاملة بدون قص
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: Sizes.spaceBtwItems),
                OutlinedButton.icon(
                  onPressed: () => context.read<EditBannerCubit>().pickImage(context),
                  icon: const Icon(Iconsax.gallery_edit, size: 18),
                  label: const Text('Change Banner Image'),
                ),
              ],
            ),
          ),
          const SizedBox(height: Sizes.spaceBtwInputFields),

          // Active Switch Container
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(Sizes.borderRadiusMd),
            ),
            child: Material(
              color: Colors.transparent,
              child: BlocBuilder<EditBannerCubit, EditBannerState>(
                builder: (context, state) {
                  return SwitchListTile(
                    title: const Text('Active Status'),
                    subtitle: const Text('Toggle banner visibility'),
                    value: state.isActive,
                    activeColor: TColors.primary,
                    onChanged: (value) => context.read<EditBannerCubit>().toggleActive(value),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: Sizes.spaceBtwInputFields),

          // Target Type Dropdown (Enum)
          Text('Target Destination Type', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: Sizes.spaceBtwItems / 2),
          BlocBuilder<EditBannerCubit, EditBannerState>(
            builder: (context, state) {
              final controller = context.read<EditBannerCubit>();
              return DropdownButtonFormField<BannerTargetType>(
                value: state.targetType,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Iconsax.category_2),
                ),
                onChanged: (BannerTargetType? newValue) => controller.selectTargetType(newValue),
                items: BannerTargetType.values.map<DropdownMenuItem<BannerTargetType>>((type) {
                  return DropdownMenuItem<BannerTargetType>(
                    value: type,
                    child: Text(type.name.toUpperCase()),
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: Sizes.spaceBtwInputFields),

          // Dynamic Section based on TargetType
          BlocBuilder<EditBannerCubit, EditBannerState>(
            builder: (context, state) {
              if (state.targetType.requiresTarget) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: TColors.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(Sizes.borderRadiusMd),
                        border: Border.all(color: TColors.primary.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Iconsax.tick_circle, color: TColors.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Selected ${state.targetType.name}: ${state.targetName.isNotEmpty ? state.targetName : 'None'}',
                              style: Theme.of(context).textTheme.bodyLarge?.apply(color: TColors.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Sizes.spaceBtwItems),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          final type = state.targetType.name.toLowerCase().contains('product') ? 'product' : 'category';
                          showDialog(
                            context: context,
                            builder: (_) => DestinationPickerDialog(
                              type: type,
                              onSelected: (id, name) {
                                context.read<EditBannerCubit>().setTargetDetails(id, name);
                              },
                            ),
                          );
                        },
                        icon: const Icon(Iconsax.search_normal),
                        label: Text('Change ${state.targetType.name} from Database'),
                      ),
                    ),
                    const SizedBox(height: Sizes.spaceBtwInputFields),
                  ],
                );
              }

              if (state.targetType == BannerTargetType.external) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      initialValue: state.targetId,
                      decoration: const InputDecoration(
                        labelText: 'External URL',
                        hintText: 'https://example.com',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Iconsax.link),
                      ),
                      onChanged: (value) {
                        context.read<EditBannerCubit>().setTargetDetails(value, 'External Link');
                      },
                    ),
                    const SizedBox(height: Sizes.spaceBtwInputFields),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),

          // Update Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => context.read<EditBannerCubit>().editBanner(context: context, id: banner.id),
              icon: const Icon(Iconsax.refresh),
              label: const Text('Update Banner'),
            ),
          ),
          const SizedBox(height: Sizes.spaceBtwInputFields),
        ],
      ),
    );
  }
}