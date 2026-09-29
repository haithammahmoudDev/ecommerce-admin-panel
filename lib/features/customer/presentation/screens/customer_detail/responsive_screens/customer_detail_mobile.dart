import 'package:flutter/material.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../auth/domain/entities/user_entity.dart';
import '../widgets/customer_info.dart';
import '../widgets/customer_orders.dart';
import '../widgets/shipping_address.dart';


class CustomerDetailMobileScreen extends StatelessWidget {
  const CustomerDetailMobileScreen({super.key, required this.customer});

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

              CustomerInfo(customer: customer),
              const SizedBox(height: Sizes.spaceBtwSections),

              const ShippingAddress(),
              const SizedBox(height: Sizes.spaceBtwSections),

              const CustomerOrders(),
            ],
          ), // // Column
        ), // // Padding
      ), // // SingleChildScrollView
    ); // // Scaffold
  }
}
