import 'package:ecommerce_admin_pannal/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../features/categories/presentation/screens/create_category/widgets/image_uploader.dart';
import '../../../../features/product/presentation/screens/edit_product/widgets/thumbnail_widget.dart';
import '../../../../features/settings/presentation/controller/settings_cubit/settings_cubit.dart';
import '../../../../utils/constants/sizes.dart';
import '../../images/t_circular_image.dart';
import 'menu/menu_item.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    // تم تنظيف الدالة بالكامل من الـ Callbacks لمنع تعليق اللون والضغط المزدوج
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
                  const SizedBox(width: 10,),
                  // 1. قسم الشعار الدائري بحجم كبير وواضح (High Size)
                  BlocSelector<SettingsCubit, SettingsState, ({String appLogo, bool isLoading})>(
                    selector: (state) => (
                    appLogo: state.settings.appLogo,
                    isLoading: state.isLogoLoading,
                    ),
                    builder: (context, logoData) {
                      // حجم كبير متناسق مع الشيمر
                      if (logoData.isLoading || logoData.appLogo.isEmpty) {
                        return const TShimmerEffect(
                          width: 60, // تم التكبير من 40 إلى 60 لبروز أعلى
                          height: 60,
                          radius: 60,
                        );
                      }

                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).cardColor,
                          // ظل ناعم وواضح ليعطي عمقاً فخماً للحجم الكبير
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.network(
                            logoData.appLogo,
                            fit: BoxFit.cover, // يضمن عدم تمطط الشعار مع الحجم الكبير
                            errorBuilder: (context, error, stackTrace) => const Icon(
                              Icons.business,
                              size: 30, // تكبير الأيقونة البديلة في حال الخطأ
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 16), // زيادة المسافة لتتناسب بامتياز مع الحجم الكبير الجديد

                  // 2. قسم اسم التطبيق بخط عريض وبارز (Headline Style)
                  Expanded(
                    child: BlocSelector<SettingsCubit, SettingsState, String>(
                      selector: (state) => state.settings.appName,
                      builder: (context, appName) {
                        if (appName.isEmpty) {
                          return const TShimmerEffect(
                            width: 110, // زيادة العرض ليتناسب مع الخط الكبير
                            height: 20,
                            radius: 4,
                          );
                        }

                        return Text(
                          appName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold, // خط عريض وواضح جداً للـ Dashboard
                            color: Colors.black87,
                            letterSpacing: 0.8,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),


              const SizedBox(height: TSizes.spaceBtwSections),

              Padding(
                padding: const EdgeInsets.all(TSizes.md / 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'MENU',
                      style: Theme.of(context).textTheme.bodySmall!.apply(letterSpacingDelta: 1.2),
                    ),
                    const MenuItem(route: '/dashboard', icon: Iconsax.status, itemName: 'Dashboard'),
                    const MenuItem(route: '/media', icon: Iconsax.image, itemName: 'Media'),
                    const MenuItem(route: '/categories', icon: Iconsax.category_2, itemName: 'Categories'),
                    const MenuItem(route: '/brands', icon: Iconsax.dcube, itemName: 'Brands'),
                    const MenuItem(route: '/banners', icon: Iconsax.picture_frame, itemName: 'Banners'),
                    const MenuItem(route: '/products', icon: Iconsax.shopping_bag, itemName: 'Products'),
                    const MenuItem(route: '/customers', icon: Iconsax.profile_2user, itemName: 'Customers'),
                    const MenuItem(route: '/orders', icon: Iconsax.box, itemName: 'Orders'),
                    Text('OTHER', style: Theme.of(context).textTheme.bodySmall!.apply(letterSpacingDelta: 1.2)),
                    const MenuItem(route: '/profile', icon: Iconsax.user, itemName: 'Profile'),
                    const MenuItem(route: '/settings', icon: Iconsax.setting_2, itemName: 'Settings'),
                    const MenuItem(route: '/logout', icon: Iconsax.logout, itemName: 'Logout'),
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
