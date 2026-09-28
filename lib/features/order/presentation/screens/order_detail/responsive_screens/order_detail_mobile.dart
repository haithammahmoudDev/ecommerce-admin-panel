import 'package:flutter/material.dart';
 import '../../../../../../utils/constants/sizes.dart';
import '../../../../domain/entities/order_entity.dart';
import '../widgets/customer_info.dart';
import '../widgets/order_info.dart';
import '../widgets/order_items.dart';
import '../widgets/order_transaction.dart';

class OrderDetailMobileScreen extends StatelessWidget {
  const OrderDetailMobileScreen({super.key, required this.order});

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
              Text(
                order.id,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: TSizes.spaceBtwSections / 2),

              Column(
                children: [
                  // Order Info Card
                  OrderInfo(order: order),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // Ordered Items List Card
                  OrderItems(order: order),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // Financial Transactions Card
                  OrderTransactions(order: order),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // Customer Contact & Addresses Card
                  OrderCustomerInfo(order: order),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
