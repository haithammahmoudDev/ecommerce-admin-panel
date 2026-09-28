import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/abstraction/base_data_table/base_data_table_state.dart';
import '../../../../../../common/custom/custom_paginated_table.dart';
import '../../../../../auth/domain/entities/user_entity.dart';
import '../../../controller/customer_controller.dart';
import '../table/table_source.dart';

class CustomerTable extends StatelessWidget {
  const CustomerTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerCubit, BaseDataTableState<UserEntity>>(
      builder: (context, state) {
        final cubit = context.read<CustomerCubit>();
        return CustomPaginatedTable(
          minWidth: 700,
          sortAscending: state.sortAscending,
          sortColumnIndex: state.sortColumnIndex,
          columns: [
            DataColumn2(
              label: const Text('Customer'),
              onSort: (columnIndex, ascending) =>
                  cubit.sortByName(columnIndex, ascending),
            ),
            const DataColumn2(label: Text('Email')),
            const DataColumn2(label: Text('Phone Number')),
            const DataColumn2(label: Text('Registered')),
            const DataColumn2(label: Text('Action'), fixedWidth: 100),
          ],
          source: CustomerRows(
            context: context,
          ),
        );
      },
    );
  }
}