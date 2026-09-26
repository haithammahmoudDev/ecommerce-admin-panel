import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../utils/constants/sizes.dart';
 import 'package:ecommerce_admin_pannal/common/widgets/layouts/sidebars/cubit/sidebar_cubit.dart';

import '../../../features/media/presentation/widgets/page_heading.dart';

class TBreadcrumbsWithHeading extends StatelessWidget {
  const TBreadcrumbsWithHeading({
    super.key,
    required this.heading,
    required this.breadcrumbItems,
    this.returnToPreviousScreen = false,
  });

  final String heading;
  final List<String> breadcrumbItems;
  final bool returnToPreviousScreen;

  @override
  Widget build(BuildContext context) {
    final sidebarCubit = context.read<SidebarCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // شريط مسار التنقل الـ Breadcrumbs
        Row(
          children: [
            // رابط العودة للوحة التحكم الرئيسية Dashboard
            InkWell(
              onTap: () {
                sidebarCubit.changeActiveItem('/dashboard');
                context.goNamed('dashboard');
              },
              child: Padding(
                padding: const EdgeInsets.all(TSizes.xs),
                child: Text('Dashboard', style: Theme.of(context).textTheme.bodySmall!.apply(fontWeightDelta: -1)),
              ),
            ),

            for (int i = 0; i < breadcrumbItems.length; i++)
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text('/'),
                  ),
                  InkWell(
                    // العنصر الأخير في المسار غير قابل للضغط
                    onTap: i == breadcrumbItems.length - 1
                        ? null
                        : () {
                      sidebarCubit.changeActiveItem(breadcrumbItems[i]);
                      context.go(breadcrumbItems[i]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(TSizes.xs),
                      child: Text(
                          i == breadcrumbItems.length - 1
                              ? breadcrumbItems[i].replaceAll('/', '').capitalize.toString()
                              : capitalize(breadcrumbItems[i].replaceAll('/', '')),
                          style: Theme.of(context).textTheme.bodySmall!.apply(fontWeightDelta: -1)
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),

        const SizedBox(height: TSizes.sm),

        // العنوان الرئيسي وزر الرجوع الآمن
        Row(
          children: [
            if (returnToPreviousScreen)
              IconButton(
                onPressed: () {
                   context.pop();
                },
                icon: const Icon(Iconsax.arrow_left),
              ),
            if (returnToPreviousScreen) const SizedBox(width: TSizes.spaceBtwItems),
            TPageHeading(heading: heading),
          ],
        ),
      ],
    );
  }

  String capitalize(String s) {
    return s.isEmpty ? '' : s[0].toUpperCase() + s.substring(1);
  }
}
