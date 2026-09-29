import 'package:ecommerce_admin_pannal/features/order/domain/entities/order_entity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/device/device_utility.dart';
import '../../../../../../utils/helpers/pricing_calculator.dart'; // تأكد من مسار حاسبة الأسعار الصحيح

class OrderItems extends StatelessWidget {
  const OrderItems({
    super.key,
    required this.order,
  });

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    final subTotal = order.items.fold(0.0,
            (previousValue, element) => previousValue + (element.price * element.quantity));

    return RoundedContainer(
      padding: const EdgeInsets.all(Sizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Items', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: Sizes.spaceBtwSections),

          // 1. القائمة المخصصة لعرض المنتجات المطلوبة
          ListView.separated(
            shrinkWrap: true,
            itemCount: order.items.length,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => const SizedBox(height: Sizes.spaceBtwItems),
            itemBuilder: (_, index) {
              final item = order.items[index];
              return Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        RoundedImage(
                          backgroundColor: TColors.primaryBackground,
                          imageType: item.image != null ? ImageType.network : ImageType.asset,
                          image: item.image ??'assets/images/profile/logo.png',
                        ), // TRoundedImage
                        const SizedBox(width: Sizes.spaceBtwItems),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: Theme.of(context).textTheme.titleMedium,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ), // Text
                              if (item.selectedVariation != null)
                                Text(item.selectedVariation!.entries.map((e) => ('${e.key} : ${e.value}')).toString()),
                            ],
                          ), // Column
                        ), // Expanded
                      ],
                    ), // Row
                  ), // Expanded
                  const SizedBox(width: Sizes.spaceBtwItems),
                  SizedBox(
                    width: Sizes.xl * 2,
                    child: Text('\$${item.price.toStringAsFixed(1)}', style: Theme.of(context).textTheme.bodyLarge),
                  ), // SizedBox
                  SizedBox(
                    width: TDeviceUtils.isMobileScreen(context) ? Sizes.xl * 1.4 : Sizes.xl * 2,
                    child: Text(item.quantity.toString(), style: Theme.of(context).textTheme.bodyLarge),
                  ), // SizedBox
                  SizedBox(
                    width: TDeviceUtils.isMobileScreen(context) ? Sizes.xl * 1.4 : Sizes.xl * 2,
                    child: Text('\$${item.totalAmount}', style: Theme.of(context).textTheme.bodyLarge),
                  ), // SizedBox
                ],
              ); // Row
            },
          ),
          const SizedBox(height: Sizes.spaceBtwSections),

          // 2. حاوية ملخص الأسعار والفواتير (Subtotal, Discount, Shipping, Tax, Total)
          RoundedContainer(
            padding: const EdgeInsets.all(Sizes.defaultSpace),
            backgroundColor: TColors.primaryBackground,
            child: Column(
              children: [
                // Subtotal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal', style: Theme.of(context).textTheme.titleLarge),
                    Text('\$$subTotal', style: Theme.of(context).textTheme.titleLarge),
                  ],
                ), // Row
                const SizedBox(height: Sizes.spaceBtwItems),

                // Discount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Discount', style: Theme.of(context).textTheme.titleLarge),
                    Text('\$0.00', style: Theme.of(context).textTheme.titleLarge),
                  ],
                ), // Row
                const SizedBox(height: Sizes.spaceBtwItems),

                // Shipping
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Shipping', style: Theme.of(context).textTheme.titleLarge),
                    Text(
                      '\$${TPricingCalculator.calculateShippingCost(subTotal, '')}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ), // Text
                  ],
                ), // Row
                const SizedBox(height: Sizes.spaceBtwItems),

                // Tax
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tax', style: Theme.of(context).textTheme.titleLarge),
                    Text(
                      '\$${TPricingCalculator.calculateTax(subTotal, '')}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ), // Text
                  ],
                ), // Row
                const SizedBox(height: Sizes.spaceBtwItems),

                const Divider(),
                const SizedBox(height: Sizes.spaceBtwItems),

                // Total Amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total', style: Theme.of(context).textTheme.titleLarge),
                    Text(
                      '\$${TPricingCalculator.calculateTotalPrice(subTotal, '')}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ), // Text
                  ],
                ), // Row
              ],
            ), // Column
          ), // TRoundedContainer
        ],
      ), // Column
    );
  }
}
