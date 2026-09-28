import 'package:ecommerce_admin_pannal/features/banner/data/models/banner_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

// تأكد من تحديث مسارات الاستيراد (Imports) لتتوافق مع هيكل مشروعك الفعلي
import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../utils/constants/app_screens.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../domain/entities/banner_entity.dart';
import '../../../controller/create_banner/create_banner_cubit.dart';
import '../../../controller/edit_banner/edit_banner_cubit.dart';

class EditBannerForm extends StatelessWidget {
   const EditBannerForm({super.key, required this.banner});
    final BannerEntity banner;
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
            'Edit Banner',
            style: Theme.of(context).textTheme.headlineMedium,
          ), // Text
          const SizedBox(height: TSizes.spaceBtwSections),

          // // Image Uploader & Featured Checkbox
          Column(
            children: [
              GestureDetector(
                onTap: ()=> context.read<EditBannerCubit>().pickImage(context),
                child:   BlocBuilder<EditBannerCubit, EditBannerState>(
                  builder: (context, state) {
                    return TRoundedImage(
                      width: 400,
                      height: 200,
                      backgroundColor: TColors.primaryBackground,
                      image: state.imageUrl.isNotEmpty ? state.imageUrl : banner.imageUrl,
                      imageType: ImageType.network,
                    );
                  },
                ), // TRoundedImage
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              TextButton(
                onPressed: ()=> context.read<EditBannerCubit>().pickImage(context),
                child: const Text('Select Image'),
              ), // TextButton
            ],
          ), // Column
          const SizedBox(height: TSizes.spaceBtwInputFields),

          Text(
            'Make your Banner Active or InActive',
            style: Theme.of(context).textTheme.bodyMedium,
          ), // Text
          BlocBuilder<EditBannerCubit, EditBannerState>(
            builder: (context, state) {
              return CheckboxMenuButton(
                value: state.isActive ?? banner.active,
                onChanged: (value)=> context.read<EditBannerCubit>().toggleActive(value),
                child: const Text('Active'),
              );
            },
          ),  // CheckboxMenuButton
          const SizedBox(height: TSizes.spaceBtwInputFields),

          // // Dropdown Menu Screens
          BlocBuilder<EditBannerCubit, EditBannerState>(
            builder: (context, state) {
              final controller = context.read<EditBannerCubit>();
              return DropdownButton<String>(
                value: state.targetScreen == AppScreens.onboarding ?  banner.targetScreen : state.targetScreen,
                onChanged: (String? newValue) => controller.selectTargetScreen(newValue),
                items: AppScreens.allAppScreenItems.map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value));
                }).toList(),
              );
            },
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields * 2),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.read<EditBannerCubit>().editCategory(context: context,
                  id: banner.id),
              child: const Text('Update'),
            ), // ElevatedButton
          ), // SizedBox
          const SizedBox(height: TSizes.spaceBtwInputFields * 2),
        ],
      ), // Form
    ); // TRoundedContainer
  }
}
