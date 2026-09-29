import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../widgets/create_banner_form.dart';

class CreateBannerMobileScreen extends StatelessWidget {
  const CreateBannerMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Banner',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: TSizes.spaceBtwSections / 2),

              // Form
              const CreateBannerForm(),
            ],
          ), // Column
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}
