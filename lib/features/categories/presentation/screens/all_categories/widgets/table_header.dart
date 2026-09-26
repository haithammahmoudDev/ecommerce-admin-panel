import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../utils/device/device_utility.dart'; // تأكد من صحة هذا المسار في مشروعك

class TableHeader extends StatelessWidget {
  const TableHeader({
    super.key,
    this.onPressed,
    this.buttonText = 'Add', // القيمة الافتراضية كما بالفيديو
    this.searchController,
    this.searchOnChanged,
    this.showLeftWidget = true, // مضافة للتحكم في إظهار الزر
  });

  final String buttonText;
  final Function()? onPressed;
  final bool showLeftWidget;
  final Function(String)? searchOnChanged;
  final TextEditingController? searchController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: TDeviceUtils.isDesktopScreen(context) ? 3 : 1,
          child: showLeftWidget
              ? Row(
            children: [
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: onPressed,
                  child: Text(buttonText),
                ),
              ),
            ],
          )
              : const SizedBox.shrink(), // يخفي الزر إذا كانت القيمة false
        ),

        Expanded(
          flex: TDeviceUtils.isDesktopScreen(context) ? 2 : 1,
          child: TextFormField(
            controller: searchController,
            onChanged: searchOnChanged,
            decoration: const InputDecoration(
              hintText: 'Search here...',
              prefixIcon: Icon(Iconsax.search_normal),
            ),
          ),
        ),
      ],
    );
  }
}
