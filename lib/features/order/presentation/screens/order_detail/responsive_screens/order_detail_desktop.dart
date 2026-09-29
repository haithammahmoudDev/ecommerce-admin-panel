import '../../../../domain/entities/order_entity.dart';
import 'package:flutter/material.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../widgets/customer_info.dart';
import '../widgets/order_info.dart';
import '../widgets/order_items.dart';
import '../widgets/order_transaction.dart';

class OrderDetailDesktopScreen extends StatelessWidget {
  const OrderDetailDesktopScreen({super.key, required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.id,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: Sizes.spaceBtwSections / 2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        OrderInfo(order: order),
                        const SizedBox(height: Sizes.spaceBtwSections),

                        OrderItems(order: order),
                        const SizedBox(height: Sizes.spaceBtwSections),

                        OrderTransactions(order: order),
                      ],
                    ),
                  ),
                  const SizedBox(width: Sizes.spaceBtwSections),

                  Expanded(
                    child: Column(
                      children: [
                        OrderCustomerInfo(order: order,),
                        const SizedBox(height: Sizes.spaceBtwSections),
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
