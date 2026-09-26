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

  /// Flag to determine whether the view button is enabled
  final bool view;

  /// Flag to determine whether the edit button is enabled
  final bool edit;

  /// Flag to determine whether the delete button is enabled
  final bool delete;

  /// Callback function for when the view button is pressed
  final VoidCallback? onViewPressed;

  /// Callback function for when the edit button is pressed
  final VoidCallback? onEditPressed;

  /// Callback function for when the delete button is pressed
  final VoidCallback? onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // يمنع الـ Row من التمدد الأفقي الزائد ويحل مشكلة الـ Overflow [1]
      children: [
        if (view)
          IconButton(
            onPressed: onViewPressed,
            constraints: const BoxConstraints(), // يزيل القيود الكبيرة الافتراضية للزر [1]
            padding: const EdgeInsets.all(6), // تقليل الحشو ليوفر مساحة أفقية [1]
            icon: const Icon(Iconsax.eye, color: TColors.dark, size: 20), // تصغير الأيقونة لتناسب الـ 100px [1]
          ), // IconButton
        if (edit)
          IconButton(
            onPressed: onEditPressed,
            constraints: const BoxConstraints(), // يزيل القيود الكبيرة الافتراضية للزر [1]
            padding: const EdgeInsets.all(6), // تقليل الحشو ليوفر مساحة أفقية [1]
            icon: const Icon(Iconsax.pen_add, color: TColors.primary, size: 20), // تصغير الأيقونة لتناسب الـ 100px [1]
          ), // IconButton
        if (delete)
          IconButton(
            onPressed: onDeletePressed,
            constraints: const BoxConstraints(), // يزيل القيود الكبيرة الافتراضية للزر [1]
            padding: const EdgeInsets.all(6), // تقليل الحشو ليوفر مساحة أفقية [1]
            icon: const Icon(Iconsax.trash, color: TColors.error, size: 20), // تصغير الأيقونة لتناسب الـ 100px [1]
          ), // IconButton
      ],
    ); // Row
  }
}
