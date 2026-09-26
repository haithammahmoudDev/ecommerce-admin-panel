import 'package:flutter/cupertino.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import 'esponsive_screens/products_desktop.dart';
import 'esponsive_screens/products_mobile.dart';
import 'esponsive_screens/products_tablet.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SiteTemplate(
      mobile: ProductsMobileScreen(),
      desktop:ProductsDesktopScreen(),
      tablet: ProductsTabletScreen(),
    );
  }
}
