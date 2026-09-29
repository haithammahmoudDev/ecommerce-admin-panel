import 'package:flutter/material.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../widgets/create_brand_form.dart';

class CreateBrandDesktopScreen extends StatelessWidget {
  const CreateBrandDesktopScreen({super.key});

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
                'Create Brand',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: TSizes.spaceBtwSections / 2),
              // Form
              const CreateBrandForm(),
            ],
          ), // Column
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}
