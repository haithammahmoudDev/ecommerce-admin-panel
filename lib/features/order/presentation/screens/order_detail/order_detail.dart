import 'package:ecommerce_admin_pannal/features/order/presentation/controller/order_detail_cubit/order_detail_cubit.dart';
import 'package:ecommerce_admin_pannal/features/order/presentation/screens/order_detail/responsive_screens/order_detail_desktop.dart';
import 'package:ecommerce_admin_pannal/features/order/presentation/screens/order_detail/responsive_screens/order_detail_mobile.dart';
import 'package:ecommerce_admin_pannal/features/order/presentation/screens/order_detail/responsive_screens/order_detail_tablet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/di/injection_container.dart';
import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../../domain/entities/order_entity.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key, required this.order});

  final OrderEntity order;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OrderDetailCubit>()..updateOrder(order)..getCustomerOfCurrentOrder(context),
      child: SiteTemplate(
        mobile: OrderDetailMobileScreen(order: order),
        desktop: OrderDetailDesktopScreen(order: order,),
        tablet: OrderDetailTabletScreen(order: order),
      ),
    );
  }
}
