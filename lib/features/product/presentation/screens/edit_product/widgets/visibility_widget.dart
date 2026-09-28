import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../controller/edit_product/edit_product_cubit.dart';

class ProductVisibilityWidget extends StatelessWidget {
  const ProductVisibilityWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Visibility Header
          Text('Visibility', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Radio buttons for product visibility
          BlocBuilder<EditProductCubit, EditProductState>(
            builder: (context, state) {
              return Column(
                children: [
                  _buildVisibilityRadioButton(
                    context,
                    ProductVisibility.published,
                    'Published',
                    state.productVisibility,
                  ),
                  _buildVisibilityRadioButton(
                    context,
                    ProductVisibility.hidden,
                    'Hidden',
                    state.productVisibility,
                  ),
                ],
              ); // Column
            },
          ),
        ],
      ), // Column
    ); // TRoundedContainer
  }

  // Helper method to build a radio button for product visibility
  Widget _buildVisibilityRadioButton(
      BuildContext context,
      ProductVisibility value,
      String label,
      ProductVisibility groupValue,
      ) {
    return RadioMenuButton<ProductVisibility>(
      value: value,
      groupValue: groupValue,
      onChanged: (value) {
        if (value != null) {
          context.read<EditProductCubit>().setProductVisibility(value);
        }
      },
      child: Text(label),
    );
  }
}