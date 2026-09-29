import 'package:flutter/material.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../auth/domain/entities/user_entity.dart';
import '../widgets/customer_info.dart';
import '../widgets/customer_orders.dart';
import '../widgets/shipping_address.dart';


class CustomerDetailDesktopScreen extends StatelessWidget {
  const CustomerDetailDesktopScreen({super.key, required this.customer});

  final UserEntity customer;

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
                customer.fullName,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: Sizes.spaceBtwSections / 2),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        CustomerInfo(customer: customer),
                        const SizedBox(height: Sizes.spaceBtwSections),

                        const ShippingAddress(),
                      ],
                    ), //  Column
                  ), //  Expanded

                  const SizedBox(width: Sizes.spaceBtwSections),

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
