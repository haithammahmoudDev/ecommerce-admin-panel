import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../common/abstraction/base_data_table/base_data_table_state.dart';
import '../../../../../../common/widgets/breadcrumbs/breadcrumb.dart';
import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../categories/presentation/screens/all_categories/widgets/table_header.dart';
import '../../../../domain/entities/brand_entity.dart';
import '../../../controller/brand_cubit.dart';
import '../table/data_table.dart';

class AllBrandsMobileScreen extends StatefulWidget {
  const AllBrandsMobileScreen({super.key});

  @override
  State<AllBrandsMobileScreen> createState() => _AllBrandsMobileScreenState();
}

class _AllBrandsMobileScreenState extends State<AllBrandsMobileScreen> {
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
              const TBreadcrumbsWithHeading(heading: 'Brands', breadcrumbItems: ['Brands']),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Table Body
              RoundedContainer(
                child: Column(
                  children: [
                    // Table Header
                    TableHeader(buttonText: 'Create New Brand',
                      onPressed: () => context.push('/brands/create-brand'),
                      searchController: searchController,
                      searchOnChanged: (query) {
                        context.read<BrandCubit>().searchQuery(query);
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    // Table
                    BlocBuilder<BrandCubit, BaseDataTableState<BrandEntity>>(
                      builder: (context, state) {
                        if (state.status == DataTableStatus.loading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.blue,
                            ),
                          );
                        }
                        return BrandTable();
                      },
                    ),                  ],
                ), // Column
              ), // TRoundedContainer
            ],
          ), // Column
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}

