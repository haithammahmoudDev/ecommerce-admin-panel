import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../features/categories/presentation/screens/all_categories/table/table_action_icon_button.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../domain/entities/brand_entity.dart';
import '../../../controller/brand_cubit.dart';

class BrandRows extends DataTableSource {
  final BuildContext context;
  BrandRows(this.context);

  late final BrandCubit controller = context.read<BrandCubit>();

  @override
  DataRow? getRow(int index) {
    if (index < 0 || index >= controller.state.filterdItems.length) {
      return null;
    }

    final BrandEntity brand = controller.state.filterdItems[index];

    return DataRow2(
      selected: index < controller.state.selectedRows.length
          ? controller.state.selectedRows[index]
          : false,
      onSelectChanged: (value) => controller.toggleRowSelection(index, value),
      cells: [
        DataCell(
          Row(
            children: [
              RoundedImage(
                width: 50,
                height: 50,
                padding: Sizes.sm,
                image: brand.image,
                imageType: ImageType.network,
                borderRadius: Sizes.borderRadiusMd,
                backgroundColor: TColors.primaryBackground,
              ),
              const SizedBox(width: Sizes.spaceBtwItems),
              Expanded(
                child: Text(
                  brand.name,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.apply(color: TColors.primary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        DataCell(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Sizes.xs),
            child: Wrap(
              spacing: Sizes.xs,
              runSpacing: Sizes.xs,
              children:
                  (brand.brandCategories != null &&
                      brand.brandCategories!.isNotEmpty)
                  ? brand.brandCategories!
                        .map(
                          (category) => Chip(
                            label: Text(
                              category.name,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            padding: const EdgeInsets.all(Sizes.xs),
                            visualDensity: VisualDensity.compact,
                          ),
                        )
                        .toList()
                  : [const Text('—')],
            ),
          ),
        ),

        DataCell(
          brand.isFeatured
              ? const Icon(Iconsax.heart5, color: TColors.primary)
              : const Icon(Iconsax.heart),
        ),

        DataCell(
          Text(
            brand.createdAt == null ? '' : brand.getFormattedDate,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        DataCell(
          TTableActionButtons(
            onEditPressed: () =>
                context.push('/brands/edit-brand', extra: brand),
            onDeletePressed: () => confirmAndDeleteBrand(
              context: context,
              brand: brand,
              controller: controller,
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.state.filterdItems.length;

  @override
  int get selectedRowCount => controller.state.selectedCount;
}

void confirmAndDeleteBrand({
  required BuildContext context,
  required BrandEntity brand,
  required BrandCubit controller,
}) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Delete Brand'),
      content: const Text('Are you sure you want to delete this brand?'),
      actions: [
        SizedBox(
          width: 60,
          child: ElevatedButton(
            onPressed: () {
              dialogContext.pop();
              controller.deleteOnConfirm(brand, context);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: Sizes.buttonHeight / 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Sizes.buttonRadius * 5),
              ),
            ),
            child: const Text('Ok'),
          ),
        ),

        SizedBox(
          width: 60,
          child: OutlinedButton(
            onPressed: () => dialogContext.pop(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: Sizes.buttonHeight / 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Sizes.buttonRadius * 5),
              ),
            ),
            child: const Text('Cancel'),
          ),
        ),
      ],
    ),
  );
}
