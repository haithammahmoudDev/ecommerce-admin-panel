import 'package:ecommerce_admin_pannal/features/order/domain/entities/order_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../controller/order_detail_cubit/order_detail_cubit.dart';

class OrderCustomerInfo extends StatelessWidget {
  const OrderCustomerInfo({
    super.key,
    required this.order,
  });

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Personal Info
            RoundedContainer(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Customer', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  BlocBuilder<OrderDetailCubit, OrderDetailState>(
                  builder: (context, state) {
                    return Row(
                    children: [
                      TRoundedImage(
                        padding: 0,
                        backgroundColor: TColors.primaryBackground,
                        image: state.customer.profilePicture.isNotEmpty
                            ? state.customer.profilePicture
                            : TImages.user,
                        imageType: state.customer.profilePicture.isNotEmpty
                            ? ImageType.network
                            : ImageType.asset,
                      ),
                      const SizedBox(width: TSizes.spaceBtwItems),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.customer.fullName.isNotEmpty ? state.customer.fullName : 'N/A',
                              style: Theme.of(context).textTheme.titleLarge,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              state.customer.email.isNotEmpty ? state.customer.email : 'N/A',
                              style: Theme.of(context).textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
  },
),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // 2. Contact Info (Contact Person)
            BlocBuilder<OrderDetailCubit, OrderDetailState>(
  builder: (context, state) {
    return SizedBox(
              width: double.infinity,
              child: RoundedContainer(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Contact Person', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    Text(
                      state.customer.fullName.isNotEmpty ? state.customer.fullName : 'N/A',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),
                    Text(
                      state.customer.email.isNotEmpty ? state.customer.email : 'N/A',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),
                    Text(
                      state.customer.formattedPhoneNo.isNotEmpty
                          ? state.customer.formattedPhoneNo
                          : '(+1) *** ****',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            );
  },
),
            const SizedBox(height: TSizes.spaceBtwSections),

            // 3. Shipping Address Section
            SizedBox(
              width: double.infinity,
              child: RoundedContainer(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Shipping Address', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    Text(
                      order.shippingAddress != null ? order.shippingAddress!.name : '',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),
                    Text(
                      order.shippingAddress != null ? order.shippingAddress!.toString() : '',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // 4. Billing Address Section
            SizedBox(
              width: double.infinity,
              child: RoundedContainer(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Billing Address', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    Text(
                      order.billingAddressSameAsShipping
                          ? (order.shippingAddress?.name ?? '')
                          : (order.billingAddress?.name ?? ''),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),
                    Text(
                      order.billingAddressSameAsShipping
                          ? (order.shippingAddress?.toString() ?? '')
                          : (order.billingAddress?.toString() ?? ''),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
          ],
        );
  }
}