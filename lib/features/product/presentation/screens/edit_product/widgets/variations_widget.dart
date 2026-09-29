import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../categories/presentation/screens/create_category/widgets/image_uploader.dart';
import '../../../../../media/presentation/controller/media_cubit/media_cubit.dart';
import '../../../../domain/entities/product_variation_entity.dart';
import '../../../controller/product_variations/prduct_cariations_cubit.dart';

class ProductVariations extends StatelessWidget {
  const ProductVariations({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductVariationsCubit>();

    return RoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Product Variations',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              TextButton(
                onPressed: () => cubit.removeVariations(context),
                child: const Text('Remove Variations'),
              ),
            ],
          ),
          const SizedBox(height: Sizes.spaceBtwItems),

          // Variations List / No Variations State
          BlocBuilder<ProductVariationsCubit, ProductVariationsState>(
            builder: (context, state) {
              if (state.productVariations.isEmpty) {
                return _buildNoVariationsMessage();
              }

              return ListView.separated(
                itemCount: state.productVariations.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) =>
                const SizedBox(height: Sizes.spaceBtwItems),
                itemBuilder: (_, index) {
                  final variation = state.productVariations[index];
                  return _buildVariationTile(context, cubit, variation, index);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // Safely extract controller without relying on Map key equality
  TextEditingController? _getController(
      List<Map<ProductVariationEntity, TextEditingController>> list,
      int index,
      ) {
    if (index < 0 || index >= list.length) return null;
    final map = list[index];
    if (map.isEmpty) return null;
    return map.values.first;
  }

  // Helper method to build a variation tile
  Widget _buildVariationTile(
      BuildContext context,
      ProductVariationsCubit cubit,
      ProductVariationEntity variation,
      int index,
      ) {
    final titleText = variation.attributeValues.entries
        .map((e) => '${e.key}: ${e.value}')
        .join(', ');

    return ExpansionTile(
      backgroundColor: TColors.lightGrey,
      collapsedBackgroundColor: TColors.lightGrey,
      childrenPadding: const EdgeInsets.all(Sizes.md),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
      ),
      title: Text(titleText.isEmpty ? 'Variation ${index + 1}' : titleText),
      children: [
        // Upload Variation Image
        TImageUploader(
          right: 0,
          left: null,
          imageType: (variation.image != null && variation.image!.isNotEmpty)
              ? ImageType.network
              : ImageType.asset,
          image: variation.image ?? '',
          onIconButtonPressed: () async {
            final mediaCubit = context.read<MediaCubit>();
            final selectedImages =
            await mediaCubit.selectImagesFromMedia(context: context);

            if (selectedImages != null && selectedImages.isNotEmpty) {
              cubit.setVariationImage(index, selectedImages.first.url);
            }
          },
        ),
        const SizedBox(height: Sizes.spaceBtwInputFields),

        // Variation Stock and Pricing
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _getController(cubit.stockControllersList, index),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  labelText: 'Stock',
                  hintText: 'Add Stock, only numbers allowed',
                ),
              ),
            ),
            const SizedBox(width: Sizes.spaceBtwInputFields),

            Expanded(
              child: TextFormField(
                controller: _getController(cubit.priceControllersList, index),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Price',
                  hintText: 'Base Price',
                ),
              ),
            ),
            const SizedBox(width: Sizes.spaceBtwInputFields),

            Expanded(
              child: TextFormField(
                controller: _getController(cubit.salePriceControllersList, index),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Discounted Price',
                  hintText: 'Must be less than Price',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: Sizes.spaceBtwInputFields),

        // Variation Description
        TextFormField(
          controller: _getController(cubit.descriptionControllersList, index),
          decoration: const InputDecoration(
            labelText: 'Description',
            hintText: 'Add description of this variation...',
          ),
        ),
        const SizedBox(height: Sizes.spaceBtwSections),
      ],
    );
  }

  // Helper method to build message when there are no variations
  Widget _buildNoVariationsMessage() {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundedImage(
              width: 200,
              height: 200,
              imageType: ImageType.network,
              image: 'https://cdn-icons-png.flaticon.com/512/6475/6475042.png',
            ),
          ],
        ),
        const SizedBox(height: Sizes.spaceBtwItems),
        const Text('There are no variations added for this product'),
      ],
    );
  }
}