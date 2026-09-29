import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../login/login_screen.dart';

class ResetPasswordWidget extends StatelessWidget {
  const ResetPasswordWidget({super.key, required this.email});
  final String email;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              // 2. تعديل السطر 21 للعودة لشاشة تسجيل الدخول باستخدام go_router
              onPressed: () => context.go(LoginScreen.routeName),
              icon: const Icon(CupertinoIcons.clear),
            ),
          ],
        ),
        const SizedBox(height: Sizes.spaceBtwItems),

        /// Image
        const Image(image: AssetImage(TImages.deliveredEmailIllustration), width: 300, height: 300),
        const SizedBox(height: Sizes.spaceBtwItems),

        /// Title & SubTitle
        Text('Password Reset Email Sent', style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
        const SizedBox(height: Sizes.spaceBtwItems),

        // 3. عرض الإيميل المستقبل (السطر 32)
        Text(email, textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: Sizes.spaceBtwItems),

        Text(
          'Your Account Security is Our Priority! We ve Sent You a Secure Link to Safely Change Your Password and Keep Your Account Protected.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelMedium,
        ), // Text
        const SizedBox(height: Sizes.spaceBtwSections),
        /// Buttons
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              context.goNamed('login');
            },
            child: const Text(TTexts.done),
          ),
        ), // SizedBox
        const SizedBox(height: Sizes.spaceBtwItems),

        SizedBox(
          width: double.infinity,
          child: IconButton(
            onPressed: () {
              context.goNamed('login');
            },
            icon: const Icon(CupertinoIcons.clear),
          ),
        ), // SizedBox
      ],
    );
  }
}
