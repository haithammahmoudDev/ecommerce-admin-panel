import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../common/widgets/shimmers/shimmer.dart';
import '../../../../../../common/abstraction/base_data_table/base_data_table_state.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../categories/domain/entities/category_entity.dart';
import '../../../../../categories/presentation/controller/category/category_cubit.dart';
import '../../../controller/create_product/create_product_cubit.dart';

class ProductCategories extends StatelessWidget {
  const ProductCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Categories', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: Sizes.spaceBtwItems),

          BlocBuilder<CategoryCubit, BaseDataTableState<CategoryEntity>>(
            builder: (context, state) {
              if (state.status == DataTableStatus.loading && state.allItems.isEmpty) {
                return const TShimmerEffect(width: double.infinity, height: 50);
              }

              return MultiSelectDialogField<CategoryEntity>(
                buttonText: const Text("Select Categories"),
                title: const Text("Categories"),
                items: state.allItems.where((e)=> e.parentId.isNotEmpty)
                    .map((category) => MultiSelectItem<CategoryEntity>(category, category.name))
                    .toList(),
                listType: MultiSelectListType.CHIP,
                onConfirm: (values) {
                  context.read<CreateProductCubit>().setSelectedCategories(values);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}