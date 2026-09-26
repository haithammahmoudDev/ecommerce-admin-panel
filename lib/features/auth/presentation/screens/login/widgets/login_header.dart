import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/constants/text_strings.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          const Image(width: 100, height: 100, image: AssetImage('assets/logos/t-store-splash-logo-black.png')),
          const SizedBox(height: TSizes.spaceBtwSections),
          Text(TTexts.tLoginTitle, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: TSizes.sm),
          Text(TTexts.tLoginSubTitle, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
