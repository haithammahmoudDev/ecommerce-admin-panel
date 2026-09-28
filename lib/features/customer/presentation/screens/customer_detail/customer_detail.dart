import 'package:ecommerce_admin_pannal/features/customer/presentation/controller/customer_detail_controller/customer_detail_cubit.dart';
import 'package:ecommerce_admin_pannal/features/customer/presentation/screens/customer_detail/responsive_screens/customer_detail_desktop.dart';
import 'package:ecommerce_admin_pannal/features/customer/presentation/screens/customer_detail/responsive_screens/customer_detail_mobile.dart';
import 'package:ecommerce_admin_pannal/features/customer/presentation/screens/customer_detail/responsive_screens/customer_detail_tablet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/di/injection_container.dart';
import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../../../auth/domain/entities/user_entity.dart';

class CustomerDetailScreen extends StatelessWidget {
  const CustomerDetailScreen({super.key, required this.user});

  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CustomerDetailCubit>()..updateCustomer(user),
      child: SiteTemplate(
        mobile: CustomerDetailMobileScreen(customer: user,),
        desktop: CustomerDetailDesktopScreen(customer: user,),
        tablet: CustomerDetailTabletScreen(customer: user,),
      ),
    );
  }
}
