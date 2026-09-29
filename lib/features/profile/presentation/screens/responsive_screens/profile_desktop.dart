import 'package:flutter/material.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../widgets/form.dart';
import '../widgets/image_meta.dart';


class ProfileDesktopScreen extends StatelessWidget {
  const ProfileDesktopScreen({super.key});

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
                'Profile',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: Sizes.spaceBtwSections / 2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const Expanded(
                    child: ImageAndMeta(),
                  ),
                  const SizedBox(width: Sizes.spaceBtwSections),
                  Expanded(
                    flex: 2,
                    child: const ProfileForm(),
                  ),
                ],
              ), // Row
            ],
          ), // Column
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}
