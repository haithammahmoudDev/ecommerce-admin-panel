// Original file: lib/features/authentication/screens/otp/otp_screen.dart
// Converted: OTPController.instance -> context.read<OtpCubit>()
// IMPORTANT: OtpCubit must be provided above this widget in the tree (see note in otp_cubit.dart)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/constants/text_strings.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(TTexts.tOtpTitle, style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 80.0)),
            Text(TTexts.tOtpSubTitle.toUpperCase(), style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 40.0),
            const Text("${TTexts.tOtpMessage} support@codingwitht.com", textAlign: TextAlign.center),
            const SizedBox(height: 20.0),
            OtpTextField(
              mainAxisAlignment: MainAxisAlignment.center,
              numberOfFields: 6,
              fillColor: Colors.black.withValues(alpha: 0.1),
              filled: true,
              onSubmit: (code) {

              },
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                 },
                child: const Text(TTexts.tNext),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
