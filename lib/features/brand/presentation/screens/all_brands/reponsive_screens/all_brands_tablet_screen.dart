import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../common/abstraction/base_data_table/base_data_table_state.dart';
import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../categories/presentation/screens/all_categories/widgets/table_header.dart';
import '../../../../domain/entities/brand_entity.dart';
import '../../../controller/brand_cubit.dart';
import '../table/data_table.dart';

class AllBrandsTabletScreen extends StatefulWidget {
  const AllBrandsTabletScreen({super.key});

  @override
  State<AllBrandsTabletScreen> createState() => _AllBrandsTabletScreenState();
}

class _AllBrandsTabletScreenState extends State<AllBrandsTabletScreen> {
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
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Brands', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: Sizes.spaceBtwSections / 2),

              RoundedContainer(
                child: Column(
                  children: [
                    TableHeader(
                      buttonText: 'Create New Brand',
                      onPressed: () => context.push('/brands/create-brand'),
                      searchController: searchController,
                      searchOnChanged: (query) {
                        context.read<BrandCubit>().searchQuery(query);
                      },
                    ),
                    const SizedBox(height: Sizes.spaceBtwItems),

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
                    ),
                  ],
                ), // Column
              ),
            ],
          ), // Column
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}
