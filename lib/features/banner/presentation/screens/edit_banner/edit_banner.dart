import 'package:ecommerce_admin_pannal/features/banner/data/models/banner_model.dart';
import 'package:ecommerce_admin_pannal/features/banner/presentation/controller/edit_banner/edit_banner_cubit.dart';
import 'package:ecommerce_admin_pannal/features/banner/presentation/screens/edit_banner/reponsive_screens/edit_banner_desktop_screen.dart';
import 'package:ecommerce_admin_pannal/features/banner/presentation/screens/edit_banner/reponsive_screens/edit_banner_mobile_screen.dart';
import 'package:ecommerce_admin_pannal/features/banner/presentation/screens/edit_banner/reponsive_screens/edit_banner_tablet_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/di/injection_container.dart';
import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../../domain/entities/banner_entity.dart';
import '../create_banner/responsive_screens/create_banner_mobile_screen.dart';

class EditBannerScreen extends StatelessWidget {
  const EditBannerScreen({super.key, required this.banner});

  final BannerEntity banner;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<EditBannerCubit>()..init(banner),
      child: SiteTemplate(
        mobile: EditBannerMobileScreen(banner: banner,),
        desktop: EditBannerDesktopScreen(banner: banner,),
        tablet: EditBannerTabletScreen(banner: banner,),
      ),
    );
  }
}
