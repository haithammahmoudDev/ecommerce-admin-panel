import 'package:data_table_2/data_table_2.dart';
import 'package:ecommerce_admin_pannal/common/custom/custom_paginated_table.dart';
import 'package:ecommerce_admin_pannal/features/order/presentation/controller/order_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/abstraction/base_data_table/base_data_table_state.dart';
import '../../../../../../utils/device/device_utility.dart';
import '../../../../domain/entities/order_entity.dart';
import '../../../controller/order_cubit.dart';
import 'table_source.dart';

class OrderTable extends StatelessWidget {
  const OrderTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        final cubit = context.read<OrderCubit>();

        return CustomPaginatedTable(
          minWidth: 700,
          sortAscending: state.sortAscending,
          sortColumnIndex: state.sortColumnIndex,
          columns: [
            DataColumn2(
              label: const Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text('Order ID'),
              ),
              onSort: (columnIndex, ascending) =>
                  cubit.sortById(columnIndex, ascending),
            ),
            DataColumn2(
              label: const Text('Date'),
              onSort: (columnIndex, ascending) =>
                  cubit.sortByDate(columnIndex, ascending),
            ),
            const DataColumn2(label: Text('Items')),
            DataColumn2(
              label: const Text('Status'),
              fixedWidth: TDeviceUtils.isMobileScreen(context) ? 120 : null,
            ),
            DataColumn2(
              label: const Text('Amount'),
              onSort: (columnIndex, ascending) =>
                  cubit.sortByAmount(columnIndex, ascending),
            ),
            const DataColumn2(
              label: Text('Action'),
              fixedWidth: 100,
            ),
          ],
          source: OrderRows(context: context),
        );
      },
    );
  }
}