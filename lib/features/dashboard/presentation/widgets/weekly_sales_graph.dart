import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../common/widgets/icons/t_circular_icon.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import '../controller/dashboard_cubit/dashboard_cubit.dart';

class TWeeklySalesGraph extends StatelessWidget {
  const TWeeklySalesGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
         final double maxOrder = state.weeklySales.isEmpty
            ? 0
            : state.weeklySales.reduce((a, b) => a > b ? a : b);

        return RoundedContainer(
          padding: const EdgeInsets.all(Sizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Row(
                children: [
                  TCircularIcon(
                    icon: Iconsax.graph,
                    backgroundColor: Colors.brown.withOpacity(0.1),
                    color: Colors.brown,
                    size: Sizes.md,
                  ),
                  const SizedBox(width: Sizes.spaceBtwItems),
                  Text(
                    'Weekly Sales',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              const SizedBox(height: Sizes.spaceBtwSections),

               state.weeklySales.isNotEmpty
                  ? SizedBox(
                height: 400,
                child: BarChart(
                  BarChartData(
                     maxY: maxOrder > 0 ? maxOrder : 1000,
                    titlesData: buildFLTitlesData(state.weeklySales),
                    borderData: FlBorderData(
                      show: true,
                      border: const Border(
                        top: BorderSide.none,
                        right: BorderSide.none,
                      ),
                    ),
                    gridData: const FlGridData(
                      show: true,
                      drawHorizontalLine: true,
                      drawVerticalLine: true,
                      horizontalInterval: 200,
                    ),
                    barGroups: state.weeklySales
                        .asMap()
                        .entries
                        .map(
                          (entry) => BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            width: 30,
                            toY: entry.value,
                            color: TColors.primary,
                            borderRadius:
                            BorderRadius.circular(Sizes.sm),
                          ),
                        ],
                      ),
                    )
                        .toList(),
                    groupsSpace: Sizes.spaceBtwItems,
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (_) => TColors.secondary,
                      ),
                      touchCallback: TDeviceUtils.isDesktopScreen(context)
                          ? (barTouchEvent, barTouchResponse) {}
                          : null,
                    ),
                  ),
                ),
              )
                  : const SizedBox(
                height: 400,
                child: Center(
                  child: CircularProgressIndicator(color: Colors.blue),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  FlTitlesData buildFLTitlesData(List<double> weeklySales) {
    double maxOrder = weeklySales.isEmpty
        ? 0
        : weeklySales.reduce((a, b) => a > b ? a : b);
    double stepHeight = (maxOrder / 10).ceilToDouble();

    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
            final int index = value.toInt() % days.length;
            if (index < 0 || index >= days.length) {
              return const SizedBox.shrink();
            }
            return SideTitleWidget(
              meta: meta,
              space: 8,
              fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
              child: Text(days[index]),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: stepHeight <= 0 ? 200 : stepHeight,
          reservedSize: 50,
        ),
      ),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }
}