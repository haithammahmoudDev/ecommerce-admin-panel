import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';
import '../../../controller/edit_product/edit_product_cubit.dart';

class ProductStockAndPricing extends StatelessWidget {
  const ProductStockAndPricing({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProductCubit, EditProductState>(
      buildWhen: (previous, current) =>
      previous.productType != current.productType,
      builder: (context, state) {
        if (state.productType == ProductType.variable) {
          return const SizedBox.shrink();
        }

        final cubit = context.read<EditProductCubit>();

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
                      Validator.validateEmptyText('Stock', value),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
              const SizedBox(height: Sizes.spaceBtwInputFields),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: cubit.price,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        hintText: 'Price with up to 2 decimals',
                      ),
                      validator: (value) =>
                          Validator.validateEmptyText('Price', value),
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
                  const SizedBox(width: Sizes.spaceBtwItems),

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