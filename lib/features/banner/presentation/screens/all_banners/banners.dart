import 'package:ecommerce_admin_pannal/features/banner/presentation/screens/all_banners/responsive_screens/banners_desktop_screen.dart';
import 'package:ecommerce_admin_pannal/features/banner/presentation/screens/all_banners/responsive_screens/banners_mobile_screen.dart';
import 'package:ecommerce_admin_pannal/features/banner/presentation/screens/all_banners/responsive_screens/banners_tablet_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/di/injection_container.dart';
import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../controller/banner_cubit.dart';

class BannersScreen extends StatelessWidget {
  const BannersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SiteTemplate(
      mobile: BannersMobileScreen(),
      desktop: BannersDesktopScreen(),
      tablet: BannersTabletScreen(),
    );
  }
}
