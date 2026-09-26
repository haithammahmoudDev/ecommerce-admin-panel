import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/device/device_utility.dart';
import '../../../../../../utils/validators/validation.dart';
import '../../../../domain/entities/product_attribute_entity.dart';
import '../../../controller/product_attributes/product_attributes_cubit.dart';
import '../../../controller/product_variations/prduct_cariations_cubit.dart';


class ProductAttributes extends StatelessWidget {
  const ProductAttributes({super.key});

  @override
  Widget build(BuildContext context) {
    final attributesCubit = context.read<ProductAttributesCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: TColors.primaryBackground),
        const SizedBox(height: TSizes.spaceBtwSections),

        Text(
          'Add Product Attributes',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: TSizes.spaceBtwItems),

        // Form to add new attribute
        Form(
          key: attributesCubit.attributesFormKey,
          child: TDeviceUtils.isDesktopScreen(context)
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildAttributeName(context, attributesCubit)),
              const SizedBox(width: TSizes.spaceBtwItems),
              Expanded(
                flex: 2,
                child: _buildAttributeTextField(context, attributesCubit),
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              _buildAddAttributeButton(context, attributesCubit),
            ],
          )
              : Column(
            children: [
              _buildAttributeName(context, attributesCubit),
              const SizedBox(height: TSizes.spaceBtwItems),
              _buildAttributeTextField(context, attributesCubit),
              const SizedBox(height: TSizes.spaceBtwItems),
              _buildAddAttributeButton(context, attributesCubit),
            ],
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwSections),

        // List of added attributes
        Text(
          'All Attributes',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: TSizes.spaceBtwItems),

        // Display added attributes
        TRoundedContainer(
          backgroundColor: TColors.primaryBackground,
          child: BlocBuilder<ProductAttributesCubit, ProductAttributesState>(
            builder: (context, state) {
              if (state.productAttributes.isEmpty) {
                return buildEmptyAttributes();
              }
              return buildAttributesList(context, state.productAttributes);
            },
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwSections),

        // Generate Variations Button
        Center(
          child: SizedBox(
            width: 200,
            child: ElevatedButton.icon(
              icon: const Icon(Iconsax.activity),
              label: const Text('Generate Variations'),
              onPressed: () {
                final attributes = context.read<ProductAttributesCubit>().state.productAttributes;
                context.read<ProductVariationsCubit>().generateVariationsConfirmation(
                  context,
                  attributes,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  SizedBox _buildAddAttributeButton(BuildContext context, ProductAttributesCubit cubit) {
    return SizedBox(
      width: 100,
      child: ElevatedButton.icon(
        onPressed: cubit.addNewAttribute,
        icon: const Icon(Iconsax.add),
        style: ElevatedButton.styleFrom(
          foregroundColor: TColors.black,
          backgroundColor: TColors.secondary,
          side: const BorderSide(color: TColors.secondary),
        ),
        label: const Text('Add'),
      ),
    );
  }

  TextFormField _buildAttributeName(BuildContext context, ProductAttributesCubit cubit) {
    return TextFormField(
      controller: cubit.attributeName,
      validator: (value) => TValidator.validateEmptyText('Attribute Name', value),
      decoration: const InputDecoration(
        labelText: 'Attribute Name',
        hintText: 'Colors, Sizes, Material',
      ),
    );
  }

  SizedBox _buildAttributeTextField(BuildContext context, ProductAttributesCubit cubit) {
    return SizedBox(
      height: 80,
      child: TextFormField(
        controller: cubit.attributes,
        expands: true,
        maxLines: null,
        textAlign: TextAlign.start,
        keyboardType: TextInputType.multiline,
        textAlignVertical: TextAlignVertical.top,
        validator: (value) => TValidator.validateEmptyText('Attributes Field', value),
        decoration: const InputDecoration(
          labelText: 'Attributes',
          hintText: 'Add attributes separated by | Example: Green | Blue | Yellow',
          alignLabelWithHint: true,
        ),
      ),
    );
  }

  Widget buildEmptyAttributes() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildColorSwatch(Colors.black),
            _buildColorSwatch(Colors.grey),
            _buildColorSwatch(Colors.grey.shade400),
            _buildColorSwatch(Colors.blue),
            _buildColorSwatch(Colors.deepOrange),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        const Text('There are no attributes added for this product'),
      ],
    );
  }

  Widget _buildColorSwatch(Color color) {
    return Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
      ),
    );
  }

  Widget buildAttributesList(BuildContext context, List<ProductAttributeEntity> attributes) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: attributes.length,
      separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
      itemBuilder: (_, index) {
        final attribute = attributes[index];
        return Container(
          decoration: BoxDecoration(
            color: TColors.white,
            borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
          ),
          child: ListTile(
            title: Text(attribute.name ?? ''),
            subtitle: Text(attribute.values?.join(', ') ?? ''),
            trailing: IconButton(
              onPressed: () => context.read<ProductAttributesCubit>().removeAttribute(index, context),
              icon: const Icon(Iconsax.trash, color: TColors.error),
            ),
          ),
        );
      },
    );
  }
}