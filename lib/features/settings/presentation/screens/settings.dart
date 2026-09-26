import 'package:ecommerce_admin_pannal/features/settings/presentation/controller/settings_cubit/settings_cubit.dart';
import 'package:ecommerce_admin_pannal/features/settings/presentation/screens/responsive_screens/settings_desktop.dart';
import 'package:ecommerce_admin_pannal/features/settings/presentation/screens/responsive_screens/settings_mobile.dart';
import 'package:ecommerce_admin_pannal/features/settings/presentation/screens/responsive_screens/settings_tablet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/di/injection_container.dart';
import '../../../../common/widgets/layouts/templates/site_layout.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SiteTemplate(
      mobile: SettingsMobileScreen(),
      desktop: SettingsDesktopScreen(),
      tablet: SettingsTabletScreen(),
    );
  }
}
