import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../common/abstraction/base_data_table/base_data_table_state.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../categories/domain/entities/category_entity.dart';
import '../../../../../categories/presentation/controller/category/category_cubit.dart';
import '../../../../../product/domain/entities/product_entity.dart';
import '../../../../../product/presentation/controller/product_cubit.dart';

class DestinationPickerDialog extends StatelessWidget {
  final String type;
  final Function(String id, String name) onSelected;
  const DestinationPickerDialog({
    super.key,
    required this.type,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bool isProduct = type.toLowerCase() == 'product';

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
      ),
      title: Row(
        children: [
          Icon(
            isProduct ? Iconsax.box : Iconsax.category,
            color: TColors.primary,
          ),
          const SizedBox(width: Sizes.spaceBtwItems / 2),
          Text('Select ${isProduct ? 'Product' : 'Category'}'),
        ],
      ),
      content: SizedBox(
        width: 480,
        height: 480,
        child: isProduct
            ? _buildProductPicker(context)
            : _buildCategoryPicker(context),
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Widget _buildProductPicker(BuildContext context) {
    final productCubit = context.read<ProductCubit>();
    if (productCubit.state.allItems.isEmpty &&
        productCubit.state.status != DataTableStatus.loading) {
      productCubit.fetchData();
    }

    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'Search Products...',
            prefixIcon: const Icon(Iconsax.search_normal),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Sizes.borderRadiusMd),
            ),
          ),
          onChanged: (query) => productCubit.searchQuery(query),
        ),
        const SizedBox(height: Sizes.spaceBtwItems),
        Expanded(
          child: BlocBuilder<ProductCubit, BaseDataTableState<ProductEntity>>(
            builder: (context, state) {
              if (state.status == DataTableStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.filterdItems.isEmpty) {
                return _buildEmptyState(context, 'No products found');
              }

              return ListView.separated(
                itemCount: state.filterdItems.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final product = state.filterdItems[index];
                  return ListTile(
                    leading: product.thumbnail.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(
                              Sizes.borderRadiusSm,
                            ),
                            child: Image.network(
                              product.thumbnail,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Iconsax.image),
                            ),
                          )
                        : const CircleAvatar(
                            backgroundColor: TColors.primaryBackground,
                            child: Icon(
                              Iconsax.image,
                              size: 20,
                              color: TColors.primary,
                            ),
                          ),
                    title: Text(
                      product.title,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    subtitle: Text(
                      '\$${product.price}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    onTap: () {
                      onSelected(product.id, product.title);
                      Navigator.pop(context);
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryPicker(BuildContext context) {
    final categoryCubit = context.read<CategoryCubit>();
    if (categoryCubit.state.allItems.isEmpty &&
        categoryCubit.state.status != DataTableStatus.loading) {
      categoryCubit.fetchData();
    }

    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'Search Categories...',
            prefixIcon: const Icon(Iconsax.search_normal),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Sizes.borderRadiusMd),
            ),
          ),
          onChanged: (query) => categoryCubit.searchQuery(query),
        ),
        const SizedBox(height: Sizes.spaceBtwItems),
        Expanded(
          child: BlocBuilder<CategoryCubit, BaseDataTableState<CategoryEntity>>(
            builder: (context, state) {
              if (state.status == DataTableStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              final filteredSubCategories = state.filterdItems
                  .where((category) => category.parentId.isNotEmpty)
                  .toList();

              if (filteredSubCategories.isEmpty) {
                return _buildEmptyState(context, 'No subcategories found');
              }

              return ListView.separated(
                itemCount: filteredSubCategories.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final category = filteredSubCategories[index];

                  return ListTile(
                    leading: category.image.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(
                              Sizes.borderRadiusSm,
                            ),
                            child: Image.network(
                              category.image,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Iconsax.image),
                            ),
                          )
                        : const CircleAvatar(
                            backgroundColor: TColors.primaryBackground,
                            child: Icon(
                              Iconsax.image,
                              size: 20,
                              color: TColors.primary,
                            ),
                          ),
                    title: Text(
                      category.name,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    subtitle: Text(
                      'Parent ID: ${category.parentId}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    onTap: () {
                      onSelected(category.parentId, category.name);
                      Navigator.pop(context);
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Iconsax.folder_open, size: 48, color: Colors.grey),
          const SizedBox(height: Sizes.spaceBtwItems / 2),
          Text(message, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
