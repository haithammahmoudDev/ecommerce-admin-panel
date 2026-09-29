import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/custom/custom_paginated_table.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/device/device_utility.dart';
import '../../controller/dashboard_cubit/dashboard_cubit.dart';
import 'table_source.dart';

class DashboardOrderTable extends StatelessWidget {
  const DashboardOrderTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        final cubit = context.read<DashboardCubit>();

        return CustomPaginatedTable(
          minWidth: 700,
          tableHeight: 500,
          dataRowHeight: Sizes.xl * 1.2,
          sortAscending: state.sortAscending,
          sortColumnIndex: state.sortColumnIndex,
          columns: [
            DataColumn2(
              label: const Text('Order ID'),
              onSort: (columnIndex, ascending) => cubit.sortByProperty(
                columnIndex,
                ascending,
                    (item) => item.id,
              ),
            ),
            const DataColumn2(label: Text('Date')),
            const DataColumn2(label: Text('Items')),
            DataColumn2(
              label: const Text('Status'),
              fixedWidth: TDeviceUtils.isMobileScreen(context) ? 120 : null,
            ),
            const DataColumn2(label: Text('Amount')),
          ],
          source: OrderRows(context: context,),
        );
      },
    );
  }
}