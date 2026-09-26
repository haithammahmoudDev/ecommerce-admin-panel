import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';
import '../../../controller/create_product/create_product_cubit.dart';

class ProductStockAndPricing extends StatelessWidget {
  const ProductStockAndPricing({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateProductCubit, CreateProductState>(
      buildWhen: (previous, current) =>
      previous.productType != current.productType,
      builder: (context, state) {
        // Hide stock and pricing form when product type is set to variable
        if (state.productType == ProductType.variable) {
          return const SizedBox.shrink();
        }

        final cubit = context.read<CreateProductCubit>();

        return Form(
          key: cubit.stockPriceFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stock
              FractionallySizedBox(
                widthFactor: 0.45,
                child: TextFormField(
                  controller: cubit.stock,
                  decoration: const InputDecoration(
                    labelText: 'Stock',
                    hintText: 'Add Stock, only numbers are allowed',
                  ),
                  validator: (value) =>
                      TValidator.validateEmptyText('Stock', value),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Pricing
              Row(
                children: [
                  // Price
                  Expanded(
                    child: TextFormField(
                      controller: cubit.price,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        hintText: 'Price with up to 2 decimals',
                      ),
                      validator: (value) =>
                          TValidator.validateEmptyText('Price', value),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),

                  // Sale Price
                  Expanded(
                    child: TextFormField(
                      controller: cubit.salePrice,
                      decoration: const InputDecoration(
                        labelText: 'Discounted Price',
                        hintText: 'Price with up to 2 decimals',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}