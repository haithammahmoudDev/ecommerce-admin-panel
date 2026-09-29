import 'package:ecommerce_admin_pannal/common/widgets/layouts/templates/site_layout.dart';
import 'package:ecommerce_admin_pannal/features/dashboard/presentation/screens/responsive_screens/dashboard_desktop.dart';
import 'package:ecommerce_admin_pannal/features/dashboard/presentation/screens/responsive_screens/dashboard_mobile.dart';
import 'package:ecommerce_admin_pannal/features/dashboard/presentation/screens/responsive_screens/dashboard_tablet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/di/injection_container.dart';
import '../controller/dashboard_cubit/dashboard_cubit.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const routeName = 'dashboard';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DashboardCubit>(),
      child: const SiteTemplate(
        mobile: DashboardMobileScreen(),
        desktop: DashboardDesktopScreen(),
        tablet: DashboardTabletScreen(),
      ),
    );
  }
}