import 'package:data_table_2/data_table_2.dart';
import 'package:ecommerce_admin_pannal/features/order/domain/entities/order_entity.dart';
import 'package:ecommerce_admin_pannal/features/order/presentation/controller/order_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/helpers/helper_functions.dart';
import '../../../../../categories/presentation/screens/all_categories/table/table_action_icon_button.dart';

class OrderRows extends DataTableSource {
  final BuildContext context;
  OrderRows({required this.context});
  late final cubit = context.read<OrderCubit>();
  @override
  DataRow? getRow(int index) {
    final orders = cubit.state.filteredItems;

    if (index >= orders.length) return null;

    final order = orders[index];
    return DataRow2(
      onTap: () => context.push('/orders/order-detail', extra: order),
      selected: cubit.state.selectedRows[index],
       onSelectChanged: (value) => cubit.toggleRowSelection(index, value),
      cells: [
        DataCell(
          // 🌟 تم استخدام Padding من جهة اليسار (left) لإبعاد نص الـ ID عن الـ Checkbox تماماً
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              order.id,
              style: Theme.of(context).textTheme.bodyLarge!.apply(color: TColors.primary),
            ),
          ),
        ),
        DataCell(Text(order.formattedOrderDate)),
        DataCell(Text('${order.items.length} Items')),
        DataCell(
          RoundedContainer(
            radius: Sizes.cardRadiusSm,
            padding: const EdgeInsets.symmetric(vertical: Sizes.sm, horizontal: Sizes.md),
            backgroundColor:
            THelperFunctions.getOrderStatusColor(order.status).withOpacity(0.1),
            child: Text(
              order.status.name.capitalize.toString(),
              style: TextStyle(color: THelperFunctions.getOrderStatusColor(order.status)),
            ),
          ),
        ),
        DataCell(Text('\$${order.totalAmount}')),
        DataCell(
          TTableActionButtons(
            view: true,
            edit: false,
            onViewPressed: () => context.push('/orders/order-detail', extra: order),
            onDeletePressed: ()=> confirmAndDeleteOrder(context: context,
                order: order, controller: cubit),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => cubit.state.filteredItems.length;

  @override
  int get selectedRowCount => cubit.state.selectedRows
      .where((selected) => selected)
      .length;
}

void confirmAndDeleteOrder({
  required BuildContext context,
  required OrderEntity order,
  required OrderCubit controller,
}) {
  showDialog(
    context: context,
    builder: (dialogContext) =>
        AlertDialog(
          title: const Text('Delete Brand'),
          content: const Text('Are you sure you want to delete this brand?'),
          actions: [
            // === Confirm ===
            SizedBox(
              width: 60,
              child: ElevatedButton(
                onPressed: () {
                  dialogContext.pop();
                  controller.deleteOnConfirm(order, context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: Sizes.buttonHeight / 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        Sizes.buttonRadius * 5),
                  ),
                ),
                child: const Text('Ok'),
              ),
            ),

            // === Cancel ===
            SizedBox(
              width: 60,
              child: OutlinedButton(
                onPressed: () => dialogContext.pop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: Sizes.buttonHeight / 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        Sizes.buttonRadius * 5),
                  ),
                ),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
  );
}
