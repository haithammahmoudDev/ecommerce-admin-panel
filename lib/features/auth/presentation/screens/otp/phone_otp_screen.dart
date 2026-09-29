// Original file: lib/features/authentication/screens/otp/phone_otp_screen.dart
// Converted: OTPController.instance -> context.read<OtpCubit>(), Obx(...) -> BlocBuilder<OtpCubit, OtpState>
// IMPORTANT: OtpCubit must be provided above this widget in the tree (see note in otp_cubit.dart)
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class PhoneOtpScreen extends StatelessWidget {
  const PhoneOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: dark ? TColors.dark : TColors.white,
      body: Container(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              TTexts.tOtpTitle,
              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 80.0),
            ),
            Text(TTexts.tOtpSubTitle.toUpperCase(), style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 40.0),
            const Text(TTexts.tOtpMessage, textAlign: TextAlign.center),
            const SizedBox(height: 20.0),
            OtpTextField(
                mainAxisAlignment: MainAxisAlignment.center,
                numberOfFields: 6,
                fillColor: Colors.black.withValues(alpha: 0.1),
                filled: true,
                onSubmit: (code) {

                }),
            const SizedBox(height: 20.0),
             SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: (){},
                      child: const Text(TTexts.tNext)),
                ),
            const SizedBox(height: 20.0),
            // Center(
            //   child: RichText(
            //         text: TextSpan(
            //           text: TTexts.thenLets,
            //           style: Theme.of(context).textTheme.titleSmall,
            //           children: [
            //             TextSpan(
            //               text: TTexts.resendOTP,
            //               recognizer: (state.secondsRemaining > 0) ? null : TapGestureRecognizer()
            //                 ?..onTap = () => cubit.resendOTP(),
            //               style: Theme.of(context).textTheme.titleSmall?.copyWith(
            //                   color: (state.secondsRemaining > 0) ? TColors.darkGrey : TColors.primary),
            //             ),
            //             if (state.secondsRemaining > 0)
            //               TextSpan(
            //                 text: " ${TTexts.inText} ${state.secondsRemaining}",
            //                 style: Theme.of(context).textTheme.titleSmall?.copyWith(color: TColors.darkGrey),
            //               ),
            //           ],
            //         ),
            //       );
            //
            // )
          ],
        ),
      ),
    );
  }
}
