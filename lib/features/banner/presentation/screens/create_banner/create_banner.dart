import 'package:ecommerce_admin_pannal/features/banner/presentation/controller/create_banner/create_banner_cubit.dart';
import 'package:ecommerce_admin_pannal/features/banner/presentation/screens/create_banner/responsive_screens/create_banner_desktop_screen.dart';
import 'package:ecommerce_admin_pannal/features/banner/presentation/screens/create_banner/responsive_screens/create_banner_mobile_screen.dart';
import 'package:ecommerce_admin_pannal/features/banner/presentation/screens/create_banner/responsive_screens/create_banner_tablet_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/di/injection_container.dart';
import '../../../../../common/widgets/layouts/templates/site_layout.dart';

class CreateBannerScreen extends StatelessWidget {
  const CreateBannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CreateBannerCubit>(),
      child: SiteTemplate(
        mobile: CreateBannerMobileScreen(),
        desktop: CreateBannerDesktopScreen(),
        tablet: CreateBannerTabletScreen(),
      ),
    );
  }
}
