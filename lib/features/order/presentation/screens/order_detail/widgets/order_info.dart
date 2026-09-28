import 'package:ecommerce_admin_pannal/features/order/domain/entities/order_entity.dart';
import 'package:ecommerce_admin_pannal/features/order/presentation/controller/order_cubit.dart';
import 'package:ecommerce_admin_pannal/features/order/presentation/controller/order_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

 import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/device/device_utility.dart';
import '../../../../../../utils/helpers/helper_functions.dart';

class OrderInfo extends StatelessWidget {
  const OrderInfo({super.key, required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OrderCubit>();
    cubit.selectOrderStatus(order.status);
    return RoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Information', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: TSizes.spaceBtwSections),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Date Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Date'),
                    Text(order.formattedOrderDate, style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ), // Column
              ), // Expanded

              // 2. Items Count Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Items'),  //order.items.length
                    Text('${order.items.length} Items', style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ), // Column
              ), // Expanded

              // 3. Status Dropdown Column
              Expanded(
                flex: TDeviceUtils.isMobileScreen(context) ? 2 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Status'),
                    BlocBuilder<OrderCubit, OrderState>(
                   builder: (context, state) {
                     if (state.status == OrderStatusEnum.loading) {
                       return const Center(
                         child: CircularProgressIndicator(
                           color: Colors.blue,
                         ),
                       );
                     }
                  return RoundedContainer(
                      radius: TSizes.cardRadiusSm,
                      padding: const EdgeInsets.symmetric(horizontal: TSizes.sm, vertical: 0),
                      backgroundColor: THelperFunctions.
                      getOrderStatusColor(state.selectedOrderStatus).withOpacity(0.1),
                      child: DropdownButton<OrderStatus>(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        value: state.selectedOrderStatus,
                        onChanged: (OrderStatus? newValue){
                          if(newValue == null) return;
                          cubit.updateOrderStatus(order, newValue);
                        },
                        items: OrderStatus.values.map((OrderStatus status) {
                          return DropdownMenuItem<OrderStatus>(
                            value: status,
                            child: Text(
                              status.name.capitalize.toString(),
                              style: TextStyle(color: THelperFunctions.
                              getOrderStatusColor(state.selectedOrderStatus)),
                            ), // Text
                          ); // DropdownMenuItem
                        }).toList(),
                      ), // DropdownButton
                    );
  },
), // TRoundedContainer
                  ],
                ), // Column
              ), // Expanded

              // 4. Total Amount Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total'),
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
