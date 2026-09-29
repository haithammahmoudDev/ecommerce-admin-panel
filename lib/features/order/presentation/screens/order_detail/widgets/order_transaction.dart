import 'package:ecommerce_admin_pannal/features/order/domain/entities/order_entity.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/device/device_utility.dart';

class OrderTransactions extends StatelessWidget {
  const OrderTransactions({
    super.key,
    required this.order,
  });

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      padding: const EdgeInsets.all(Sizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Transactions', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: Sizes.spaceBtwSections),

          // Adjust as per your needs
          Row(
            children: [
              Expanded(
                flex: TDeviceUtils.isMobileScreen(context) ? 2 : 1,
                child: Row(
                  children: [
                    TRoundedImage(imageType: ImageType.asset, image: TImages.paypal),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment via ${order.paymentMethod.capitalize}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ), // Text
                          // Adjust your Payment Method Fee if any
                          Text(
                            '${order.paymentMethod.capitalize} Fee \$25',
                            style: Theme.of(context).textTheme.labelMedium,
                          ), // Text
                        ],
                      ), // Column
                    ), // Expanded
                  ],
                ), // Row
              ), // Expanded

              // Date Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date', style: Theme.of(context).textTheme.labelMedium),
                    Text('April 21, 2025', style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ), // Column
              ), // Expanded

              // Total Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total', style: Theme.of(context).textTheme.labelMedium),
                    Text('\$${order.totalAmount}', style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ), // Column
              ), // Expanded
            ],
          ), // Row
        ],
      ), // Column
    );
  }
}
