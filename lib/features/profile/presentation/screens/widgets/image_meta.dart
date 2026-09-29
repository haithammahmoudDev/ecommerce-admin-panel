import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../common/local_storage/local_storage_service.dart';
import '../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../utils/constants/enums.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../auth/domain/entities/user_entity.dart';
import '../../../../auth/presentation/cubit/user_cubit/user_cubit.dart';
import '../../../../categories/presentation/screens/create_category/widgets/image_uploader.dart';

class ImageAndMeta extends StatefulWidget {
  const ImageAndMeta({super.key});

  @override
  State<ImageAndMeta> createState() => _ImageAndMetaState();
}

class _ImageAndMetaState extends State<ImageAndMeta> {
  late final UserEntity? user;

  @override
  void initState() {
    super.initState();
    user = LocalStorageService.userRepo.getData()!.toEntity();

  }

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      padding: const EdgeInsets.symmetric(
        vertical: TSizes.lg,
        horizontal: TSizes.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              BlocBuilder<UserCubit, UserState>(
                buildWhen: (previous, current) =>
                previous.user?.profilePicture !=
                    current.user?.profilePicture,
                builder: (context, state) {
                  final profilePicture = state.user?.profilePicture ?? '';
                  final bool isImageLoading =
                      state.userDataStatus == UserDataStatus.loading;
                  final bool hasImage = profilePicture.isNotEmpty;

                  return TImageUploader(
                    right: 10,
                    bottom: 20,
                    left: null,
                    width: 200,
                    height: 200,
                    circular: true,
                    icon: Iconsax.camera,
                    loading: isImageLoading,
                    image: hasImage ? profilePicture : user?.profilePicture ?? TImages.user ,
                    imageType: hasImage ? ImageType.network : ImageType.asset,
                    onIconButtonPressed: () =>
                        context.read<UserCubit>().pickImage(context),
                  );
                },
              ),

              const SizedBox(height: TSizes.spaceBtwItems),

               SizedBox(
                width: 200,
                child: Column(
                  children: [
                    BlocBuilder<UserCubit, UserState>(
                      buildWhen: (previous, current) =>
                      previous.user?.fullName != current.user?.fullName,
                      builder: (context, state) {
                        final fullName = state.user?.fullName ?? '';
                        final bool isLoading =
                            state.userDataStatus == UserDataStatus.loading;

                        return isLoading
                            ? Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 180,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        )
                            : Text(
                          fullName.isNotEmpty ? fullName : 'User Name',
                          style: Theme.of(context).textTheme.headlineLarge,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        );
                      },
                    ),

                    const SizedBox(height: TSizes.spaceBtwItems / 2),

                    Text(
                      user?.email ?? 'yourEmail@gmail.com',
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        ],
      ),
    );
  }
}