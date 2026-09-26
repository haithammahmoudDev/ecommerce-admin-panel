import 'package:ecommerce_admin_pannal/features/auth/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import '../../../di/injection_container.dart';
import '../../images/t_rounded_image.dart';

class THeader extends StatelessWidget implements PreferredSizeWidget {
  const THeader({super.key, this.scaffoldKey});

  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  Widget build(BuildContext context) {
    // 💡 الحل الهندسي للمشكلة: نعتبر الأجهزة من حجم 1100 بكسل فما فوق ضمن الـ Desktop
    // لتتطابق أبعاد الـ Header تماماً مع أبعاد شاشة الداشبورد المخصصة للاب توب الصغير
    final isDesktop = MediaQuery.of(context).size.width >= 1100;

    return BlocProvider(
      create: (_) => sl<UserCubit>()..getUserData(),
      child: Builder(builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: TColors.white,
            border: Border(
              bottom: BorderSide(
                color: TColors.grey,
                width: 1,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: TSizes.md,
            vertical: TSizes.sm,
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

                // الـ Spacer لفصل المحتويات بالمنتصف
                const Spacer(),

                // أيقونة البحث تظهر جهة اليمين فقط في حالة الشاشات الأصغر من 1100 بكسل
                if (!isDesktop)
                  IconButton(
                    icon: const Icon(Iconsax.search_normal),
                    onPressed: () {},
                  ),

                // زر الإشعارات
                IconButton(
                  icon: const Icon(Iconsax.notification),
                  onPressed: () {},
                ),

                const SizedBox(width: TSizes.spaceBtwItems / 2),

                // صورة وبيانات المستخدم
                BlocBuilder<UserCubit, UserState>(
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
                        const SizedBox(width: TSizes.sm),

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
      }),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    TDeviceUtils.getAppBarHeight() + 15,
  );
}

/// Shimmer while user data is loading
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
            const SizedBox(width: TSizes.sm),
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

/// Error state
class _UserError extends StatelessWidget {
  const _UserError();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Iconsax.user,
      size: 30,
    );
  }
}
