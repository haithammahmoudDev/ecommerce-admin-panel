import 'package:data_table_2/data_table_2.dart';
import 'package:ecommerce_admin_pannal/features/product/presentation/controller/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../categories/presentation/screens/all_categories/table/table_action_icon_button.dart';
import '../../../../data/models/product_model.dart';
import '../../../../domain/entities/product_entity.dart';
// أضف بقية الـ imports الخاصة بمشروعك هنا (مثل Get, TColors, TSizes, TRoundedImage...)

class ProductsRows extends DataTableSource {
  final BuildContext context;

  ProductsRows({required this.context});
  late final controller = context.read<ProductCubit>();

  @override
  DataRow? getRow(int index) {
    final products = controller.state.filterdItems;

    if (index >= products.length) return null;

    final product = products[index];    return DataRow2(
      selected: controller.state.selectedRows[index],
      onTap: () => context.push('/products/edit-product', extra: product),
      onSelectChanged: (value) => controller.toggleRowSelection(index, value),
      cells: [
        // 1. Product Column
        DataCell(
          Row(
            children: [
              TRoundedImage(
                width: 50,
                height: 50,
                padding: TSizes.xs,
                image: product.thumbnail,
                imageType: ImageType.network,
                borderRadius: TSizes.borderRadiusMd,
                backgroundColor: TColors.primaryBackground,
              ), // TRoundedImage
              const SizedBox(width: TSizes.spaceBtwItems),
              Flexible(
                child: Text(
                  product.title,
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyLarge!
                      .apply(color: TColors.primary),
                  overflow: TextOverflow.ellipsis,
                ), // Text
              ), // Flexible
            ],
          ),
        ),

        // 2. Stock Column
        DataCell(Text(controller.getProductStockTotal(product))),
        DataCell(Text(controller.getProductSoldQuantity(product))),


        // 3. Brand Column
        DataCell(
          Row(
            children: [
              TRoundedImage(
                width: 35,
                height: 35,
                padding: TSizes.xs,
                borderRadius: TSizes.borderRadiusMd,
                backgroundColor: TColors.primaryBackground,
                imageType: product.brand != null ? ImageType.network : ImageType
                    .asset,
                image: product.brand != null
                    ? product.brand!.image
                    : 'assets/images/profile/logo.png',
              ), // TRoundedImage
              const SizedBox(width: TSizes.spaceBtwItems),
              Flexible(
                child: Text(
                  product.brand != null ? product.brand!.name : '',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyLarge!
                      .apply(color: TColors.primary),
                ), // Text
              ),
            ],
          ), // Row
        ), // DataCell

        // 4. Price Column
        DataCell(Text('\$${controller.getProductPrice(product)}')),
        DataCell(Text(product.formattedDate)),

        // 6. Action Column
        DataCell(
          TTableActionButtons(
            onEditPressed: () =>
                context.push('/products/edit-product', extra: product),
            onDeletePressed: () =>
                confirmAndDeleteBrand(context: context,
                  product: product,
                  controller: controller,
                ),
          ), // TTableActionButtons
        ), // DataCell
      ],
    ); // DataRow2
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.state.filterdItems.length;

  @override
  int get selectedRowCount =>
      controller.state.selectedRows
          .where((selected) => selected)
          .length;

  void confirmAndDeleteBrand({
    required BuildContext context,
    required ProductEntity product,
    required ProductCubit controller,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) =>
          AlertDialog(
            title: const Text('Delete Brand'),
            content: const Text('Are you sure you want to delete this brand?'),
            actions: [
              // === Confirm ===
              SizedBox(
                width: 60,
                child: ElevatedButton(
                  onPressed: () {
                    dialogContext.pop();
                    controller.deleteOnConfirm(product, context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: TSizes.buttonHeight / 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          TSizes.buttonRadius * 5),
                    ),
                  ),
                  child: const Text('Ok'),
                ),
              ),

              // === Cancel ===
              SizedBox(
                width: 60,
                child: OutlinedButton(
                  onPressed: () => dialogContext.pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: TSizes.buttonHeight / 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          TSizes.buttonRadius * 5),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
    );
  }
}
