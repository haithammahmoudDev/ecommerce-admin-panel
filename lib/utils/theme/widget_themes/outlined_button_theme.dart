import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';


class TOutlinedButtonTheme {
  TOutlinedButtonTheme._();

   static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: TColors.secondary,
      side: const BorderSide(color: TColors.secondary),
      padding: const EdgeInsets.all(Sizes.buttonHeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.borderRadiusLg)),
    ),
  );

  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: TColors.white,
      side: const BorderSide(color: TColors.white),
      padding: const EdgeInsets.symmetric(vertical: Sizes.buttonHeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.borderRadiusLg)),
    ),
  );
}
