import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../controller/customer_detail_controller/customer_detail_cubit.dart';
import '../table/data_table.dart';

class CustomerOrders extends StatefulWidget {
  const CustomerOrders({super.key});

  @override
  State<CustomerOrders> createState() => _CustomerOrdersState();
}

class _CustomerOrdersState extends State<CustomerOrders> {
  @override
  void initState() {
    super.initState();
    context.read<CustomerDetailCubit>().getCustomerOrders(context);
  }

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      padding: const EdgeInsets.all(Sizes.defaultSpace),
      child: BlocBuilder<CustomerDetailCubit, CustomerDetailState>(
        builder: (context, state) {
          if (state.ordersLoading) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(Sizes.defaultSpace),
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state.allCustomerOrders.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(Sizes.defaultSpace),
                child: Text(
                  'No Orders Found',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            );
          }

          final totalAmount = state.allCustomerOrders.fold<double>(
            0.0,
            (previousValue, element) => previousValue + element.totalAmount,
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Orders',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: 'Total Spent '),
                        TextSpan(
                          text: '\$${totalAmount.toStringAsFixed(2)}',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge!.apply(color: TColors.primary),
                        ),
                        TextSpan(
                          text: ' on ${state.allCustomerOrders.length} Orders',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Sizes.spaceBtwItems),
              TextFormField(
                onChanged: (query) =>
                    context.read<CustomerDetailCubit>().searchQuery(query),
                decoration: const InputDecoration(
                  hintText: 'Search Orders',
                  prefixIcon: Icon(Iconsax.search_normal),
                ),
              ),
              const SizedBox(height: Sizes.spaceBtwSections),
              const CustomerOrderTable(),
            ],
          );
        },
      ),
    );
  }
}
