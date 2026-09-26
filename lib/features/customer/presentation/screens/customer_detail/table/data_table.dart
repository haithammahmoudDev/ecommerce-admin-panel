import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/custom/custom_paginated_table.dart';
import '../../../../../../utils/device/device_utility.dart';
import '../../../controller/customer_detail_controller/customer_detail_cubit.dart';

import 'table_source.dart';

class CustomerOrderTable extends StatelessWidget {
  const CustomerOrderTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerDetailCubit, CustomerDetailState>(
      builder: (context, state) {
        return CustomPaginatedTable(
          minWidth: 550,
          tableHeight: 640,
          dataRowHeight: kMinInteractiveDimension,
          sortAscending: state.sortAscending,
          sortColumnIndex: state.sortColumnIndex,
          columns: [
            DataColumn2(
              label: const Text('Order ID'),
              onSort: (columnIndex, ascending) {
                context.read<CustomerDetailCubit>().sortById(columnIndex, ascending);
              },
            ),
            const DataColumn2(label: Text('Date')),
            const DataColumn2(label: Text('Items')),
            DataColumn2(
              label: const Text('Status'),
              fixedWidth: TDeviceUtils.isMobileScreen(context) ? 100 : null,
            ),
            const DataColumn2(label: Text('Amount'), numeric: true),
          ],
          source: CustomerOrdersRows(context: context),
        );
      },
    );
  }
}