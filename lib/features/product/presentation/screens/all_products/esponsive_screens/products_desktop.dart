
import 'package:ecommerce_admin_pannal/features/product/presentation/controller/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../common/abstraction/base_data_table/base_data_table_state.dart';
import '../../../../../../common/widgets/breadcrumbs/breadcrumb.dart';
import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../brand/domain/entities/brand_entity.dart';
import '../../../../../categories/presentation/screens/all_categories/widgets/table_header.dart';
import '../../../../domain/entities/product_entity.dart';
import '../table/data-table.dart';

class ProductsDesktopScreen extends StatefulWidget {
  const ProductsDesktopScreen({super.key});

  @override
  State<ProductsDesktopScreen> createState() => _ProductsDesktopScreenState();
}

class _ProductsDesktopScreenState extends State<ProductsDesktopScreen> {
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
                heading: 'Products',
                breadcrumbItems: ['Products'],
              ), // TBreadcrumbsWithHeading
              const SizedBox(height: TSizes.spaceBtwSections),

              // Table Body
              TRoundedContainer(
                child: Column(
                  children: [
                    // Table Header
                    TableHeader(
                      buttonText: 'Add Product',
                      onPressed: () => context.push('/products/create-product'),
                      searchController: searchController,
                      searchOnChanged: (query) {
                        context.read<ProductCubit>().searchQuery(query);
                      },
                    ), // TTableHeading
                    const SizedBox(height: TSizes.spaceBtwItems),

                    // Table
                    BlocBuilder<ProductCubit, BaseDataTableState<ProductEntity>>(
                      builder: (context, state) {
                        if (state.status == DataTableStatus.loading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.blue,
                            ),
                          );
                        }
                      return const ProductsTable();
                      },
                    ),
                  ],
                ), // Column
              ), // TRoundedContainer
            ],
          ), // Column
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}
