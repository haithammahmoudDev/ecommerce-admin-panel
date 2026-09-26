import 'package:data_table_2/data_table_2.dart';
import 'package:ecommerce_admin_pannal/features/customer/presentation/controller/customer_detail_controller/customer_detail_cubit.dart';
import 'package:ecommerce_admin_pannal/features/product/presentation/controller/product_cubit.dart' show ProductCubit;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/helpers/helper_functions.dart';
import '../../../../../order/data/models/order_model.dart';

class CustomerOrdersRows extends DataTableSource {
  final BuildContext context;

  CustomerOrdersRows({
    required this.context,

  });
 late final CustomerDetailCubit controller = context.read<CustomerDetailCubit>();

  @override
  DataRow? getRow(int index) {
    final orders = controller.state.filteredCustomerOrders;

    if (index >= orders.length) return null;

    final order = orders[index];

    // حساب إجمالي المبلغ للطلب (إذا كان يحتوي على قائمة items)
    final totalAmount = order.items.isNotEmpty
        ? order.items.fold<double>(
      0.0,
          (previousValue, element) => previousValue + element.price,
    )
        : order.totalAmount;

    return DataRow2(
      selected: controller.state.selectedRows[index],
      onTap: () => context.push('/orders/order-detail', extra: order),
      cells: [
        // Order ID
        DataCell(
          Text(
            order.id,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .apply(color: TColors.primary),
          ),
        ),
        // Date
        DataCell(Text(order.formattedOrderDate)),
        // Items Count
        DataCell(Text('${order.items.length} Items')),
        // Status
        DataCell(
          TRoundedContainer(
            radius: TSizes.cardRadiusSm,
            padding: const EdgeInsets.symmetric(
              vertical: TSizes.xs,
              horizontal: TSizes.md,
            ),
            backgroundColor: THelperFunctions.getOrderStatusColor(order.status)
                .withOpacity(0.1),
            child: Text(
              order.status.name.toUpperCase(),
              style: TextStyle(
                color: THelperFunctions.getOrderStatusColor(order.status),
              ),
            ),
          ),
        ),
        // Amount
        DataCell(Text('\$${totalAmount.toStringAsFixed(2)}')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.state.filteredCustomerOrders.length;

  @override
  int get selectedRowCount => controller.state.selectedRows
      .where((selected) => selected)
      .length;
}