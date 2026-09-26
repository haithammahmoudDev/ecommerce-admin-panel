import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../common/abstraction/base_data_table/base_data_table_state.dart';
import '../../../../../../utils/device/device_utility.dart';
import '../../../../domain/entities/brand_entity.dart';
import '../../../controller/brand_cubit.dart';
import 'table_source.dart';

enum _ScreenType { mobile, tablet, desktop }

class BrandTable extends StatelessWidget {
  const BrandTable({super.key});

  _ScreenType _getScreenType(BuildContext context) {
    if (TDeviceUtils.isMobileScreen(context)) return _ScreenType.mobile;
    if (TDeviceUtils.isTabletScreen(context)) return _ScreenType.tablet;
    return _ScreenType.desktop;
  }

  @override
  Widget build(BuildContext context) {
    final screenType = _getScreenType(context);

    final double rowHeight = switch (screenType) {
      _ScreenType.mobile => 190,
      _ScreenType.tablet => 96,
      _ScreenType.desktop => 90,
    };

    final double minWidth = switch (screenType) {
      _ScreenType.mobile => 360,
      _ScreenType.tablet => 600,
      _ScreenType.desktop => 700,
    };

    final double? brandColWidth = switch (screenType) {
      _ScreenType.mobile => null,
      _ScreenType.tablet => 160,
      _ScreenType.desktop => 220,
    };

    final double? narrowColWidth = switch (screenType) {
      _ScreenType.mobile => null,
      _ScreenType.tablet => 80,
      _ScreenType.desktop => 100,
    };

    final double? dateColWidth = switch (screenType) {
      _ScreenType.mobile => null,
      _ScreenType.tablet => 110,
      _ScreenType.desktop => 150,
    };

    final double columnSpacing = switch (screenType) {
      _ScreenType.mobile => 4,
      _ScreenType.tablet => 8,
      _ScreenType.desktop => 12,
    };

    // FIX: previously BrandRows(context) was created with no real data —
    // every row showed the same hardcoded "Adidas" placeholder. Now we
    // read the live, filtered brand list straight from BrandCubit, so the
    // table reacts to fetch/search/sort just like it should.
    return BlocBuilder<BrandCubit, BaseDataTableState<BrandEntity>>(
      builder: (context, state) {
        final brands = state.filterdItems;

        // NEW: mirrors the video's `lgTable` check — if any visible brand
        // has more than 2 categories, rows need extra height so the chips
        // don't get clipped/overflow. Combined with our screen-type sizing
        // instead of replacing it, since the video's version didn't
        // account for mobile/tablet layouts at all.
        final bool hasLongCategoryLists = brands.any(
              (brand) => (brand.brandCategories?.length ?? 0) > 2,
        );
        final double adjustedRowHeight =
        hasLongCategoryLists ? rowHeight + 24 : rowHeight;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: double.infinity,
            height: 600,
            child: Theme(
              data: Theme.of(context).copyWith(
                cardColor: Colors.white,
                dividerColor: Colors.grey.shade100,
              ),
              child: PaginatedDataTable2(
                minWidth: minWidth,
                fit: FlexFit.tight,
                wrapInCard: false,
                isHorizontalScrollBarVisible: true,
                headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
                headingRowHeight: 52,
                headingTextStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.grey.shade700,
                  letterSpacing: 0.2,
                ),
                 renderEmptyRowsInTheEnd: false,
                 headingRowDecoration: BoxDecoration(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
                  color: Colors.grey.shade50,
                ),
                empty:
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 48),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.search_status,
                            size: 40,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No results found!',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Try adjusting your search or filters.',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                dataRowHeight: adjustedRowHeight,
                dividerThickness: 0.6,
                horizontalMargin: 8,
                columnSpacing: columnSpacing,
                // NEW: wires up sorting to BrandCubit's state + sortByName,
                // matching `sortAscending: controller.sortAscending.value` /
                // `sortColumnIndex: controller.sortColumnIndex.value` from
                // the video, translated to Bloc's `state.sortAscending` /
                // `state.sortColumnIndex`.
                sortAscending: state.sortAscending,
                sortColumnIndex: state.sortColumnIndex,
                columns: [
                  DataColumn2(
                    label: const Text('Brand'),
                    size: ColumnSize.L,
                    fixedWidth: brandColWidth,
                    // NEW: previously the Brand column had no onSort at
                    // all — clicking the header did nothing. Now it calls
                    // BrandCubit.sortByName, which re-emits a sorted state.
                    onSort: (columnIndex, ascending) => context
                        .read<BrandCubit>()
                        .sortByName(columnIndex, ascending),
                  ),
                  const DataColumn2(
                    label: Text('Categories'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: const Text('Featured'),
                    fixedWidth: narrowColWidth,
                  ),
                  DataColumn2(
                    label: const Text('Date'),
                    fixedWidth: dateColWidth,
                  ),
                  DataColumn2(
                    label: const Text('Action'),
                    fixedWidth: narrowColWidth,
                  ),
                ],
                source: BrandRows(
                  context,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}