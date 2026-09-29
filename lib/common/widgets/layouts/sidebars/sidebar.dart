import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../features/product/presentation/screens/edit_product/widgets/thumbnail_widget.dart';
import '../../../../features/settings/presentation/controller/settings_cubit/settings_cubit.dart';
import '../../../../utils/constants/sizes.dart';
import 'menu/menu_item.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const BeveledRectangleBorder(),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(right: BorderSide(color: Colors.grey, width: 1)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
                  BlocBuilder<SettingsCubit, SettingsState>(
                    buildWhen: (previous, current) =>
                        previous.settings.appLogo != current.settings.appLogo,
                    builder: (context, state) {
                      final appLogo = state.settings.appLogo;
                      final bool isLoading = state.isLogoLoading;

                      if (isLoading || appLogo.isEmpty) {
                        return const TShimmerEffect(
                          width: 60,
                          height: 60,
                          radius: 60,
                        );
                      }

                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.lightBlue,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.08),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.network(
                            appLogo,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.business,
                                  size: 30,
                                  color: Colors.grey,
                                ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: BlocBuilder<SettingsCubit, SettingsState>(
                      buildWhen: (previous, current) =>
                          previous.settings.appName != current.settings.appName,
                      builder: (context, state) {
                        final appName = state.settings.appName;
                        final bool isLoading = state.isLogoLoading;

                        if (isLoading || appName.isEmpty) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: const TShimmerEffect(
                              width: 110,
                              height: 20,
                              radius: 4,
                            ),
                          );
                        }

                        return Text(
                          appName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                letterSpacing: 0.8,
                              ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: Sizes.spaceBtwSections / 2),

              Padding(
                padding: const EdgeInsets.all(Sizes.md / 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'MENU',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall!.apply(letterSpacingDelta: 1.2),
                    ),
                    const MenuItem(
                      route: '/dashboard',
                      icon: Iconsax.status,
                      itemName: 'Dashboard',
                    ),
                    const MenuItem(
                      route: '/media',
                      icon: Iconsax.image,
                      itemName: 'Media',
                    ),
                    const MenuItem(
                      route: '/categories',
                      icon: Iconsax.category_2,
                      itemName: 'Categories',
                    ),
                    const MenuItem(
                      route: '/brands',
                      icon: Iconsax.dcube,
                      itemName: 'Brands',
                    ),
                    const MenuItem(
                      route: '/banners',
                      icon: Iconsax.picture_frame,
                      itemName: 'Banners',
                    ),
                    const MenuItem(
                      route: '/products',
                      icon: Iconsax.shopping_bag,
                      itemName: 'Products',
                    ),
                    const MenuItem(
                      route: '/customers',
                      icon: Iconsax.profile_2user,
                      itemName: 'Customers',
                    ),
                    const MenuItem(
                      route: '/orders',
                      icon: Iconsax.box,
                      itemName: 'Orders',
                    ),
                    Text(
                      'OTHER',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall!.apply(letterSpacingDelta: 1.2),
                    ),
                    const MenuItem(
                      route: '/profile',
                      icon: Iconsax.user,
                      itemName: 'Profile',
                    ),
                    const MenuItem(
                      route: '/settings',
                      icon: Iconsax.setting_2,
                      itemName: 'Settings',
                    ),
                    const MenuItem(
                      route: '/logout',
                      icon: Iconsax.logout,
                      itemName: 'Logout',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
