import 'package:ecommerce_admin_pannal/features/profile/presentation/screens/responsive_screens/profile_desktop.dart';
import 'package:ecommerce_admin_pannal/features/profile/presentation/screens/responsive_screens/profile_mobile.dart';
import 'package:ecommerce_admin_pannal/features/profile/presentation/screens/responsive_screens/profile_tablet.dart';
import 'package:flutter/cupertino.dart';
import '../../../../common/widgets/layouts/templates/site_layout.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SiteTemplate(
      mobile: ProfileMobileScreen(),
      desktop:ProfileDesktopScreen(),
      tablet: ProfileTabletScreen(),
    );
  }
}
