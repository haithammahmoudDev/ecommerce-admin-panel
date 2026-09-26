import 'package:data_table_2/data_table_2.dart';
import 'package:ecommerce_admin_pannal/features/product/presentation/controller/product_cubit.dart';
import 'package:ecommerce_admin_pannal/features/product/presentation/screens/all_products/table/table_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/abstraction/base_data_table/base_data_table_state.dart';
import '../../../../../../common/custom/custom_paginated_table.dart';
import '../../../../../../utils/device/device_utility.dart';
import '../../../../domain/entities/product_entity.dart';

class ProductsTable extends StatelessWidget {
  const ProductsTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, BaseDataTableState<ProductEntity>>(
      builder: (context, state) {
        final ProductCubit controller = context.read<ProductCubit>();

        return CustomPaginatedTable(
          minWidth: 1000,
          sortAscending: state.sortAscending,
          sortColumnIndex: state.sortColumnIndex,
          columns: [
            DataColumn2(
              label: const Text('Product'),
              fixedWidth: !TDeviceUtils.isDesktopScreen(context) ? 300 : 400,
              onSort: (columnIndex, ascending) =>
                  controller.sortByName(columnIndex, ascending),
            ),
            DataColumn2(
              label: const Text('Stock'),
              onSort: (columnIndex, ascending) =>
                  controller.sortByStock(columnIndex, ascending),
            ),
            DataColumn2(
              label: const Text('Sold'),
              onSort: (columnIndex, ascending) =>
                  controller.sortBySoldItems(columnIndex, ascending),
            ),
            const DataColumn2(label: Text('Brand')),
            DataColumn2(
              label: const Text('Price'),
              onSort: (columnIndex, ascending) =>
                  controller.sortByPrice(columnIndex, ascending),
            ),
            const DataColumn2(label: Text('Date')),
            const DataColumn2(label: Text('Action'), fixedWidth: 100),
          ],
          source: ProductsRows(context: context),
        );
      },
    );
  }
}
