import 'package:ecommerce_admin_pannal/features/order/presentation/screens/all_orders/responsive_screens/orders_desktop.dart';
import 'package:ecommerce_admin_pannal/features/order/presentation/screens/all_orders/responsive_screens/orders_mobile.dart';
import 'package:ecommerce_admin_pannal/features/order/presentation/screens/all_orders/responsive_screens/orders_tablet.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../common/widgets/layouts/templates/site_layout.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SiteTemplate(
      mobile: OrdersMobileScreen(),
      desktop:OrdersDesktopScreen(),
      tablet: OrdersTabletScreen(),
    );
  }
}
