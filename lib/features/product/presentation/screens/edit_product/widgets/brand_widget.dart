import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../common/abstraction/base_data_table/base_data_table_state.dart';
import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../brand/domain/entities/brand_entity.dart';
import '../../../../../brand/presentation/controller/brand_cubit.dart';
import '../../../controller/edit_product/edit_product_cubit.dart';

class ProductBrand extends StatelessWidget {
  const ProductBrand({super.key});

  @override
  Widget build(BuildContext context) {
    final editProductCubit = context.read<EditProductCubit>();

    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Brand', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: TSizes.spaceBtwItems),

          BlocBuilder<BrandCubit, BaseDataTableState<BrandEntity>>(
            builder: (context, brandState) {
              return TypeAheadField<BrandEntity>(
                controller: editProductCubit.brandTextField,
                builder: (context, ctr, focusNode) {
                  return TextFormField(
                    controller: ctr,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Select Brand',
                      suffixIcon: Icon(Iconsax.box),
                    ),
                  );
                },
                suggestionsCallback: (pattern) {
                  final items = brandState.allItems;
                  if (items.isEmpty) return [];
                  return items
                      .where((brand) =>
                      brand.name.toLowerCase().contains(pattern.toLowerCase()))
                      .toList();
                },
                itemBuilder: (context, suggestion) => ListTile(title: Text(suggestion.name)),
                onSelected: (suggestion) {
                  editProductCubit.brandTextField.text = suggestion.name;
                  editProductCubit.selectBrand(suggestion);
                },
              );
            },
          ),

          BlocBuilder<EditProductCubit, EditProductState>(
            builder: (context, state) {
              final typed = editProductCubit.brandTextField.text.trim();
              final matchesSelection =
                  state.selectedBrand != null && state.selectedBrand!.name == typed;

              if (typed.isNotEmpty && !matchesSelection) {
                return const Padding(
                  padding: EdgeInsets.only(top: TSizes.xs),
                  child: Text(
                    'Please pick a brand from the suggestions list',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}