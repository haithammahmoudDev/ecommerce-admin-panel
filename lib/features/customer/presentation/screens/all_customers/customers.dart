import 'package:ecommerce_admin_pannal/features/customer/presentation/controller/customer_controller.dart';
import 'package:ecommerce_admin_pannal/features/customer/presentation/screens/all_customers/responsive_screens/customers_desktop.dart';
import 'package:ecommerce_admin_pannal/features/customer/presentation/screens/all_customers/responsive_screens/customers_mobile.dart';
import 'package:ecommerce_admin_pannal/features/customer/presentation/screens/all_customers/responsive_screens/customers_tablet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/di/injection_container.dart';
import '../../../../../common/widgets/layouts/templates/site_layout.dart';

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CustomerCubit>(),
      child: SiteTemplate(
        mobile: CustomersMobileScreen(),
        desktop: CustomersDesktopScreen(),
        tablet: CustomersTabletScreen(),
      ),
    );
  }
}
