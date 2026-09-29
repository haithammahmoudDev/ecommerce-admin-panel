import 'package:ecommerce_admin_pannal/features/categories/presentation/screens/create_category/responsive_screens/create_category_desktop.dart';
import 'package:ecommerce_admin_pannal/features/categories/presentation/screens/create_category/responsive_screens/create_category_mobile.dart';
import 'package:ecommerce_admin_pannal/features/categories/presentation/screens/create_category/responsive_screens/create_category_tablet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/di/injection_container.dart';
import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../controller/create_category/create_category_cubit.dart';


class CreateCategoryScreen extends StatelessWidget {
  const CreateCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CreateCategoryCubit>(),
      child: SiteTemplate(desktop: CreateCategoryDesktopScreen(),
        tablet: CreateCategoriesTabletScreen(),
        mobile: CreateCategoryMobileScreen(),),
    );
  }
}
