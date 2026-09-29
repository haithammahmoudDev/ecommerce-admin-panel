import 'package:ecommerce_admin_pannal/features/auth/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import '../../images/t_rounded_image.dart';

class HeaderCustom extends StatelessWidget implements PreferredSizeWidget {
  const HeaderCustom({super.key, this.scaffoldKey});

  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 1100;

    return Builder(
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: TColors.white,
            border: Border(bottom: BorderSide(color: TColors.grey, width: 1)),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.md,
            vertical: Sizes.sm,
          ),
          child: SafeArea(
            child: Row(
              children: [
                // زر الهمبرغر يظهر فقط في التابلت والموبايل (الأصغر من 1100 بكسل)
                if (!isDesktop)
                  IconButton(
                    onPressed: () {
                      scaffoldKey?.currentState?.openDrawer();
                    },
                    icon: const Icon(Iconsax.menu),
                  ),

                // حقل إدخال البحث الكامل يثبت الآن على شاشات اللاب توب الصغير (1100 بكسل)
                if (isDesktop)
                  SizedBox(
                    width: 400,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.search_normal),
                        hintText: 'Search anything...',
                      ),
                    ),
                  ),

                const Spacer(),

                if (!isDesktop)
                  IconButton(
                    icon: const Icon(Iconsax.search_normal),
                    onPressed: () {},
                  ),

                IconButton(
                  icon: const Icon(Iconsax.notification),
                  onPressed: () {},
                ),

                const SizedBox(width: Sizes.spaceBtwItems / 2),

                BlocBuilder<UserCubit, UserState>(
                  buildWhen: (previous, current) =>
                      previous.user?.fullName != current.user?.fullName ||
                      previous.user?.profilePicture !=
                          current.user?.profilePicture,
                  builder: (context, state) {
                    if (state.userDataStatus == UserDataStatus.loading) {
                      return const _UserShimmer();
                    }

                    if (state.userDataStatus == UserDataStatus.error) {
                      return const _UserError();
                    }

                    final user = state.user;

                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TRoundedImage(
                          width: 40,
                          height: 40,
                          padding: 0,
                          imageType: ImageType.network,
                          image: user?.profilePicture ?? '',
                          isCircle: true,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: Sizes.sm),

                        if (!TDeviceUtils.isMobileScreen(context))
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.fullName ?? 'User',
                                style: Theme.of(context).textTheme.titleLarge,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                user?.email ?? '',
                                style: Theme.of(context).textTheme.labelMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(TDeviceUtils.getAppBarHeight() + 15);
}

class _UserShimmer extends StatelessWidget {
  const _UserShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          if (!TDeviceUtils.isMobileScreen(context)) ...[
            const SizedBox(width: Sizes.sm),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 110,
                  height: 15,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 150,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _UserError extends StatelessWidget {
  const _UserError();

  @override
  Widget build(BuildContext context) {
    return const Icon(Iconsax.user, size: 30);
  }
}
