import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../categories/presentation/screens/create_category/widgets/image_uploader.dart';
import '../../controller/settings_cubit/settings_cubit.dart';

class ImageAndMeta extends StatelessWidget {
  const ImageAndMeta({super.key});

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      padding: const EdgeInsets.symmetric(vertical: Sizes.lg, horizontal: Sizes.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              BlocSelector<SettingsCubit, SettingsState, ({String appLogo, bool isLogoLoading})>(
                selector: (state) => (
                appLogo: state.settings.appLogo,
                isLogoLoading: state.isLogoLoading,
                ),
                builder: (context, logoData) {
                   return TImageUploader(
                    right: 10,
                    bottom: 20,
                    left: null,
                    width: 200,
                    height: 200,
                    circular: true,
                    icon: Iconsax.camera,
                    loading: logoData.isLogoLoading,
                    onIconButtonPressed: () =>
                        context.read<SettingsCubit>().updateAppLogo(context),
                    imageType: ImageType.network,
                    image: logoData.appLogo,
                  );
                },
              ),
              const SizedBox(height: Sizes.spaceBtwSections),
            ],
          ),
        ],
      ),
    );
  }
}