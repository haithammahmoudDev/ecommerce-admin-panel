import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../customer/presentation/screens/customer_detail/widgets/customer_info.dart';
import '../../../../domain/entities/order_entity.dart';
import '../widgets/customer_info.dart';
import '../widgets/order_info.dart';
import '../widgets/order_items.dart';
import '../widgets/order_transaction.dart';

class OrderDetailTabletScreen extends StatelessWidget {
  const OrderDetailTabletScreen({super.key, required this.order});
  final OrderEntity order;

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
                heading: order.id,
                breadcrumbItems: const ['/orders', 'Details'],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Body
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Side Order Information
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        // Order Info
                        OrderInfo(order: order),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        // Items
                        OrderItems(order: order),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        // Transactions
                        OrderTransactions(order: order),
                      ],
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwSections),

                  // Right Side Order Orders
                  Expanded(
                    child: Column(
                      children: [
                        // Customer Info
                        OrderCustomerInfo(order: order),
                        const SizedBox(height: TSizes.spaceBtwSections),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
