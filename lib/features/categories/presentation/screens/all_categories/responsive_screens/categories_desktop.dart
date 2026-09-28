import 'package:ecommerce_admin_pannal/features/categories/domain/entities/category_entity.dart';
import 'package:ecommerce_admin_pannal/features/categories/presentation/controller/category/category_cubit.dart';
 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../common/abstraction/base_data_table/base_data_table_state.dart';
 import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../table/table_source.dart';
import '../widgets/table_header.dart';

class CategoriesDesktopScreen extends StatefulWidget {
  const CategoriesDesktopScreen({super.key});

  @override
  State<CategoriesDesktopScreen> createState() =>
      _CategoriesDesktopScreenState();
}

class _CategoriesDesktopScreenState extends State<CategoriesDesktopScreen> {
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
    final controller = context.read<CategoryCubit>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Categories',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: TSizes.spaceBtwSections / 2),

              RoundedContainer(
                child: Column(
                  children: [
                    TableHeader(
                      buttonText: 'Create New Category',
                      onPressed: () =>
                          context.push('/categories/create-category'),
                      searchController: searchController,
                      searchOnChanged: (query) {
                        controller.searchQuery(query);
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    BlocBuilder<
                      CategoryCubit,
                      BaseDataTableState<CategoryEntity>
                    >(
                      builder: (context, state) {
                        if (state.status == DataTableStatus.loading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.blue,
                            ),
                          );
                        }
                        return const CategoryTable();
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
