import 'package:ecommerce_admin_pannal/features/brand/presentation/controller/brand_cubit.dart';
import 'package:ecommerce_admin_pannal/features/brand/presentation/screens/all_brands/reponsive_screens/all_brands_desktop_screen.dart';
import 'package:ecommerce_admin_pannal/features/brand/presentation/screens/all_brands/reponsive_screens/all_brands_mobile_screen.dart';
import 'package:ecommerce_admin_pannal/features/brand/presentation/screens/all_brands/reponsive_screens/all_brands_tablet_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/di/injection_container.dart';
import '../../../../../common/widgets/layouts/templates/site_layout.dart';

class BrandsScreen extends StatelessWidget {
  const BrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SiteTemplate(
      mobile: AllBrandsMobileScreen(),
      desktop: AllBrandsDesktopScreen(),
      tablet: AllBrandsTabletScreen(),
    );
  }
}
