// Original file: lib/features/authentication/screens/phone_number_screen.dart
// Converted: Get.put(SignInController()) -> BlocProvider(create: (_) => SignInCubit())
// FIX: SignInCubit now needs UserCubit + CreateNotificationCubit (see phone_number_cubit.dart)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart'; // kept only for the `.tr` localization extension, not for state management
import 'package:lottie/lottie.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import 'widget/phone_number_field.dart';

class PhoneNumberScreen extends StatelessWidget {
  const PhoneNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Builder(
      builder: (context) {
         return Scaffold(
          backgroundColor: dark ? TColors.dark : TColors.white,
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding:
              const EdgeInsets.only(left: Sizes.defaultSpace, right: Sizes.defaultSpace, top: Sizes.defaultSpace * 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// -- Display the OTP image
                  Lottie.asset(TImages.signInAnimation,
                      width: THelperFunctions.screenWidth() * 0.875, height: THelperFunctions.screenHeight() * 0.4),
                  const SizedBox(height: Sizes.spaceBtwSections),
                  const SizedBox(height: Sizes.spaceBtwItems),

                  /// -- Title
                  Center(
                    child: Text(
                      TTexts.otpVerification,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  const SizedBox(height: Sizes.spaceBtwItems),

                  /// -- Subtitle
                  Center(
                    child: Text(
                      TTexts.signInSubTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),

                  const SizedBox(height: Sizes.spaceBtwItems),

                  /// -- Phone number Field
                  const TPhoneNumberField(),

                  const SizedBox(height: Sizes.spaceBtwItems),

                  /// -- Continue Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: Text(TTexts.tContinue.tr),
                      onPressed: () {},
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}