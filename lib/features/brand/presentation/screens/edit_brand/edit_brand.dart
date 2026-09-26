import 'package:ecommerce_admin_pannal/features/brand/presentation/controller/edit_brand/edit_brand_cubit.dart';
import 'package:ecommerce_admin_pannal/features/brand/presentation/screens/edit_brand/reponsive_screens/edit_brand_desktop_screen.dart';
import 'package:ecommerce_admin_pannal/features/brand/presentation/screens/edit_brand/reponsive_screens/edit_brand_mobile_screen.dart';
import 'package:ecommerce_admin_pannal/features/brand/presentation/screens/edit_brand/reponsive_screens/edit_brand_tablet_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/di/injection_container.dart';
import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../../data/models/brand_model.dart';
import '../../../domain/entities/brand_entity.dart';

class EditBrandScreen extends StatelessWidget {
  const EditBrandScreen({super.key, required this.brand});

  final BrandEntity brand;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<EditBrandCubit>()..init(brand),
      child: SiteTemplate(
        mobile: EditBrandMobileScreen(brand: brand,),
        desktop: EditBrandDesktopScreen(brand: brand,),
        tablet: EditBrandTabletScreen(brand: brand,),
      ),
    );
  }
}
