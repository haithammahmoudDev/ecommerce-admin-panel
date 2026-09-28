import 'package:ecommerce_admin_pannal/features/brand/presentation/controller/create_brand/create_brand_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// تأكد من تحديث مسارات الاستيراد (Imports) لتتوافق مع هيكل مشروعك الفعلي
import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../utils/constants/app_screens.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../controller/create_banner/create_banner_cubit.dart';

class CreateBannerForm extends StatelessWidget {
  const CreateBannerForm({super.key});

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      width: 500,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading
          const SizedBox(height: TSizes.sm),
          Text(
            'Create New Banner',
            style: Theme.of(context).textTheme.headlineMedium,
          ), // Text
          const SizedBox(height: TSizes.spaceBtwSections),

          // // Image Uploader & Featured Checkbox
          Column(
            children: [
                   GestureDetector(
                  onTap: ()=> context.read<CreateBannerCubit>().pickImage(context),
                  child:   BlocBuilder<CreateBannerCubit, CreateBannerState>(
                  builder: (context, state) {
                  return TRoundedImage(
                  width: 400,
                  height: 200,
                  backgroundColor: TColors.primaryBackground,
                  image: state.imageUrl.isNotEmpty ? state.imageUrl : 'assets/images/profile/select-img.webp',
                  imageType:state.imageUrl.isNotEmpty ? ImageType.network : ImageType.asset,
                );
        },
      ), // TRoundedImage
              ),
        // GestureDetector
              const SizedBox(height: TSizes.spaceBtwItems),
              TextButton(
                onPressed: ()=> context.read<CreateBannerCubit>().pickImage(context),
                child: const Text('Select Image'),
              ), // TextButton
            ],
          ), // Column
          const SizedBox(height: TSizes.spaceBtwInputFields),

          Text(
            'Make your Banner Active or InActive',
            style: Theme.of(context).textTheme.bodyMedium,
          ), // Text
          BlocBuilder<CreateBannerCubit, CreateBannerState>(
        builder: (context, state) {
          return CheckboxMenuButton(
            value: state.isActive,
            onChanged: (value)=> context.read<CreateBannerCubit>().toggleActive(value),
            child: const Text('Active'),
          );
        },
      ), // CheckboxMenuButton
          const SizedBox(height: TSizes.spaceBtwInputFields),

        BlocBuilder<CreateBannerCubit, CreateBannerState>(
        builder: (context, state) {
          final controller = context.read<CreateBannerCubit>();
          return DropdownButton<String>(
          value: state.targetScreen,
          onChanged: (String? newValue) => controller.selectTargetScreen(newValue),
          items: AppScreens.allAppScreenItems.map<DropdownMenuItem<String>>((value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
        );
        },
      ), // Dropd
          const SizedBox(height: TSizes.spaceBtwInputFields),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.read<CreateBannerCubit>().createBanner(context),
              child: const Text('Create'),
            ), // ElevatedButton
          ), // SizedBox
          const SizedBox(height: TSizes.spaceBtwInputFields),
        ],
      ), // Form
    ); // TRoundedContainer
  }
}
