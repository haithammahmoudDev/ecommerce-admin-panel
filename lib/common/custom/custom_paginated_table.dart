import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

 class CustomPaginatedTable extends StatelessWidget {
  const CustomPaginatedTable({
    super.key,
    required this.columns,
    required this.source,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.rowsPerPage = 10,
    this.tableHeight = 760,
    this.dataRowHeight = 54.0,
    this.onPageChanged,
    this.onRowsPerPageChanged,
    this.onSelectAll,
    this.minWidth = 1000,
    this.emptyWidget,
  });

  final List<DataColumn2> columns;
  final DataTableSource source;
  final int? sortColumnIndex;
  final bool sortAscending;
  final int rowsPerPage;
  final double tableHeight;
  final double dataRowHeight;
  final Function(int)? onPageChanged;
  final ValueChanged<int?>? onRowsPerPageChanged;
  final ValueChanged<bool?>? onSelectAll;
  final double? minWidth;
  final Widget? emptyWidget;

  static const Color _borderColor = Color(0xFFEAECEF);
  static const Color _headerText = Color(0xFF6B7280);
  static const Color _bodyText = Color(0xFF1D2939);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: tableHeight,
      child: Theme(
        data: Theme.of(context).copyWith(
          cardTheme: const CardThemeData(
            color: Colors.transparent,
            elevation: 0,
          ),
        ),
        child: PaginatedDataTable2(
          source: source,
          columns: columns,
           columnSpacing: 16,
          minWidth: minWidth,
          dividerThickness: 1,
          horizontalMargin: 16,
          rowsPerPage: rowsPerPage,
          dataRowHeight: dataRowHeight,
          headingRowHeight: 44,

          headingTextStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: _headerText,
          ),

          headingRowColor: WidgetStateProperty.all(Colors.transparent),

          headingRowDecoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: _borderColor, width: 1),
            ),
          ),

          dataTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: _bodyText,
          ),

          border: const TableBorder(
            horizontalInside: BorderSide(color: _borderColor, width: 1),
            verticalInside: BorderSide.none,
          ),

          showCheckboxColumn: true,
          onSelectAll: onSelectAll,
          checkboxHorizontalMargin: 12,
          checkboxAlignment: Alignment.centerLeft,

          showFirstLastButtons: true,
          onPageChanged: onPageChanged,
          renderEmptyRowsInTheEnd: false,
          onRowsPerPageChanged: onRowsPerPageChanged,

          sortAscending: sortAscending,
          sortColumnIndex: sortColumnIndex,
          sortArrowAlwaysVisible: true,
          sortArrowIcon: Icons.arrow_downward_rounded,

          wrapInCard: false,

          empty: emptyWidget ??
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
        ),
      ),
    );
  }
}