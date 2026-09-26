import 'package:ecommerce_admin_pannal/features/categories/presentation/controller/category/category_cubit.dart';
import 'package:ecommerce_admin_pannal/features/categories/presentation/screens/all_categories/responsive_screens/categories_desktop.dart';
import 'package:ecommerce_admin_pannal/features/categories/presentation/screens/all_categories/responsive_screens/categories_mobile.dart';
import 'package:ecommerce_admin_pannal/features/categories/presentation/screens/all_categories/responsive_screens/categories_tablet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/di/injection_container.dart';
import '../../../../../common/widgets/layouts/templates/site_layout.dart';


class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SiteTemplate(desktop: CategoriesDesktopScreen(),
      tablet: CategoriesTabletScreen(), mobile: CategoriesMobileScreen(),);
  }
}
