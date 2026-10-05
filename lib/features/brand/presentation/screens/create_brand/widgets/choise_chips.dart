import 'package:flutter/material.dart';
import '../../../../../../common/widgets/custom_shapes/containers/circular_container.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/helpers/helper_functions.dart';

class TChoiceChip extends StatelessWidget {
  const TChoiceChip({
    super.key,
    required this.text,
    required this.selected,
    this.onSelected,
  });

  final String text;
  final bool selected;
  final ValueChanged<bool>? onSelected;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: ChoiceChip(
        avatar: THelperFunctions.getColor(text) != null
            ? TCircularContainer(width: 50, height: 50, backgroundColor: THelperFunctions.getColor(text)!)
            : null,
        selected: selected,
        onSelected: onSelected,
        backgroundColor: THelperFunctions.getColor(text),
        labelStyle: TextStyle(color: selected ? TColors.white : null),
        shape: THelperFunctions.getColor(text) != null ? const CircleBorder() : null,
        label: THelperFunctions.getColor(text) == null ? Text(text) : const SizedBox(),
        padding: THelperFunctions.getColor(text) != null ? const EdgeInsets.all(0) : null,
        labelPadding: THelperFunctions.getColor(text) != null ? const EdgeInsets.all(0) : null,
      ), // ChoiceChip
    ); // Theme
  }
}
