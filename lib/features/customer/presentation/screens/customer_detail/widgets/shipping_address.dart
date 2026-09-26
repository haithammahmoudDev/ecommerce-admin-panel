import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../order/domain/entities/address_entity.dart';
import '../../../controller/customer_detail_controller/customer_detail_cubit.dart';

class ShippingAddress extends StatefulWidget {
  const ShippingAddress({super.key});

  @override
  State<ShippingAddress> createState() => _ShippingAddressState();
}

class _ShippingAddressState extends State<ShippingAddress> {
  @override
  void initState() {
    super.initState();
    context.read<CustomerDetailCubit>().getCustomerAddresses(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerDetailCubit, CustomerDetailState>(
      builder: (context, state) {
        if (state.addressesLoading) {
          return const TRoundedContainer(
            padding: EdgeInsets.all(TSizes.defaultSpace),
            child: Center(child: CircularProgressIndicator(color: Colors.blue,)),
          );
        }

        final addresses = state.customer.addresses ?? [];
        final selectedAddress = addresses.firstWhere(
              (element) => element.selectedAddress,
          orElse: () => addresses.isNotEmpty ? addresses.first : AddressEntity.empty(),
        );

        return TRoundedContainer(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Address',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Name
              Row(
                children: [
                  const SizedBox(width: 120, child: Text('Name')),
                  const Text(' : '),
                  const SizedBox(width: TSizes.spaceBtwItems / 2),
                  Expanded(
                    child: Text(
                      selectedAddress.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              // Country
              Row(
                children: [
                  const SizedBox(width: 120, child: Text('Country')),
                  const Text(' : '),
                  const SizedBox(width: TSizes.spaceBtwItems / 2),
                  Expanded(
                    child: Text(
                      selectedAddress.country,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              // Phone Number
              Row(
                children: [
                  const SizedBox(width: 120, child: Text('Phone Number')),
                  const Text(' : '),
                  const SizedBox(width: TSizes.spaceBtwItems / 2),
                  Expanded(
                    child: Text(
                      selectedAddress.phoneNumber,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              // Address
              Row(
                children: [
                  const SizedBox(width: 120, child: Text('Address')),
                  const Text(' : '),
                  const SizedBox(width: TSizes.spaceBtwItems / 2),
                  Expanded(
                    child: Text(
                      selectedAddress.id.isNotEmpty ? selectedAddress.toString() : '',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}