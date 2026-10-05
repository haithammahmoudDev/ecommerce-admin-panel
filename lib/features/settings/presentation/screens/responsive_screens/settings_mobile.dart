import 'package:flutter/material.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../widgets/image_meta.dart';
import '../widgets/setting_form.dart';

class SettingsMobileScreen extends StatelessWidget {
  const SettingsMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: Sizes.spaceBtwSections / 2),

              const Column(
                children: [
                   ImageAndMeta(),
                   SizedBox(height: Sizes.spaceBtwSections),

                   SettingsForm(),
                ],
              ),
            ],
          ), // Column
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}
