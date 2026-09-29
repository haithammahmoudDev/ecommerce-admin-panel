// Original file: lib/features/authentication/screens/phone_number/widget/phone_number_field.dart
// Converted: Get.put(SignInController()) -> context.read<SignInCubit>()
// NOTE: this widget is a CHILD of PhoneNumberScreen (used inside its Column), and
// PhoneNumberScreen already provides SignInCubit via BlocProvider above it - so this
// widget just reads that same instance instead of creating its own. No BlocBuilder
// needed here: the original never wrapped this in Obx (selectedCountryCode is written
// but never read reactively inside this widget), so this stays a 1:1 conversion.
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../../../utils/helpers/helper_functions.dart';
import '../../../../../../utils/validators/validation.dart';

class TPhoneNumberField extends StatelessWidget {
  const TPhoneNumberField({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
     return Form(
      // key: controller.signInFormKey,
      child: TextFormField(
        cursorColor: TColors.primary,
        cursorHeight: Sizes.lg,
        style: Theme.of(context).textTheme.bodySmall,
        validator: (value) => Validator.validatePhoneNumber(value),
        // controller: controller.phone,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          fillColor: isDark ? TColors.dark : TColors.white,
          prefixIcon: CountryCodePicker(
            alignLeft: false,
            hideMainText: true,
            showCountryOnly: false,
            padding: EdgeInsets.zero,
            showDropDownButton: true,
            initialSelection: 'GB',
            showOnlyCountryWhenClosed: false,
            headerText: TTexts.selectCountry,
            favorite: const ['GB', '+92'],
           // onChanged: (value) => controller.updateCountryCode(value.dialCode!),
            searchDecoration: InputDecoration(fillColor: isDark ? TColors.darkContainer : TColors.lightContainer),
            dialogBackgroundColor: isDark ? TColors.dark : TColors.white,
          ),
          hintText: TTexts.phoneNo,
          errorStyle: const TextStyle(color: TColors.error),
        ),
      ),
    );
  }
}