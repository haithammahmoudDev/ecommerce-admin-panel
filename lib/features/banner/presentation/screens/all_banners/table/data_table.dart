import 'package:data_table_2/data_table_2.dart';
import 'package:ecommerce_admin_pannal/common/custom/custom_paginated_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/abstraction/base_data_table/base_data_table_state.dart';
import '../../../../domain/entities/banner_entity.dart';
import '../../../controller/banner_cubit.dart';
import 'table_source.dart';

class BannersTable extends StatelessWidget {
  const BannersTable({super.key});

  @override
  Widget build(BuildContext context) {
     return BlocBuilder<BannerCubit, BaseDataTableState<BannerEntity>>(
        builder: (context, state) {
          return CustomPaginatedTable(
            minWidth: 700,
            tableHeight: 900,
            dataRowHeight: 110,
            sortAscending: state.sortAscending,
            sortColumnIndex: state.sortColumnIndex,
            columns: const [
              DataColumn2(label: Text('Banner')),
              DataColumn2(label: Text('Redirect Screen')),
              DataColumn2(label: Text('Active')),
              DataColumn2(label: Text('Action'), fixedWidth: 100),
            ],
            source: BannersRows(context: context),
          );
        },
      ); // TPaginatedDataTable
  }
}