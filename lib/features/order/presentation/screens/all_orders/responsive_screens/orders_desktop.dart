import 'package:ecommerce_admin_pannal/features/order/presentation/controller/order_cubit.dart';
import 'package:ecommerce_admin_pannal/features/order/presentation/controller/order_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/abstraction/base_data_table/base_data_table_state.dart';
import '../../../../../../common/widgets/breadcrumbs/breadcrumb.dart';
import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../categories/presentation/screens/all_categories/widgets/table_header.dart';
import '../../../../../product/domain/entities/product_entity.dart';
import '../../../../domain/entities/order_entity.dart';

import 'package:flutter/material.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../table/data_table.dart';

class OrdersDesktopScreen extends StatefulWidget {
  const OrdersDesktopScreen({super.key,});

  @override
  State<OrdersDesktopScreen> createState() => _OrdersDesktopScreenState();
}

class _OrdersDesktopScreenState extends State<OrdersDesktopScreen> {
  late final TextEditingController searchController;
  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              const TBreadcrumbsWithHeading(
                heading: 'Orders',
                breadcrumbItems: ['Orders'],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Table Body
              RoundedContainer(
                child: Column(
                  children: [
                    // Table Header
                    TableHeader(
                      showLeftWidget: false,
                      searchController: searchController,
                      searchOnChanged: (query) {
                        context.read<OrderCubit>().searchQuery(query);
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    // Table
                    BlocBuilder<OrderCubit, OrderState>(
                      builder: (context, state) {
                        if (state.status == OrderStatusEnum.loading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.blue,
                            ),
                          );
                        }
                        return const OrderTable();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

