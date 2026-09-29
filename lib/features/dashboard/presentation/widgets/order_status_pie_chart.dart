import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/widgets/custom_shapes/containers/circular_container.dart';
import '../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../controller/dashboard_cubit/dashboard_cubit.dart';

class OrderStatusPieChart extends StatelessWidget {
  const OrderStatusPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      padding: const EdgeInsets.all(Sizes.md),
      child: BlocBuilder<DashboardCubit, DashboardState>(
        buildWhen: (previous, current) =>
            !mapEquals(previous.orderStatusData, current.orderStatusData) ||
            !mapEquals(previous.totalAmounts, current.totalAmounts),
        builder: (context, state) {
          final hasData = state.orderStatusData.values.any(
            (count) => count > 0,
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Orders Status',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: Sizes.spaceBtwSections),

              SizedBox(
                height: 300,
                child: hasData
                    ? PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 50,
                          sections: state.orderStatusData.entries
                              .where((entry) => entry.value > 0)
                              .map((entry) {
                                final status = entry.key;
                                final count = entry.value;

                                return PieChartSectionData(
                                  radius: 75,
                                  title: count.toString(),
                                  value: count.toDouble(),
                                  color: THelperFunctions.getOrderStatusColor(
                                    status,
                                  ),
                                  titleStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                );
                              })
                              .toList(),
                          pieTouchData: PieTouchData(enabled: true),
                        ),
                      )
                    : const Center(child: Text('No orders data available')),
              ),
              const SizedBox(height: Sizes.spaceBtwSections),

              Center(
                child: DataTable(
                  columnSpacing: 16,
                  horizontalMargin: 8,
                  columns: const [
                    DataColumn(
                      label: Expanded(child: Center(child: Text('Status'))),
                    ),
                    DataColumn(
                      label: Expanded(child: Center(child: Text('Orders'))),
                    ),
                    DataColumn(
                      label: Expanded(child: Center(child: Text('Total'))),
                    ),
                  ],
                  rows: state.orderStatusData.entries.map((entry) {
                    final OrderStatus status = entry.key;
                    final int count = entry.value;
                    final totalAmount = state.totalAmounts[status] ?? 0.0;

                    return DataRow(
                      cells: [
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TCircularContainer(
                                width: 12,
                                height: 12,
                                backgroundColor:
                                    THelperFunctions.getOrderStatusColor(
                                      status,
                                    ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  status.name,
                                  style: const TextStyle(fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(Center(child: Text(count.toString()))),
                        DataCell(
                          Center(
                            child: Text('\$${totalAmount.toStringAsFixed(2)}'),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
