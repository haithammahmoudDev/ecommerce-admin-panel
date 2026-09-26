import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../controller/create_product/create_product_cubit.dart';

class ProductTypeWidget extends StatelessWidget {
  const ProductTypeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateProductCubit, CreateProductState>(
      buildWhen: (previous, current) =>
      previous.productType != current.productType,
      builder: (context, state) {
        final cubit = context.read<CreateProductCubit>();

        return Row(
          children: [
            Text('Product Type',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(width: TSizes.spaceBtwItems),

            RadioMenuButton<ProductType>(
              value: ProductType.single,
              groupValue: state.productType,
              onChanged: (value) {
                if (value != null) {
                  cubit.changeProductType(value);
                }
              },
              child: const Text('Single'),
            ),

            RadioMenuButton<ProductType>(
              value: ProductType.variable,
              groupValue: state.productType,
              onChanged: (value) {
                if (value != null) {
                  cubit.changeProductType(value);
                }
              },
              child: const Text('Variable'),
            ),
          ],
        );
      },
    );
  }
}