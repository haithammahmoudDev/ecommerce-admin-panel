import 'package:data_table_2/data_table_2.dart';
import 'package:ecommerce_admin_pannal/features/customer/presentation/controller/customer_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../categories/presentation/screens/all_categories/table/table_action_icon_button.dart';
import '../../../../../auth/domain/entities/user_entity.dart';

class CustomerRows extends DataTableSource {
  final BuildContext context;
  CustomerRows({required this.context});
  late final controller = context.read<CustomerCubit>();

  @override
  DataRow? getRow(int index) {
    final customers = controller.state.filterdItems;

    if (index >= customers.length) return null;

    final customer = customers[index];
    return DataRow2(
      selected: controller.state.selectedRows[index],
      onTap: () => context.push('/customers/customer-detail', extra: customer),
      onSelectChanged: (value) => controller.toggleRowSelection(index, value),
      cells: [
        // 1. Customer
        DataCell(
          Row(
            children: [
              TRoundedImage(
                width: 50,
                height: 50,
                padding: TSizes.sm,
                image: customer.profilePicture,
                imageType: ImageType.network,
                borderRadius: TSizes.borderRadiusMd,
                backgroundColor: TColors.primaryBackground,
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Expanded(
                child: Text(
                  customer.fullName,
                  style: Theme.of(context).textTheme.bodyLarge!.apply(color: TColors.primary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        // 2. Email
        DataCell(Text(customer.email)),
        // 3. Phone Number
        DataCell(Text(customer.phoneNumber)),
        // 4. Registered
        DataCell(Text(customer.createdAt == null ? '' : customer.formattedDate)),
        // 5. Action
        DataCell(
          TTableActionButtons(
            view: true,
            edit: false,
            onViewPressed: () => context.push('/customers/customer-detail', extra: customer),
            onDeletePressed: () => confirmAndDeleteCustomer(
              context: context,
              customer: customer,
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
  int get selectedRowCount => controller.state.selectedRows
      .where((selected) => selected)
      .length;
}

void confirmAndDeleteCustomer({
  required BuildContext context,
  required UserEntity customer,
  required CustomerCubit controller,
}) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Delete Customer'),
      content: const Text('Are you sure you want to delete this customer?'),
      actions: [
        // === Confirm ===
        SizedBox(
          width: 60,
          child: ElevatedButton(
            onPressed: () {
              dialogContext.pop();
              controller.deleteOnConfirm(customer, context);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: TSizes.buttonHeight / 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TSizes.buttonRadius * 5),
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
                borderRadius: BorderRadius.circular(TSizes.buttonRadius * 5),
              ),
            ),
            child: const Text('Cancel'),
          ),
        ),
      ],
    ),
  );
}