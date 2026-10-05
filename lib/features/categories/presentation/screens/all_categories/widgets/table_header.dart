import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../utils/device/device_utility.dart';

class TableHeader extends StatelessWidget {
  const TableHeader({
    super.key,
    this.onPressed,
    this.buttonText = 'Add',
    this.searchController,
    this.searchOnChanged,
    this.showLeftWidget = true,
  });

  final String buttonText;
  final Function()? onPressed;
  final bool showLeftWidget;
  final Function(String)? searchOnChanged;
  final TextEditingController? searchController;

  @override
  Widget build(BuildContext context) {
    return !TDeviceUtils.isMobileScreen(context) ? Row(
      children: [
        Expanded(
          flex: TDeviceUtils.isDesktopScreen(context) ? 3 : 1,
          child: showLeftWidget
              ?
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: onPressed,
                  child: Text(buttonText),
                ),
              )
              : const SizedBox.shrink(),
        ),
        !TDeviceUtils.isMobileScreen(context) ? SizedBox(width: 20,) : const SizedBox.shrink(),
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
    ) : Column(
      children: [
        TextFormField(
          controller: searchController,
          onChanged: searchOnChanged,
          decoration: const InputDecoration(
            hintText: 'Search here...',
            prefixIcon: Icon(Iconsax.search_normal),
          ),
        ),
        const SizedBox(height: 12,),
        showLeftWidget
            ?
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onPressed,
            child: Text(buttonText),
          ),
        )
            : const SizedBox.shrink(),
      ],
    );
  }
}
