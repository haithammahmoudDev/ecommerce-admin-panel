import 'package:ecommerce_admin_pannal/features/brand/presentation/controller/create_brand/create_brand_cubit.dart';
import 'package:ecommerce_admin_pannal/features/brand/presentation/screens/create_brand/reponsive_screens/create_brand_desktop_screen.dart';
import 'package:ecommerce_admin_pannal/features/brand/presentation/screens/create_brand/reponsive_screens/create_brand_mobile_screen.dart';
import 'package:ecommerce_admin_pannal/features/brand/presentation/screens/create_brand/reponsive_screens/create_brand_tablet_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/di/injection_container.dart';
import '../../../../../common/widgets/layouts/templates/site_layout.dart';

class CreateBrandScreen extends StatelessWidget {
  const CreateBrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CreateBrandCubit>(),
      child: SiteTemplate(
        mobile: CreateBrandDesktopScreen(),
        desktop: CreateBrandTabletScreen(),
        tablet: CreateBrandMobileScreen(),
      ),
    );
  }
}
