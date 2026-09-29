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
        TImageUploader(
          right: 0,
          left: null,
          imageType: (variation.image.isNotEmpty)
              ? ImageType.network
              : ImageType.asset,
          image: variation.image,
          onIconButtonPressed: () async {
            final mediaCubit = context.read<MediaCubit>();
            final selectedImages = await mediaCubit.selectImagesFromMedia(
              context: context,
            );

            if (selectedImages != null && selectedImages.isNotEmpty) {
              cubit.setVariationImage(index, selectedImages.first.url);
            }
          },
        ),
        const SizedBox(height: Sizes.spaceBtwInputFields),

        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: cubit.stockControllersList[index][variation],
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
                controller: cubit.priceControllersList[index][variation],
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
                controller: cubit.salePriceControllersList[index][variation],
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

        TextFormField(
          controller: cubit.descriptionControllersList[index][variation],
          decoration: const InputDecoration(
            labelText: 'Description',
            hintText: 'Add description of this variation...',
          ),
        ),
        const SizedBox(height: Sizes.spaceBtwSections),
      ],
    );
  }

  Widget _buildNoVariationsMessage() {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TRoundedImage(
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
