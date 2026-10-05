import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../utils/constants/colors.dart';

/// Widget for displaying action buttons for table rows
class TTableActionButtons extends StatelessWidget {
  const TTableActionButtons({
    super.key,
    this.view = false,
    this.edit = true,
    this.delete = true,
    this.onViewPressed,
    this.onEditPressed,
    this.onDeletePressed,
  });

  final bool view;

  final bool edit;

  final bool delete;

  final VoidCallback? onViewPressed;

  final VoidCallback? onEditPressed;

  final VoidCallback? onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (view)
          IconButton(
            onPressed: onViewPressed,
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(6),
            icon: const Icon(Iconsax.eye, color: TColors.dark, size: 20),
          ),
        if (edit)
          IconButton(
            onPressed: onEditPressed,
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(6),
            icon: const Icon(Iconsax.pen_add, color: TColors.primary, size: 20),
          ),
        if (delete)
          IconButton(
            onPressed: onDeletePressed,
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(6),
            icon: const Icon(Iconsax.trash, color: TColors.error, size: 20),
          ), // IconButton
      ],
    ); // Row
  }
}
