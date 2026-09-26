import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';


class TOutlinedButtonTheme {
  TOutlinedButtonTheme._();

   static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: TColors.secondary,
      side: const BorderSide(color: TColors.secondary),
      padding: const EdgeInsets.all(TSizes.buttonHeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TSizes.borderRadiusLg)),
    ),
  );

  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: TColors.white,
      side: const BorderSide(color: TColors.white),
      padding: const EdgeInsets.symmetric(vertical: TSizes.buttonHeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TSizes.borderRadiusLg)),
    ),
  );
}
