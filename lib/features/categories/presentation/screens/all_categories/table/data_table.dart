import 'package:data_table_2/data_table_2.dart';
import 'package:ecommerce_admin_pannal/features/categories/domain/entities/category_entity.dart';
import 'package:ecommerce_admin_pannal/features/categories/presentation/controller/category/category_cubit.dart';
import 'package:ecommerce_admin_pannal/features/categories/presentation/screens/all_categories/table/table_action_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';

class CategoryRows extends DataTableSource {
  final BuildContext context;
  CategoryRows(this.context);

  late final CategoryCubit controller = context.read<CategoryCubit>();

  @override
  DataRow? getRow(int index) {
    if (index < 0 || index >= controller.state.filterdItems.length) {
      return null;
    }

    final CategoryEntity category = controller.state.filterdItems[index];
    final parentCategory = controller.state.allItems.firstWhereOrNull(
      (item) => item.id == category.parentId,
    );

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
                image: category.image,
                imageType: ImageType.network,
                borderRadius: Sizes.borderRadiusMd,
                backgroundColor: TColors.primaryBackground,
              ),
              const SizedBox(width: Sizes.spaceBtwItems),
              Expanded(
                child: Text(
                  category.name,
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
        DataCell(Text(parentCategory != null ? parentCategory.name : '')),
        DataCell(
          category.isFeatured
              ? const Icon(Iconsax.heart5, color: TColors.primary)
              : const Icon(Iconsax.heart),
        ),
        DataCell(
          Text(
            category.createdAt == null ? '' : category.formattedDate,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          TTableActionButtons(
            onEditPressed: () => context.push(
              '/categories/edit-category',
              extra: category,
            ),
            onDeletePressed: () => confirmAndDeleteItem(
              context: context,
              category: category,
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

void confirmAndDeleteItem({
  required BuildContext context,
  required CategoryEntity category,
  required CategoryCubit controller,
}) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Delete Item'),
      content: const Text('Are you sure you want to delete this item?'),
      actions: [
        SizedBox(
          width: 60,
          child: ElevatedButton(
            onPressed: () {
              dialogContext.pop();
              controller.deleteOnConfirm(category, context);
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
