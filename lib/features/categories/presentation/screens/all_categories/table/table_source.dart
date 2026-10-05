import 'package:data_table_2/data_table_2.dart';
import 'package:ecommerce_admin_pannal/common/custom/custom_paginated_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/abstraction/base_data_table/base_data_table_state.dart';
import '../../../../domain/entities/category_entity.dart';
import '../../../controller/category/category_cubit.dart';
import 'data_table.dart';

class CategoryTable extends StatelessWidget {
  const CategoryTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, BaseDataTableState<CategoryEntity>>(
      builder: (context, state) {
        final cubit = context.read<CategoryCubit>();

        return CustomPaginatedTable(
          sortColumnIndex: state.sortColumnIndex,
          sortAscending: state.sortAscending,
          minWidth: 700,
          columns: [
            DataColumn2(
              label: const Text('Category'),
              onSort: (columnIndex, ascending) {
                cubit.sortByName(columnIndex, ascending);
              },
            ),
            DataColumn2(
              label: const Text('Parent Category'),
              onSort: (columnIndex, ascending) {
                cubit.sortByParentName(columnIndex, ascending);
              },
            ),
            const DataColumn2(label: Text('Featured')),
            const DataColumn2(label: Text('Date')),
            const DataColumn2(label: Text('Action'), fixedWidth: 100),
          ],
          source: CategoryRows(context),
        );
      },
    );
  }
}