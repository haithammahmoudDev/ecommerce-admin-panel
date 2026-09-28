import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';
import '../../../controller/create_product/create_product_cubit.dart';

class ProductTitleAndDescription extends StatelessWidget {
  const ProductTitleAndDescription({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateProductCubit>();

    return RoundedContainer(
      child: Form(
        key: cubit.titleDescriptionFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic Information Text
            Text(
              'Basic Information',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Product Title Input Field
            TextFormField(
              controller: cubit.title,
              validator: (value) =>
                  TValidator.validateEmptyText('Product Title', value),
              decoration: const InputDecoration(labelText: 'Product Title'),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Product Description Input Field
            SizedBox(
              height: 300,
              child: TextFormField(
                controller: cubit.description,
                expands: true,
                maxLines: null,
                textAlign: TextAlign.start,
                keyboardType: TextInputType.multiline,
                textAlignVertical: TextAlignVertical.top,
                validator: (value) =>
                    TValidator.validateEmptyText('Product Description', value),
                decoration: const InputDecoration(
                  labelText: 'Product Description',
                  hintText: 'Add your Product Description here...',
                  alignLabelWithHint: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}