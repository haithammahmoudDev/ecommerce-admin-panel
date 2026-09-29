import 'package:ecommerce_admin_pannal/features/product/presentation/controller/create_product/create_product_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/di/injection_container.dart';
import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import 'esponsive_screens/create_product_desktop.dart';
import 'esponsive_screens/create_product_mobile.dart';
import 'esponsive_screens/create_product_tablet.dart';

class CreateProductScreen extends StatelessWidget {
  const CreateProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CreateProductCubit>(),
      child: SiteTemplate(
        mobile: CreateProductMobileScreen(),
        desktop: CreateProductDesktopScreen(),
        tablet: CreateProductTabletScreen(),
      ),
    );;
  }
}
