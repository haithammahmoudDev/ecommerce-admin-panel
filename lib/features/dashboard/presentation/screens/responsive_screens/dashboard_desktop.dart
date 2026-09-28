import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../controller/dashboard_cubit/dashboard_cubit.dart';
import '../../widgets/dashboard_card.dart';
import '../../widgets/order_status_pie_chart.dart';
import '../../widgets/weekly_sales_graph.dart';
import '../table/data_table.dart';

class DashboardDesktopScreen extends StatelessWidget {
  const DashboardDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Dashboard',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Summary KPI Cards Row
              Row(
                children: [
                  // 1. Sales Total Card
                  Expanded(
                    child: TDashboardCard(
                      headingIcon: Iconsax.note,
                      headingIconColor: Colors.blue,
                      headingIconBgColor: Colors.blue.withOpacity(0.1),
                      stats: state.salesStats.toInt(),
                      title: 'Sales total',
                      subTitle: '\$${state.totalSales.toStringAsFixed(2)}',
                      icon: state.salesStats < 0 ? Iconsax.arrow_down : Iconsax.arrow_up,
                      color: state.salesStats < 0 ? TColors.error : TColors.success,
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),

                  // 2. Average Order Value Card
                  Expanded(
                    child: TDashboardCard(
                      headingIcon: Iconsax.external_drive,
                      headingIconColor: Colors.green,
                      headingIconBgColor: Colors.green.withOpacity(0.1),
                      stats: state.avgOrderStats.toInt(),
                      title: 'Average Order Value',
                      subTitle: '\$${state.averageOrderValue.toStringAsFixed(2)}',
                      icon: state.avgOrderStats < 0 ? Iconsax.arrow_down : Iconsax.arrow_up,
                      color: state.avgOrderStats < 0 ? TColors.error : TColors.success,
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),

                  // 3. Total Orders Card
                  Expanded(
                    child: TDashboardCard(
                      headingIcon: Iconsax.box,
                      headingIconColor: Colors.deepPurple,
                      headingIconBgColor: Colors.deepPurple.withOpacity(0.1),
                      stats: state.ordersStats.toInt(),
                      title: 'Total Orders',
                      subTitle: '${state.totalOrders}',
                      icon: state.ordersStats < 0 ? Iconsax.arrow_down : Iconsax.arrow_up,
                      color: state.ordersStats < 0 ? TColors.error : TColors.success,
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),

                  // 4. Visitors / Customers Card
                  Expanded(
                    child: TDashboardCard(
                      headingIcon: Iconsax.user,
                      headingIconColor: Colors.deepOrange,
                      headingIconBgColor: Colors.deepOrange.withOpacity(0.1),
                      stats: state.customersStats.toInt(),
                      title: 'Visitors',
                      subTitle: '${state.totalCustomers}',
                      icon: state.customersStats < 0 ? Iconsax.arrow_down : Iconsax.arrow_up,
                      color: state.customersStats < 0 ? TColors.error : TColors.success,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Main Content Layout (Graphs & Table)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Side: Weekly Sales & Recent Orders Table
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        const TWeeklySalesGraph(),
                        const SizedBox(height: TSizes.spaceBtwSections),
                        RoundedContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recent Orders',
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: TSizes.spaceBtwSections),
                              const DashboardOrderTable(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwSections),

                  // Right Side: Order Status Pie Chart
                  const Expanded(
                    flex: 1,
                    child: OrderStatusPieChart(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}