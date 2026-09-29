
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/abstraction/base_data_table/base_data_table_state.dart';
 import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../categories/presentation/screens/all_categories/widgets/table_header.dart';
import '../../../../../auth/domain/entities/user_entity.dart';
import '../../../controller/customer_controller.dart';
import '../table/data_table.dart';

class CustomersDesktopScreen extends StatefulWidget {
  const CustomersDesktopScreen({super.key});

  @override
  State<CustomersDesktopScreen> createState() => _CustomersDesktopScreenState();
}

class _CustomersDesktopScreenState extends State<CustomersDesktopScreen> {
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
              Text(
                'Customers',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: Sizes.spaceBtwSections / 2),

              RoundedContainer(
                child: Column(
                  children: [
                    TableHeader(
                      showLeftWidget: false,
                      searchController: searchController,
                      searchOnChanged: (query) {
                        context.read<CustomerCubit>().searchQuery(query);
                      },
                    ),
                    const SizedBox(height: Sizes.spaceBtwItems),

                    BlocBuilder<CustomerCubit, BaseDataTableState<UserEntity>>(
                      builder: (context, state) {
                        if (state.status == DataTableStatus.loading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.blue,
                            ),
                          );
                        }
                        return const CustomerTable();
                      },
                    ),
                  ],
                ),
              ), // TRoundedContainer
            ],
          ), // Column
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}
