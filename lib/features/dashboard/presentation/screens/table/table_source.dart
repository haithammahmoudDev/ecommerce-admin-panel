import 'package:data_table_2/data_table_2.dart';
import 'package:ecommerce_admin_pannal/features/dashboard/presentation/controller/dashboard_cubit/dashboard_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../utils/constants/colors.dart';


class OrderRows extends DataTableSource {
  final BuildContext context;

  OrderRows({required this.context,});
  late final controller = context.read<DashboardCubit>();
  @override
  DataRow? getRow(int index) {
    if (index >= controller.state.filterdItems.length) return null;

    final order = controller.state.filterdItems[index];
    final isSelected = index < controller.state.selectedRows.length ? controller.state.selectedRows[index] : false;

    return DataRow2(
      onTap: () => context.push('/orders/order-detail', extra: order),
      selected: isSelected,
      onSelectChanged: (value) {
        context.read<DashboardCubit>().toggleRowSelection(index, value);
      },
      cells: [
        DataCell(
          Text(
            order.id,
            style: Theme.of(context).textTheme.bodyLarge!.apply(color: TColors.primary),
          ),
        ),
        DataCell(Text(order.formattedOrderDate)),
        DataCell(Text('${order.items.length} Items')),
        DataCell(
          RoundedContainer(
          ),
        ),
        DataCell(Text('\$${order.totalAmount}')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.state.filterdItems.length;

  @override
  int get selectedRowCount => controller.state.selectedRows.where((selected) => selected).length;
}