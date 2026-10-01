import 'package:data_table_2/data_table_2.dart';
import 'package:ecommerce_admin_pannal/features/banner/domain/entities/banner_entity.dart';
import 'package:ecommerce_admin_pannal/features/banner/presentation/controller/banner_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../categories/presentation/screens/all_categories/table/table_action_icon_button.dart';

class BannersRows extends DataTableSource {
  final BuildContext context;
  BannersRows({required this.context});

  late final BannerCubit controller = context.read<BannerCubit>();

  @override
  DataRow? getRow(int index) {
    if (index < 0 || index >= controller.state.filterdItems.length) {
      return null;
    }

    final BannerEntity banner = controller.state.filterdItems[index];

     String targetDisplay = banner.targetType.name.toUpperCase();
    if (banner.targetName != null && banner.targetName!.isNotEmpty) {
      targetDisplay = '${banner.targetType.name}: ${banner.targetName}';
    }

    return DataRow2(
      selected: index < controller.state.selectedRows.length
          ? controller.state.selectedRows[index]
          : false,
      onTap: () => context.push(
        'banners/edit-banner',
        extra: banner,
      ),
      onSelectChanged: (value) => controller.toggleRowSelection(index, value),
      cells: [
        DataCell(
          RoundedImage(
            width: 180,
            height: 100,
            padding: Sizes.sm,
            image: banner.imageUrl,
            imageType: ImageType.network,
            borderRadius: Sizes.borderRadiusMd,
            backgroundColor: TColors.primaryBackground,
          ),
        ),
        DataCell(Text(targetDisplay)),
        DataCell(
          banner.active
              ? const Icon(Iconsax.eye, color: TColors.primary)
              : const Icon(Iconsax.eye_slash, color: Colors.grey),
        ),
        DataCell(
          TTableActionButtons(
            onEditPressed: () => context.push(
              'banners/edit-banner',
              extra: banner,
            ),
            onDeletePressed: () => confirmAndDeleteBanner(
              context: context,
              banner: banner,
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

void confirmAndDeleteBanner({
  required BuildContext context,
  required BannerEntity banner,
  required BannerCubit controller,
}) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Delete Banner'),
      content: const Text('Are you sure you want to delete this banner?'),
      actions: [
        SizedBox(
          width: 60,
          child: ElevatedButton(
            onPressed: () {
              dialogContext.pop();
              controller.deleteOnConfirm(banner, context);
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