import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../controller/create_banner/create_banner_cubit.dart';
import '../widgets/destination_picker_dialog.dart';

class CreateBannerForm extends StatelessWidget {
  const CreateBannerForm({super.key});

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
              const Icon(Iconsax.image, color: TColors.primary, size: 28),
              const SizedBox(width: Sizes.spaceBtwItems / 2),
              Text(
                'Create New Banner',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          const SizedBox(height: Sizes.spaceBtwSections),

           Center(
            child: Column(
              children: [
                BlocBuilder<CreateBannerCubit, CreateBannerState>(
                  builder: (context, state) {
                    final hasImage = state.imageUrl.isNotEmpty;
                    return GestureDetector(
                      onTap: () => context.read<CreateBannerCubit>().pickImage(context),
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
                            fit:BoxFit.fill , // تظهر الصورة بالكامل بدون قص للـ Asset
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: Sizes.spaceBtwItems),
                OutlinedButton.icon(
                  onPressed: () => context.read<CreateBannerCubit>().pickImage(context),
                  icon: const Icon(Iconsax.gallery_add, size: 18),
                  label: const Text('Select Banner Image'),
                ),
              ],
            ),
          ),
          const SizedBox(height: Sizes.spaceBtwInputFields),

           Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(Sizes.borderRadiusMd),
            ),
            child: Material(
              color: Colors.transparent,
              child: BlocBuilder<CreateBannerCubit, CreateBannerState>(
                builder: (context, state) {
                  return SwitchListTile(
                    title: const Text('Active Status'),
                    subtitle: const Text('Make your Banner Active or InActive on display'),
                    value: state.isActive,
                    activeThumbColor: TColors.primary,
                    onChanged: (value) => context.read<CreateBannerCubit>().toggleActive(value),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: Sizes.spaceBtwInputFields),

           Text('Target Destination Type', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: Sizes.spaceBtwItems / 2),
          BlocBuilder<CreateBannerCubit, CreateBannerState>(
            builder: (context, state) {
              final controller = context.read<CreateBannerCubit>();
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

           BlocBuilder<CreateBannerCubit, CreateBannerState>(
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
                                context.read<CreateBannerCubit>().setTargetDetails(id, name);
                              },
                            ),
                          );
                        },
                        icon: const Icon(Iconsax.search_normal),
                        label: Text('Select ${state.targetType.name} from Database'),
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
                        context.read<CreateBannerCubit>().setTargetDetails(value, 'External Link');
                      },
                    ),
                    const SizedBox(height: Sizes.spaceBtwInputFields),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),

          // Create Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => context.read<CreateBannerCubit>().createBanner(context),
              icon: const Icon(Iconsax.add),
              label: const Text('Create Banner'),
            ),
          ),
          const SizedBox(height: Sizes.spaceBtwInputFields),
        ],
      ),
    );
  }
}