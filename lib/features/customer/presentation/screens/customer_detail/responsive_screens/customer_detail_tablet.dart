import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../auth/domain/entities/user_entity.dart';
import '../widgets/customer_info.dart';
import '../widgets/customer_orders.dart';
import '../widgets/shipping_address.dart';

class CustomerDetailTabletScreen extends StatelessWidget {
  const CustomerDetailTabletScreen({super.key, required this.customer});
  final UserEntity customer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              TBreadcrumbsWithHeading(
                returnToPreviousScreen: true,
                heading: 'Taimoor Sikander',
                breadcrumbItems: ['/customers', 'Details'],
              ), // // TBreadcrumbsWithHeading
              const SizedBox(height: TSizes.spaceBtwSections),

              // Body
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Side Customer Information
                  Expanded(
                    child: Column(
                      children: [
                        // Customer Info
                        CustomerInfo(customer: customer),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        // Shipping Address
                        const ShippingAddress(),
                      ],
                    ), // // Column
                  ), // // Expanded

                  const SizedBox(width: TSizes.spaceBtwSections),

                  // Right Side Customer Orders
                  const Expanded(
                    flex: 2,
                    child: CustomerOrders(),
                  ),
                ],
              ), // // Row
            ],
          ), // // Column
        ), // // Padding
      ), // // SingleChildScrollView
    ); // // Scaffold
  }
}